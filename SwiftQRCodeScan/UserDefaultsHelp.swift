//
//  UserDefaultsHelp.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2018/5/7.
//  Copyright © 2018年 wenyou. All rights reserved.
//

import Foundation

class UserDefaultsHelp {
    private static let selfInstance = UserDefaultsHelp()

    public static var shared: UserDefaultsHelp {
        return selfInstance
    }

    private init() {
    }

    public var shock: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isShock")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.object(forKey: "isShock") as? Bool ?? false
        }
    }
}
