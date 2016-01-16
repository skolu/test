//
//  TestHelpers.swift
//  Test
//
//  Created by Sergey Kolupaev on 1/15/16.
//  Copyright © 2016 Sergey Kolupaev. All rights reserved.
//

import Foundation

private struct Constants {
    static let letter_0 = UnicodeScalar("0").value
    static let letter_9 = UnicodeScalar("9").value
    static let letter_a = UnicodeScalar("a").value
    static let letter_f = UnicodeScalar("f").value
    static let letter_A = UnicodeScalar("A").value
    static let letter_F = UnicodeScalar("F").value
}

enum StringError: ErrorType {
    case InvalidHexDigit
}

extension String {
    
    func bytesFromHex() throws -> [UInt8] {
        return try self.unicodeScalars.map { (us) -> UInt8 in
            let ch = us.value
            if ch >= Constants.letter_0 && ch <= Constants.letter_9 {
                return numericCast(ch - Constants.letter_0)
            }
            else if ch >= Constants.letter_A && ch <= Constants.letter_F {
                return numericCast(ch - Constants.letter_A) + 10
            }
            else if ch >= Constants.letter_a && ch <= Constants.letter_f {
                return numericCast(ch - Constants.letter_a) + 10
            }
            throw StringError.InvalidHexDigit
        }
        .reduce(([UInt8](), true)) { (var tuple, byte) -> ([UInt8], Bool) in
            if tuple.1 {
                tuple.0.append(byte << 4)
            } else {
                let idx = tuple.0.endIndex.predecessor()
                tuple.0[idx] += byte
            }
            return (tuple.0, !tuple.1)
        }.0
    }
}