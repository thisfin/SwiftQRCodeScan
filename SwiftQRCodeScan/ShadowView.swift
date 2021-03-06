//
//  ShadowView.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2016/11/8.
//  Copyright © 2016年 wenyou. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // TODO: init 和 draw 中的 size 不同, 暂且用 screen 的 size 来做计算
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(hex: 0x000000, alpha: 80 / 255)

        let outPath: UIBezierPath = UIBezierPath(rect: frame)
        let size = UIScreen.main.bounds.size // frame.size
        let width = size.width - 50 * 2
        let inPath = UIBezierPath(rect: CGRect(x: 50, y: (size.height - width) / 2, width: width, height: width)).reversing()
        outPath.append(inPath)
        outPath.usesEvenOddFillRule = true
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = outPath.cgPath
        layer.mask = shapeLayer
    }

    override func draw(_ rect: CGRect) {
        let lineWidth: CGFloat = 4
        let lineLength: CGFloat = 20

        let size = UIScreen.main.bounds.size // frame.size
        let width: CGFloat = size.width - (CGFloat)(50 * 2)
        let path = UIBezierPath()
        UIColor(hex: 0x8BDDD1).setStroke()
        path.lineWidth = 4

        path.move(to: CGPoint(x: 50 - lineWidth / 2, y: (size.height - width) / 2 + lineLength))
        path.addLine(to: CGPoint(x: 50 - lineWidth / 2, y: (size.height - width) / 2 - lineWidth / 2))
        path.addLine(to: CGPoint(x: 50 - lineWidth / 2 + lineLength, y: (size.height - width) / 2 - lineWidth / 2))

        path.move(to: CGPoint(x: size.width - 50 - lineLength, y: (size.height - width) / 2 - lineWidth / 2))
        path.addLine(to: CGPoint(x: size.width - 50 + lineWidth / 2, y: (size.height - width) / 2 - lineWidth / 2))
        path.addLine(to: CGPoint(x: size.width - 50 + lineWidth / 2, y: (size.height - width) / 2 + lineLength))

        path.move(to: CGPoint(x: size.width - 50 + lineWidth / 2, y: (size.height + width) / 2 - lineLength))
        path.addLine(to: CGPoint(x: size.width - 50 + lineWidth / 2, y: (size.height + width) / 2 + lineWidth / 2))
        path.addLine(to: CGPoint(x: size.width - 50 - lineLength, y: (size.height + width) / 2 + lineWidth / 2))

        path.move(to: CGPoint(x: 50 - lineWidth / 2 + lineLength, y: (size.height + width) / 2 + lineWidth / 2))
        path.addLine(to: CGPoint(x: 50 - lineWidth / 2, y: (size.height + width) / 2 + lineWidth / 2))
        path.addLine(to: CGPoint(x: 50 - lineWidth / 2, y: (size.height + width) / 2 - lineLength))

        path.stroke()
    }
}
