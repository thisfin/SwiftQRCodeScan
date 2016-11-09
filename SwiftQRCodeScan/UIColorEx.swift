//
//  UIColorEx.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2016/11/8.
//  Copyright © 2016年 wenyou. All rights reserved.
//

import UIKit

extension UIColor {
    public static func colorWithHexValue(_ hexValue: UInt, alpha: UInt = 255) -> UIColor {
        let r: Float = (Float)((hexValue & 0x00FF0000) >> 16) / 255
        let g: Float = (Float)((hexValue & 0x0000FF00) >> 8) / 255
        let b: Float = (Float)(hexValue & 0x000000FF) / 255
        let a: Float = (Float)(alpha / 255)
        return self.init(colorLiteralRed: r, green: g, blue: b, alpha: a)
    }
}
