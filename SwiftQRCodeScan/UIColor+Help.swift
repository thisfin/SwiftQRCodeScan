//
//  UIColor+Help.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2018/5/21.
//  Copyright © 2018年 wenyou. All rights reserved.
//

import UIKit

extension UIColor {
    public static func colorWithHexValue(_ hexValue: UInt, alpha: UInt = 255) -> UIColor {
        let r: CGFloat = CGFloat((hexValue & 0x00FF0000) >> 16) / 255
        let g: CGFloat = CGFloat((hexValue & 0x0000FF00) >> 8) / 255
        let b: CGFloat = CGFloat(hexValue & 0x000000FF) / 255
        let a: CGFloat = CGFloat(alpha) / 255
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
