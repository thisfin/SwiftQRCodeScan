//
//  HistoryDataCache.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2016/11/9.
//  Copyright © 2016年 wenyou. All rights reserved.
//

import Foundation

class HistoryDataCache {
    private var cacheDirectoryPath: String
    private var cacheDatas: NSMutableArray
    private static let selfInstance = HistoryDataCache.init()

    // 单例范例
    public static var sharedInstance: HistoryDataCache {
        return selfInstance
    }

    private init() {
        cacheDatas = NSMutableArray()

        // 缓存目录创建
        let paths: [String] = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cdPath = paths.first

        cacheDirectoryPath = (NSURL(fileURLWithPath: cdPath!).appendingPathComponent("LocalCache")?.path)!
        if FileManager.default.fileExists(atPath: cacheDirectoryPath) {
            let tmpArray = readCacheFile()
            if tmpArray.count > 0 {
                cacheDatas = tmpArray
            }
        } else {
            try! FileManager.default.createDirectory(atPath: cacheDirectoryPath, withIntermediateDirectories: false, attributes: [:])
        }
    }

    // MARK: - public
    public func addCacheValue(_ value: String) {
        cacheDatas.insert(value, at: 0)
        writeCacheFile()
    }

    public func deleteCacheValue(atIndex index: Int) {
        cacheDatas.removeObject(at: index)
        writeCacheFile()
    }

    public func deleteCacheValueAll() {
        cacheDatas.removeAllObjects()
        removeCacheFile()
    }

    public func getCacheValues() -> NSArray {
        return cacheDatas
    }

    // MARK: - private
    private func fileName() -> String {
        return cacheDirectoryPath + "/HistoryCacheData.data"
    }

    private func readCacheFile() -> NSMutableArray {
        if FileManager.default.fileExists(atPath: fileName()) {
            let data: Data = try! Data(contentsOf: URL(fileURLWithPath: fileName()), options: .mappedIfSafe)
            if data.count > 0 {
                let array: NSArray = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSArray
                return NSMutableArray(array: array)
            }
        }
        return NSMutableArray()
    }

    private func writeCacheFile() {
        weak var weakSelf = self
        DispatchQueue.main.async {
            let filePath: String? = weakSelf?.fileName()
            if (weakSelf?.cacheDatas.count)! > 0 {
                let data: Data = try! JSONSerialization.data(withJSONObject: weakSelf?.cacheDatas as Any, options: .prettyPrinted)
                if FileManager.default.fileExists(atPath: filePath!) {
                    try! data.write(to: URL(fileURLWithPath: filePath!), options: .atomic)
                } else {
                    FileManager.default.createFile(atPath: filePath!, contents: data, attributes: [:])
                }
            } else {
                try! FileManager.default.removeItem(atPath: filePath!)
            }
        }
    }

    private func removeCacheFile() {
        weak var weakSelf = self
        DispatchQueue.main.async {
            try! FileManager.default.removeItem(atPath: (weakSelf?.fileName())!)
        }
    }
}
