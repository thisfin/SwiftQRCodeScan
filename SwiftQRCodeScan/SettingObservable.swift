//
//  SettingObservable.swift
//  SwiftQRCodeScan
//
//  Created by 李毅 on 2020/7/14.
//

import Foundation

class SettingObservable: ObservableObject {
    @Published
    var shock: Bool = Setting.shared.shock {
        willSet {
            Setting.shared.shock = newValue
        }
    }
}
