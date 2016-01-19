//
//  Der.swift
//  Test
//
//  Created by Sergey Kolupaev on 1/13/16.
//  Copyright © 2016 Sergey Kolupaev. All rights reserved.
//

import Foundation

struct Der {
    static let EOC:UInt8                = 0x00
    static let BOOLEAN:UInt8            = 0x01
    static let INTEGER:UInt8            = 0x02
    static let BIT_STRING:UInt8         = 0x03
    static let OCTET_STRING:UInt8       = 0x04
    static let NULL:UInt8               = 0x05
    static let OBJECT_IDENTIFIER:UInt8  = 0x06
    static let REAL:UInt8               = 0x09
    static let UTF8_String:UInt8        = 0x0c
    static let SEQUENCE:UInt8           = 0x10
    static let SET:UInt8                = 0x11
    static let NumericString:UInt8      = 0x12
    static let PrintableString:UInt8    = 0x13
    static let T61String:UInt8          = 0x14
    static let IA5_String:UInt8         = 0x16
    static let UTCTime:UInt8            = 0x17
    static let GeneralizedTime:UInt8    = 0x18
    static let BMP_String:UInt8         = 0x1d
    
    static let TypeMask:UInt8           = 0b0001_1111
    static let ContextMask:UInt8        = 0b1100_0000
    static let Constructed:UInt8        = 0b0010_0000
    static let ContextSpecific:UInt8    = 0b1000_0000
    
    enum DataTypes {
        case Integer, Real, BitString, OctetString, Other
    }
    
    enum StringTypes {
        case Utf8String, NumericString, PrintableString, T61String, IA5_String, BmpString
        
        func encoding() -> UInt {
            switch self {
            case .Utf8String:
                return NSUTF8StringEncoding
            case .BmpString:
                return NSUTF16StringEncoding
            case .IA5_String, .PrintableString, .NumericString:
                return NSASCIIStringEncoding
            case .T61String:
                return NSISOLatin1StringEncoding
            }
        }
    }
    
    enum TimeTypes {
        case UTCTime, GeneralizedTime
        
        func formatter() -> NSDateFormatter {
            switch self {
            case .UTCTime:
                if TimeTypes.utcFormatter == nil {
                    TimeTypes.utcFormatter = NSDateFormatter()
                    TimeTypes.utcFormatter!.timeZone = NSTimeZone(name: "UTC")
                    TimeTypes.utcFormatter!.dateFormat = "yyMMddHHmmss'Z'"
                }
                return TimeTypes.utcFormatter!
            case .GeneralizedTime:
                if TimeTypes.generalizedFormatter == nil {
                    TimeTypes.generalizedFormatter = NSDateFormatter()
                    TimeTypes.utcFormatter!.timeZone = NSTimeZone(name: "UTC")
                    TimeTypes.generalizedFormatter!.dateFormat = "yyyyMMddHHmmss'Z'"
                }
                return TimeTypes.generalizedFormatter!
            }
        }
        
        private static var utcFormatter: NSDateFormatter? = nil
        private static var generalizedFormatter: NSDateFormatter? = nil
    }
    
    enum CollectionTypes {
        case Sequence, Set
    }
}

enum DerError: ErrorType {
    case Unimplemented
    case UnsupportedTag(UInt8)
    case InvalidData(String)
}

enum DerNode: CustomStringConvertible {
    case NULL()
    case BOOLEAN(value:Bool)
    case DATA(type:Der.DataTypes, value:[UInt8])
    case STRING(type:Der.StringTypes, value:String)
    case OBJECT_IDENTIFIER(value:[UInt])
    case TIME(type:Der.TimeTypes, value:NSDate)
    case IMPLICIT(number:UInt8, value:[UInt8])
    
    indirect case EXPLICIT(number:UInt8, value:DerNode)
    indirect case ARRAY(type:Der.CollectionTypes, value:[DerNode])
    
