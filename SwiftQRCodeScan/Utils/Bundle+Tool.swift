//
//  Bundle+Tool.swift
//  SwiftQRCodeScan
//
//  Created by 李毅 on 2021/6/1.
//

import Foundation

public extension Tool where Base == Bundle {
    var displayName: String? {
        if let dict = Bundle.main.infoDictionary, let value = dict["CFBundleDisplayName"] as? String {
            return value
        }
        return nil
    }

    var version: String? {
        if let dict = Bundle.main.infoDictionary, let value = dict["CFBundleShortVersionString"] as? String {
            return value
        }
        return nil
    }

    var build: String? {
        if let dict = Bundle.main.infoDictionary, let value = dict["CFBundleVersion"] as? String {
            return value
        }
        return nil
    }
}
