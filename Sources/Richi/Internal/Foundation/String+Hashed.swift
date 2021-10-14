//
//  String+Hashed.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 11.10.21.
//

import Foundation
import CommonCrypto

extension String {
    
    /// Calculates SHA256 from the given string and returns its hex representation.
    ///
    /// ```swift
    /// print("http://test.com".sha256)
    /// // prints "50334ee0b51600df6397ce93ceed4728c37fee4e"
    /// ```
    var sha256: String? {
        guard !isEmpty, let input = self.data(using: .utf8) else {
            return nil
        }

        let hash = input.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            CC_SHA256(bytes.baseAddress, CC_LONG(input.count), &hash)
            return hash
        }

        return hash.map({ String(format: "%02x", $0) }).joined()
    }
    
}
