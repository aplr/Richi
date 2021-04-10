//
//  Sequence+InvalidateKeyValueObservation.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 09.04.21.
//

import Foundation

extension Sequence where Element == NSKeyValueObservation {
    
    func invalidateAll() {
        forEach({ $0.invalidate() })
    }
    
}
