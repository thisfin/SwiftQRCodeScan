//
//  Tool.swift
//  SwiftQRCodeScan
//
//  Created by 李毅 on 2021/6/1.
//

import Foundation

/// 基础扩展
public struct Tool<Base> {
    /// 包装类型
    public let base: Base
    /// 初始化
    public init(_ base: Base) {
        self.base = base
    }
}

/// 扩展协议
public protocol ToolCompatible {
    /// 包装类型
    associatedtype CompatibleType
    /// 对象扩展
    var tool: Tool<CompatibleType> { get }
    /// 类扩展
    static var tool: Tool<CompatibleType>.Type { get }
}

/// 默认协议实现
public extension ToolCompatible {
    /// 对象扩展
    var tool: Tool<Self> {
        get {
            return Tool(self)
        }
        set { }
    }

    /// 类扩展
    static var tool: Tool<Self>.Type {
        get {
            return Tool<Self>.self
        }
        set { }
    }
}

extension NSObject: ToolCompatible {}
extension Array: ToolCompatible {}
extension Data: ToolCompatible {}
extension Date: ToolCompatible {}
extension Dictionary: ToolCompatible {}
extension Optional: ToolCompatible {}
extension String: ToolCompatible {}
extension URL: ToolCompatible {}
extension TimeInterval: ToolCompatible {}
