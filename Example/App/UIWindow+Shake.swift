//
//  UIWindow+Shake.swift
//  App
//
//  Created by Andreas Pfurtscheller on 14.10.21.
//

import UIKit

extension NSNotification.Name {
    public static let DeviceDidShake = NSNotification.Name("DeviceDidShakeNotification")
}

extension UIWindow {
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        NotificationCenter.default.post(name: .DeviceDidShake, object: event)
    }
    
}
