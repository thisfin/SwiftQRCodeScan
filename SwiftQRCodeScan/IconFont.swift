//
//  IconFont.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2018/5/5.
//  Copyright © 2018年 wenyou. All rights reserved.
//

import UIKit

class Iconfont: NSObject {
    static let solidFont = FontInfo(fontName: "Font Awesome 5 Free", fontPath: "fa-solid-900")
    static let brandsFont = FontInfo(fontName: "Font Awesome 5 Brands", fontPath: "fa-brands-400")

    static func fontOfSize(_ fontSize: CGFloat, fontInfo: FontInfo) -> UIFont {
        _ = oneTimeThing

        guard let font = UIFont(name: fontInfo.fontName, size: fontSize) else {
            assert(false, "\(fontInfo.fontName) couldn't be loaded")
            return UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
        return font
    }
}

private extension Iconfont {
    // 字体库注册
    static var oneTimeThing: () = {
        let fonts = [solidFont, brandsFont]
        fonts.forEach { (fontInfo) in
            if let path = Bundle.main.path(forResource: fontInfo.fontPath, ofType: "ttf"),
                let dynamicFontData = NSData(contentsOfFile: path),
                let dataProvider = CGDataProvider(data: dynamicFontData),
                let font = CGFont(dataProvider) {
                var error: Unmanaged<CFError>? = nil
                if !CTFontManagerRegisterGraphicsFont(font, &error) {
                    let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
                    NSLog("Failed to load font: %@", errorDescription as String)
                }
                error?.release()
            }
        }
    }()
}

struct FontInfo {
    var fontName: String;
    var fontPath: String;
}
