//
//  Iconfont.swift
//  SwiftQRCodeScan
//
//  Created by 李毅 on 2020/7/10.
//

import Foundation
import SwiftUI

class Iconfont {
    static let solidFont = FontInfo(fontName: "Font Awesome 5 Free", fontPath: "fa-solid-900")
    static let brandsFont = FontInfo(fontName: "Font Awesome 5 Brands", fontPath: "fa-brands-400")

    static func fontOfSize(_ fontSize: CGFloat, fontInfo: FontInfo) -> Font {
        _ = oneTimeThing

        return Font.custom(fontInfo.fontName, size: fontSize)
    }
}

private extension Iconfont {
    // 字体库注册
    static var oneTimeThing: () = {
        let fonts = [solidFont, brandsFont]
        fonts.forEach { fontInfo in
            if let path = Bundle.main.path(forResource: fontInfo.fontPath, ofType: "ttf"),
                let dynamicFontData = NSData(contentsOfFile: path),
                let dataProvider = CGDataProvider(data: dynamicFontData),
                let font = CGFont(dataProvider) {
                var error: Unmanaged<CFError>?
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
    var fontName: String
    var fontPath: String
}
