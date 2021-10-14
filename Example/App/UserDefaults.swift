//
//  UserDefaults.swift
//  App
//
//  Created by Andreas Pfurtscheller on 14.10.21.
//

import Foundation

extension UserDefaults {
    @objc dynamic var playerType: String? {
        get {
            string(forKey: "playerType")
        } set {
            set(newValue, forKey: "playerType")
        }
    }
    
    @objc dynamic var firstRun: Bool {
        get {
            bool(forKey: "firstRun")
        } set {
            set(newValue, forKey: "firstRun")
        }
    }
}