    var tag:UInt8 {
        get {
            var result: UInt8 = 0
            var contextSpecific: Bool = false
            var constructed: Bool = false
            switch self {
            case BOOLEAN:
                result = Der.BOOLEAN
            case let DATA(type: t, value: _):
                switch t {
                case .Integer:
                    result = Der.INTEGER
                case .Real:
                    result = Der.REAL
                case .BitString:
                    result = Der.BIT_STRING
                case .OctetString:
                    result = Der.OCTET_STRING
                case .Other:
                    result = Der.EOC
                }
            case NULL:
                result = Der.NULL
            case let STRING(type: t, value: _):
                switch t {
                case .Utf8String:
                    result = Der.UTF8_String
                case .IA5_String:
                    result = Der.IA5_String
                case .T61String:
                    result = Der.T61String
                case .PrintableString:
                    result = Der.PrintableString
                case .BmpString:
                    result = Der.BMP_String
                case .NumericString:
                    result = Der.NumericString
                }
            case OBJECT_IDENTIFIER:
                result = Der.OBJECT_IDENTIFIER
            case let TIME(type: t, value: _):
                switch t {
                case .UTCTime:
                    result = Der.UTCTime
                case .GeneralizedTime:
                    result = Der.GeneralizedTime
                }
            case let IMPLICIT(number: n, value: _):
                result = n & 0x1f
                contextSpecific = true
            case let EXPLICIT(number: n, value: _):
                result = n & 0x1f
                contextSpecific = true
                constructed = true
            case let ARRAY(type:t, value:_):
                switch t {
                case .Sequence:
                    result = Der.SEQUENCE
                case .Set:
                    result = Der.SET
                }
                constructed = true
            }
            
            return (contextSpecific ? Der.ContextSpecific : 0x00) | (constructed ? Der.Constructed : 0x00) | result
        }
    }
    
    var description: String {
        get {
            return self.dump(0)
        }
    }
    
    private func dump(tabs:Int) -> String {
        var result = String(count: tabs*2, repeatedValue: UnicodeScalar(" "))
        var type: String = ""
        var value:String = ""
        var inlineValue:Bool = true
        switch self {
        case .NULL:
            type = "NULL"
        case let .DATA(type: t, value: v):
            type = "\(t)"
            value = v.prefix(20).map({ (byte) -> String in
                return String(format:"%02X", byte)
            }).joinWithSeparator("")
            if v.count > 20 {
                value += "..."
            }
        case let .BOOLEAN(value:v):
            type = "BOOLEAN"
            value = "\(v)"
        case let .STRING(type: t, value: v):
            type = "\(t)"
            let len = v.unicodeScalars.count
            if len < 40 {
                value = v
            } else {
                value = v.substringToIndex(v.startIndex.advancedBy(40)) + "..."
            }
        case let .OBJECT_IDENTIFIER(value:v):
            type = "OID"
            value = v.map({ (int) -> String in
                return String(int)
            }).joinWithSeparator(".")
        case let .TIME(type: t, value: v):
            type = "\(t)"
            value = "\(v)"
        case let .IMPLICIT(number: n, value: v):
            type = "[\(n)] IMPLICIT"
            value = v.prefix(20).map({ (byte) -> String in
                return String(format:"%02X", byte)
            }).joinWithSeparator("")
            if v.count > 20 {
                value += "..."
            }
        case let .EXPLICIT(number: n, value: v):
            type = "[\(n)] EXPLICIT"
            inlineValue = false
            value = v.dump(tabs+1)
        case let .ARRAY(type:t, value:v):
            type = "\(t)"
            inlineValue = false
            value = v.map({ (node) -> String in
                return node.dump(tabs+1)
            }).joinWithSeparator("\n")
        }
        
        result += String(format:"%02X", tag)
        if inlineValue {
            result += " (\(type)) \(value)"
        } else {
            result += " (\(type))\n\(value)"
        }
        return result
    }
}

