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
        let dynamicFontData: NSData? = NSData(contentsOfFile: path!)
        if dynamicFontData == nil {
            return
        }
        let dataProvider: CGDataProvider? = CGDataProvider(data: dynamicFontData!)
        let font: CGFont? = CGFont(dataProvider!)
        var error: Unmanaged<CFError>? = nil

        if (CTFontManagerRegisterGraphicsFont(font!, &error) == false) {
            let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue());
            NSLog("Failed to load font: %@", errorDescription as String);
        }
        error?.release();
    }();

    public static func fontOfSize(_ fontSize: CGFloat) -> UIFont {
        _ = oneTimeThing

        let font: UIFont? = UIFont(name: WYIconfont.fontName, size: fontSize)
        assert(font != nil, WYIconfont.fontName + " couldn't be loaded")
        return font!
    }

    public static func setFont(fontPath: String, fontName: String) {
        WYIconfont.fontPath = fontPath
        WYIconfont.fontName = fontName
    }

    public static func imageWithIcon(content: String, backgroundColor: UIColor = UIColor.clear, iconColor: UIColor = UIColor.white, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        var textRext: CGRect = CGRect.zero
        textRext.size = size

        let path: UIBezierPath = UIBezierPath(rect: textRext)
        backgroundColor.setFill()
        path.fill()

        let fontSize = size.width;
        let font = WYIconfont.fontOfSize(fontSize)

        //        @autoreleasepool {
        //            UILabel *label = [UILabel new];
        //            label.font = font;
        //            label.text = content;
        //            fontSize = [WYIconfont constraintLabelToSize:label size:size maxFontSize:500 minFontSize:5];
        //            font = label.font;
        //        }
        iconColor.setFill()

        let style: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.alignment = NSTextAlignment.center

        content.draw(in:textRext, withAttributes: [NSFontAttributeName: font,
                                                   NSForegroundColorAttributeName: iconColor,
                                                   NSBackgroundColorAttributeName: backgroundColor,
                                                   NSParagraphStyleAttributeName: style
            ])

        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }

    private static func constraintLabelToSize(label: UILabel, size: CGSize, maxFontSize: CGFloat, minFontSize: CGFloat) -> CGFloat {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        label.frame = rect

        var fontSize = maxFontSize

        let constraintSize = CGSize(width: label.frame.size.width, height: CGFloat(MAXFLOAT))

        repeat {
            label.font = WYIconfont.fontOfSize(fontSize)
            let textRect = label.text?.boundingRect(with: constraintSize,
                                                    options: NSStringDrawingOptions.usesFontLeading,
                                                    attributes: [NSFontAttributeName: label.font],
                                                    context: nil)

            if ((textRect?.size.height)! <= label.frame.size.height) {
                break;
            }
            fontSize -= 2;
        } while fontSize > minFontSize

        return fontSize
    }

    public static func imageWithIcon(content: String, backgroundColor: UIColor = UIColor.clear, iconColor: UIColor = UIColor.white, fontSize: CGFloat) -> UIImage {
        let font = WYIconfont.fontOfSize(fontSize)
        let style: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.alignment = NSTextAlignment.center

        let attributes = [NSFontAttributeName : font,
                          NSForegroundColorAttributeName : iconColor,
                          NSBackgroundColorAttributeName : backgroundColor,
                          NSParagraphStyleAttributeName: style]

        var size = content.size(attributes: attributes)
        size = CGSize(width: size.width * 1.1, height: size.height * 1.05)

        var textRext: CGRect = CGRect.zero
        textRext.size = size
        let origin = CGPoint(x: size.width * 0.05, y: size.height * 0.025)

        UIGraphicsBeginImageContextWithOptions(size, false, 0);

        let path = UIBezierPath(rect: textRext)
        backgroundColor.setFill()
        path.fill()

        content.draw(at: origin, withAttributes: attributes);

        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
}
