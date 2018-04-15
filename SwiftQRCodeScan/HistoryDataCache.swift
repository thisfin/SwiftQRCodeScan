//
//  HistoryDataCache.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2016/11/9.
//  Copyright © 2016年 wenyou. All rights reserved.
//

import Foundation

class HistoryDataCache {
    private var cacheDirectoryPath: String?
    private var cacheDatas = [String]()
    private static let selfInstance = HistoryDataCache.init()

    // 单例范例
    public static var sharedInstance: HistoryDataCache {
        return selfInstance
    }

    private init() {
        // 缓存目录创建
        let paths: [String] = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        if let cdPath = paths.first, let path = NSURL(fileURLWithPath: cdPath).appendingPathComponent("LocalCache")?.path {
            cacheDirectoryPath = path
            if FileManager.default.fileExists(atPath: path) {
                let tmpArray = readCacheFile()
                if tmpArray.count > 0 {
                    cacheDatas = tmpArray
                }
            } else {
                try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: [:])
            }
        }
    }

    // MARK: - public
    public func addCacheValue(_ value: String) {
        cacheDatas.insert(value, at: 0)
        writeCacheFile()
    }

    public func deleteCacheValue(atIndex index: Int) {
        cacheDatas.remove(at: index)
        writeCacheFile()
    }

    public func deleteCacheValueAll() {
        cacheDatas.removeAll()
        removeCacheFile()
    }

    public func getCacheValues() -> [String] {
        return cacheDatas
    }

    // MARK: - private
    private func fileName() -> String? {
        if let path = cacheDirectoryPath {
            return path + "/HistoryCacheData.data"
        }
        return nil
    }

    private func readCacheFile() -> [String] {
        if let fileName = fileName(),
            FileManager.default.fileExists(atPath: fileName),
            let data: Data = try? Data(contentsOf: URL(fileURLWithPath: fileName), options: .mappedIfSafe),
            data.count > 0,
            let array = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String] {
            return array
        }
        return []
    }

    private func writeCacheFile() {
        DispatchQueue.main.async { [weak self] () in
            guard let strongSelf = self else {
                return
            }
            if let filePath = strongSelf.fileName() {
                let cacheDatas = strongSelf.cacheDatas
                if cacheDatas.count > 0, let data: Data = try? JSONSerialization.data(withJSONObject: cacheDatas, options: .prettyPrinted) {
                    if FileManager.default.fileExists(atPath: filePath) {
                        try? data.write(to: URL(fileURLWithPath: filePath), options: .atomic)
                    } else {
                        FileManager.default.createFile(atPath: filePath, contents: data, attributes: [:])
                    }
                } else {
                    try? FileManager.default.removeItem(atPath: filePath)
                }
            }
        }
    }

    private func removeCacheFile() {
        DispatchQueue.main.async { [weak self] () in
            guard let strongSelf = self else {
                return
            }
            if let fileName = strongSelf.fileName(), FileManager.default.fileExists(atPath: fileName) {
                try? FileManager.default.removeItem(atPath: fileName)
            }
        }
    }
}
