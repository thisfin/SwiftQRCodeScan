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

    static var shared: UserDefaultsHelp {
        return selfInstance
    }

    private init() {
    }

    @UserDefaultsWrapper("isShock", defaultValue: false)
    var shock: Bool
}
