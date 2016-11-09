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

//    private static let selfInstance = HistoryDataCache.init()
//
//    public static var sharedInstance: HistoryDataCache {
//        return selfInstance
//    }
//
//    private init() {
//        cacheDatas = NSMutableArray()
//
//        // 缓存目录创建
//        let paths: [String] = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
//        let cdPath = paths.first
//        cacheDirectoryPath = NSURL(fileURLWithPath: cdPath).URLByAppendingPathComponent("LocalCache")
//        if FileManager.default.fileExists(atPath: cacheDirectoryPath) {
//            let tmpArray = nil
//        }
//
//
//            _cacheDatas = [NSMutableArray new];
//
//            // 缓存目录创建
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//            NSString *cdPath = [paths firstObject];
//            _cacheDirectoryPath = [cdPath stringByAppendingPathComponent:@"LocalCache"];
//            if ([[NSFileManager defaultManager] fileExistsAtPath:_cacheDirectoryPath]) {
//                NSMutableArray *tmpArray = [self readCacheFile];
//                if (tmpArray.count) {
//                    _cacheDatas = tmpArray;
//                }
//            } else {
//                [[NSFileManager defaultManager] createDirectoryAtPath:_cacheDirectoryPath withIntermediateDirectories:NO attributes:nil error:nil];
//            }
//        }
//        return self;
//    }

//#pragma mark - public
//- (void)addCacheValue:(NSString *)value {
//    [_cacheDatas insertObject:value atIndex:0];
//    [self writeCacheFile];
//    }
//
//    - (void)deleteCacheValueAtIndex:(NSUInteger)index {
//        [_cacheDatas removeObjectAtIndex:index];
//        [self writeCacheFile];
//        }
//
//        - (void)deleteAllCacheValue {
//            [_cacheDatas removeAllObjects];
//            [self removeCacheFile];
//            }
//
//            - (NSArray *)getCacheValues {
//                return _cacheDatas;
//}


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

    private func writeCacheFile() -> Void {
        weak var weakSelf = self
        DispatchQueue.main.async {
            let filePath = weakSelf?.fileName()
            if (weakSelf?.cacheDatas.count)! > 0 {

            }
        }
    }

    private func removeCacheFile() -> Void {
        weak var weakSelf = self
        DispatchQueue.main.async {
            try! FileManager.default.removeItem(atPath: (weakSelf?.fileName())!)
        }
    }

    - (NSMutableArray *)readCacheFile {
        NSString *filePath = [self fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) { // 文件是否存在
            NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
            if(data && data.length){
                NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                return [[NSMutableArray alloc] initWithArray:array];
            }
        }
        return [NSMutableArray new];
        }

        - (void)writeCacheFile {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                NSString *filePath = [weakSelf fileName];
                if (strongSelf->_cacheDatas.count) { // 是否有数据
                    NSData *data = [NSJSONSerialization dataWithJSONObject:_cacheDatas options:NSJSONWritingPrettyPrinted error:nil];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) { // 文件是否存在
                        [data writeToFile:filePath options:NSDataWritingAtomic error:nil];
                    } else {
                        [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
                    }
                } else {
                    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                }
                });
            }
}
