//
//  UserDefaultsWrapper.swift
//  SwiftQRCodeScan
//
//  Created by 李毅 on 2020/7/13.
//

import Foundation

@propertyWrapper public struct UserDefaultsWrapper<T> {
    private var defaultValue: T?
    private var key: String

    public var wrappedValue: T {
        get {
            return (UserDefaults.standard.value(forKey: key) as? T) ?? _defaultValue()
        }
        set {
            if let t = newValue as? OptionalProtocol, t.isNil() {
                UserDefaults.standard.removeObject(forKey: key)
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.set(newValue, forKey: key)
                UserDefaults.standard.synchronize()
            }
        }
    }

    public init<Wrapped>(_ key: String, defaultValue: T? = nil) where T == Optional<Wrapped> { // 通过 where 语句做重载
        self.key = key
        self.defaultValue = defaultValue
    }

    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

private extension UserDefaultsWrapper {
    func _defaultValue() -> T {
        guard let defaultValue = defaultValue else {
            fatalError()
        }
        return defaultValue
    }

    func _defaultValue() -> T where T: OptionalProtocol {
        if let defaultValue = defaultValue {
            return defaultValue
        }
        return T.emptyValue() // this is optional nil
    }
}

fileprivate protocol OptionalProtocol {
    func isNil() -> Bool

    static func emptyValue() -> Self
}

extension Optional: OptionalProtocol {
    func isNil() -> Bool {
        return self == nil
    }

    static func emptyValue() -> Self {
        return .none
    }
}
