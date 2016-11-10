//
//  WYIconfont.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2016/11/8.
//  Copyright © 2016年 wenyou. All rights reserved.
//

import Foundation
import CoreText
import UIKit

class WYIconfont: NSObject {
    private static var fontName = "FontAwesome";
    private static var fontPath = "fontawesome-webfont_4.6.3";

    private static var oneTimeThing: () = {
        let frameworkBundle: Bundle = Bundle(for: WYIconfont.classForCoder())
        let path: String? = frameworkBundle.path(forResource: WYIconfont.fontPath, ofType: "ttf")
        if let dynamicFontData = NSData(contentsOfFile: path!) {
            let dataProvider: CGDataProvider? = CGDataProvider(data: dynamicFontData)
            let font: CGFont? = CGFont(dataProvider!)
            var error: Unmanaged<CFError>? = nil

            if !CTFontManagerRegisterGraphicsFont(font!, &error) {
                let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue());
                NSLog("Failed to load font: %@", errorDescription as String);
            }
            error?.release();
        }
    }();

    // MARK: - public
    public static func setFont(fontPath: String, fontName: String) {
        WYIconfont.fontPath = fontPath
        WYIconfont.fontName = fontName
    }

    public static func fontOfSize(_ fontSize: CGFloat) -> UIFont {
        _ = oneTimeThing

        let font: UIFont? = UIFont(name: WYIconfont.fontName, size: fontSize)
        assert(font != nil, WYIconfont.fontName + " couldn't be loaded")
        return font!
    }

    public static func imageWithIcon(content: String, backgroundColor: UIColor = UIColor.clear, iconColor: UIColor = UIColor.white, size: CGSize) -> UIImage {
        // 逐步缩小算字号
        var fontSize: Int!
        let constraintSize = CGSize(width: size.width, height: CGFloat(MAXFLOAT))
        for i in stride(from: 500, to: 5, by: -2) {
            let rect = content.boundingRect(with: constraintSize,
                                            options: NSStringDrawingOptions.usesFontLeading,
                                            attributes: [NSFontAttributeName: WYIconfont.fontOfSize(CGFloat(i))],
                                            context: nil)
            fontSize = i;
            if rect.size.height <= size.height {
                break;
            }
        }
        // 绘制
        let textRext = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        backgroundColor.setFill()
        UIBezierPath(rect: textRext).fill()
        content.draw(in:textRext, withAttributes: [NSFontAttributeName: WYIconfont.fontOfSize(CGFloat(fontSize)),
                                                   NSForegroundColorAttributeName: iconColor,
                                                   NSBackgroundColorAttributeName: backgroundColor,
                                                   NSParagraphStyleAttributeName: {
                                                    let style = NSMutableParagraphStyle()
                                                    style.alignment = NSTextAlignment.center
                                                    return style}()])
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }

    public static func imageWithIcon(content: String, backgroundColor: UIColor = UIColor.clear, iconColor: UIColor = UIColor.white, fontSize: CGFloat) -> UIImage {
        let attributes = [NSFontAttributeName: WYIconfont.fontOfSize(fontSize),
                          NSForegroundColorAttributeName: iconColor,
                          NSBackgroundColorAttributeName: backgroundColor,
                          NSParagraphStyleAttributeName: {
                            let style = NSMutableParagraphStyle()
                            style.alignment = NSTextAlignment.center
                            return style}()]

        var size = content.size(attributes: attributes)
        size = CGSize(width: size.width * 1.1, height: size.height * 1.05)

        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        backgroundColor.setFill()
        UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size)).fill()
        content.draw(at: CGPoint(x: size.width * 0.05, y: size.height * 0.025), withAttributes: attributes);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
}
