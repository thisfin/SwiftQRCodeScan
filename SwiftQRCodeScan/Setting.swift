//
//  Setting.swift
//  SwiftQRCodeScan
//
//  Created by 李毅 on 2020/7/14.
//

import Foundation

class Setting {
    @UserDefaultsWrapper("shock", defaultValue: false)
    var shock: Bool

    static let shared = Setting()
}
