//
//  UserDefaultsWrapper.swift
//  SwiftQRCodeScan
//
//  Created by 李毅 on 2021/6/1.
//

import Foundation

/*
 example:
 1. 非可选类型 defaultValue 为必须
 @UserDefaultsWrapper("key2", defaultValue: ["name", "age", "address"])
 private var value2: [String]

 2. 可选类型的 defaultValue 为可选
 @UserDefaultsWrapper("key3", defaultValue: true)
 private var value3: Bool?

 @UserDefaultsWrapper("key1")
 private var value1: String?
 */
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
