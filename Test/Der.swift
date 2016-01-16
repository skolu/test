//
//  Der.swift
//  Test
//
//  Created by Sergey Kolupaev on 1/13/16.
//  Copyright © 2016 Sergey Kolupaev. All rights reserved.
//

import Foundation

enum DerTag: UInt8 {
    case BOOLEAN        = 0x01
    case INTEGER        = 0x02
    case BIT_STRING     = 0x03
    case OCTET_STRING   = 0x04
    case NULL           = 0x05
    case OBJECT_IDENTIFIER  = 0x06
    case UTF8_String     = 0x0c
    case PrintableString    = 0x13
    case IA5_String     = 0x16
    case BMP_String     = 0x1e
    case SEQUENCE       = 0x30
    case SET            = 0x31
}

enum DerNode {
    case BOOLEAN(Bool)
    case INTEGER([UInt8])
    case DATA(Int8, [UInt8])
    case NULL()
    case STRING(DerTag, String)
    case OBJECT_IDENTIFIER([UInt])
    indirect case ARRAY(DerTag, [DerNode])
}

enum DerError: ErrorType {
    case Unimplemented
    case UnsupportedTag(UInt8)
    case InvalidData(String)
}

class Der {
    private class func encode_length(length: UInt) -> [UInt8] {
        if length < 0x80 {
            return [UInt8(length)]
        } else {
            var bytes = [UInt8]()
            var l = length
            while l > 0 {
                bytes.insert(UInt8(l&0xff), atIndex: 0)
                l >>= 8
            }
            bytes.insert(UInt8(bytes.count) | 0x80, atIndex: 0)
            return bytes
        }
    }
    private class func encode_int(oid_int: UInt) -> [UInt8] {
        if oid_int < 0x80 {
            return [UInt8(oid_int)]
        } else {
            var bytes = [UInt8]()
            var l = oid_int
            while l > 0 {
                bytes.insert(UInt8(l&0x7f), atIndex: 0)
                l >>= 7
            }
            for i in 0..<bytes.count - 1 {
                bytes[i] |= 0x80
            }
            return bytes
        }
    }
    
    class func serialize(der: DerNode) throws -> [UInt8] {
        var result = [UInt8]()
        var tag:DerTag = .NULL
        
        switch der {
        case .BOOLEAN(let b):
            result.append(b ? 0xff : 0x00)
            tag = .BOOLEAN
        case .INTEGER(let bytes):
            result.appendContentsOf(bytes)
            tag = DerTag.INTEGER
        case .DATA(let tail, let bytes):
            result.appendContentsOf(bytes)
            if tail != 0 {
                result.insert(tail > 0 ? UInt8(tail) : 0, atIndex: 0)
            }
            tag = tail != 0 ? DerTag.BIT_STRING : DerTag.OCTET_STRING
        case .NULL:
            tag = .NULL
        case .STRING(let t, let s):
            if t == .BMP_String {
                s.utf16.forEach({ (cu) -> () in
                    result.append(UInt8(cu >> 8) & 0xff)
                    result.append(UInt8(cu) & 0xff)
                })
            }
            else if t == .UTF8_String {
                result.appendContentsOf(s.utf8)
            } else {
                s.unicodeScalars.forEach({ (us) -> () in
                    if us.isASCII() {
                        result.append(UInt8(us.value))
                    }
                })
            }
            tag = t
        case .OBJECT_IDENTIFIER(let comps):
            if comps.count < 2 {
                throw DerError.InvalidData("OBJECT_IDENTIFIER should have at least 2 components")
            }
            for i in 0..<comps.count {
                if i == 0 {
                    result.append(UInt8(comps[0] * 40 + comps[1]))
                }
                else if i == 1 {
                }
                else {
                    result.appendContentsOf(encode_int(comps[i]))
                }
            }
            
        case .ARRAY(let t, let nodes):
            for node in nodes {
                result.appendContentsOf(try serialize(node))
            }
            tag = t
        }

        result.insertContentsOf(encode_length(UInt(result.count)), at: 0)
        result.insert(tag.rawValue, atIndex: 0)
        return result
    }
    
    class func parse(data: ArraySlice<UInt8>) throws -> DerNode {
        var index = data.startIndex
        let tag: UInt8 = data[index]
        index++
        var length: Int = 0
        if data[index] < 0x80 {
            length = Int(data[index])
            index++
        } else {
            let count = Int(data[index] & 0x7f)
            index++
            for i in 0..<count {
                length <<= 8
                length += Int(data[index + i])
            }
            index += count
        }
        if index+length != data.endIndex {
            throw DerError.InvalidData("Triplet length")
        }
        
        if let derTag = DerTag(rawValue: tag) {
            switch derTag {
            case .BOOLEAN:
                if length == 1 {
                    return DerNode.BOOLEAN(data[index] != 0)
                }
            case .INTEGER:
                let bytes = data[index..<index+length]
                return DerNode.INTEGER(Array<UInt8>(bytes))
            case .BIT_STRING:
                let unused = data[index]
                if unused >= 8 {
                    throw DerError.InvalidData("Unused bits in BIT_STRING")
                }
                let bytes = data[index+1..<index+length]
                return DerNode.DATA(Int8(unused), [UInt8](bytes))
            case .OCTET_STRING:
                let bytes = data[index..<index+length]
                return DerNode.DATA(0, [UInt8](bytes))
            case .NULL:
                if length != 0 {
                    throw DerError.InvalidData("Length of NULL is not 0")
                }
                return DerNode.NULL()
            case .OBJECT_IDENTIFIER:
                if length == 0 {
                    throw DerError.InvalidData("Length of OBJECT IDENTIFIER is 0")
                }
                var oid = [UInt]()
                oid.append(UInt(data[index]) / 40)
                oid.append(UInt(data[index]) % 40)
                var offset = 1
                var comp:UInt = 0
                while offset < length {
                    let byte = data[index+offset]
                    comp <<= 7
                    comp += UInt(byte & 0x7f)
                    if byte < 0x80 {
                        oid.append(comp)
                        comp = 0
                    }
                    offset++
                }
                return DerNode.OBJECT_IDENTIFIER(oid)
            case .UTF8_String, .BMP_String, .IA5_String, .PrintableString:
                let str = String(bytes: data[index..<index+length], encoding: derTag == .UTF8_String ? NSUTF8StringEncoding : (derTag == .BMP_String ? NSUTF16StringEncoding : NSASCIIStringEncoding))
                if let s = str {
                    return DerNode.STRING(derTag, s)
                } else {
                    throw DerError.InvalidData("String encoding")
                }
            case .SEQUENCE, .SET:
                var offset = 0
                var nodes = [DerNode]()
                while offset < length {
                    //let child_tag = data[index + offset]
                    var l_length:Int = Int(data[index + offset + 1])
                    var v_length = 0
                    if l_length < 0x80 {
                        v_length = Int(l_length)
                        l_length = 1
                    } else {
                        l_length &= 0x7f;
                        let length_bytes = data[index+offset+2..<index+offset+2+l_length]
                        for b in length_bytes {
                            v_length <<= 8
                            v_length += Int(b)
                        }
                        l_length++;
                    }
                    
                    let sub_bytes = data[index+offset..<index+offset+1+l_length+v_length]
                    let node = try parse(sub_bytes)
                    nodes.append(node)
                    offset += 1+l_length+v_length
                }
                return DerNode.ARRAY(derTag, nodes)
            }
        } else {
            throw DerError.UnsupportedTag(data[0])
        }
        throw DerError.Unimplemented
    }
}