extension Der {
    private static func encode_length(length: UInt) -> [UInt8] {
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
    private static func encode_int(oid_int: UInt) -> [UInt8] {
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
    static func parse(data: ArraySlice<UInt8>) throws -> DerNode {
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
        let contextSpecific = (tag & ContextMask) == ContextSpecific
        let constructed = (tag & Constructed) == Constructed
        let derType = tag & TypeMask
        let bytes = data[index..<index+length]
        if constructed {
            var offset = 0
            var nodes = [DerNode]()
            while offset < length {
                var l_length = Int(data[index + offset + 1])
                var v_length = 0
                if l_length < 0x80 {
                    v_length = l_length
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
            if contextSpecific {
                if nodes.count != 1 {
                    throw DerError.InvalidData("expected only one EXPLICIT node")
                }
                return DerNode.EXPLICIT(number: derType, value: nodes[0])
            } else {
                return DerNode.ARRAY(type: derType == SET ? .Set : .Sequence, value: nodes)
            }
        } else {
            if contextSpecific {
                return DerNode.IMPLICIT(number: derType, value: [UInt8](bytes))
            } else {
                switch derType {
                case BOOLEAN:
                    if length != 1 {
                        throw DerError.InvalidData("Length of BOOLEAN value is not 1")
                    }
                    return DerNode.BOOLEAN(value: bytes[bytes.startIndex] != 0)
                case INTEGER, REAL, BIT_STRING, OCTET_STRING:
                    var type:DataTypes = .OctetString
                    switch derType {
                    case INTEGER:
                        type = .Integer
                    case REAL:
                        type = .Real
                    case BIT_STRING:
                        type = .BitString
                    default:
                        break
                    }
                    return DerNode.DATA(type: type, value: [UInt8](bytes))
                case NULL:
                    if length != 0 {
                        throw DerError.InvalidData("Length of NULL is not 0")
                    }
                    return DerNode.NULL()
                case OBJECT_IDENTIFIER:
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
                    return DerNode.OBJECT_IDENTIFIER(value: oid)
                    
                case UTF8_String, BMP_String, IA5_String, PrintableString, NumericString, T61String:
                    var type:StringTypes = .Utf8String
                    switch derType {
                    case UTF8_String:
                        type = .Utf8String
                    case BMP_String:
                        type = .BmpString
                    case IA5_String:
                        type = .IA5_String
                    case PrintableString:
                        type = .PrintableString
                    case NumericString:
                        type = .NumericString
                    case T61String:
                        type = .T61String
                    default:
                        break
                    }

                    let encoding = type.encoding()
                    let str = String(bytes: bytes, encoding: encoding)
                    if let s = str {
                        return DerNode.STRING(type: type, value: s)
                    } else {
                        throw DerError.InvalidData("String encoding")
                    }
                    
                case GeneralizedTime, UTCTime:
                    if let str = String(bytes: bytes, encoding: NSUTF8StringEncoding) {
                        let type:TimeTypes = derType == GeneralizedTime ? .GeneralizedTime : .UTCTime
                        if let date = type.formatter().dateFromString(str) {
                            return DerNode.TIME(type: type, value: date)
                        } else {
                            throw DerError.InvalidData("DateTime format")
                        }
                    } else {
                        throw DerError.InvalidData("DateTime string")
                    }
                default:
                    break
                }
            }
        }
        throw DerError.Unimplemented
    }
    
    static func serialize(derNode: DerNode) throws -> [UInt8] {
        var result = [UInt8]()
        
        switch derNode {
        case .NULL:
            break
        case let .BOOLEAN(value: b):
            result.append(b ? 0xff : 0x00)
        case let .DATA(type:_, value: bytes):
            result.appendContentsOf(bytes)
        case let .STRING(type:t, value:s):
            let encoding = t.encoding()
            if let data = s.dataUsingEncoding(encoding) {
                result.appendContentsOf(Repeat<UInt8>(count: data.length, repeatedValue:0))
                data.getBytes(&result, length: result.count)
            } else {
                throw DerError.InvalidData("STRING encoding error")
            }
        case let .OBJECT_IDENTIFIER(ints):
            if ints.count < 2 {
                throw DerError.InvalidData("OBJECT_IDENTIFIER should have at least 2 components")
            }
            for i in 0..<ints.count {
                if i == 0 {
                    result.append(UInt8(ints[0] * 40 + ints[1]))
                }
                else if i > 1 {
                    result.appendContentsOf(encode_int(ints[i]))
                }
            }
        case let .TIME(type:t, value:time):
            let s = t.formatter().stringFromDate(time)
            if let data = s.dataUsingEncoding(NSUTF8StringEncoding) {
                result.appendContentsOf(Repeat<UInt8>(count: data.length, repeatedValue:0))
                data.getBytes(&result, length: result.count)
            } else {
                throw DerError.InvalidData("TIME formatting error")
            }
        case let .IMPLICIT(number:_, value:bytes):
            result.appendContentsOf(bytes)
        case let .EXPLICIT(number:_, value:node):
            result.appendContentsOf(try serialize(node))
        case let .ARRAY(type:_, value:nodes):
            for node in nodes {
                result.appendContentsOf(try serialize(node))
            }
        }
        
        result.insertContentsOf(encode_length(UInt(result.count)), at: 0)
        result.insert(derNode.tag, atIndex: 0)
        return result
    }
}
