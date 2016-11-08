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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.colorWithHexValue(0x000000, alpha: 80)
        
        let outPath: UIBezierPath = UIBezierPath(rect: frame)
        let size = frame.size
        let width = size.width - 50 * 2
        let inPath = UIBezierPath(rect: CGRect.init(x: 50, y: (size.height - width) / 2, width: width, height: width))
        outPath.append(inPath)
        outPath.usesEvenOddFillRule = true
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = outPath.cgPath
        self.layer.mask = shapeLayer
    }
    
    override func draw(_ rect: CGRect) {
        
    }
//    - (void)drawRect:(CGRect)rect {
//    const CGFloat lineWidth = 4;
//    const CGFloat lineLenght = 20;
//    
//    CGSize size = self.frame.size;
//    CGFloat width = size.width - 50 * 2;
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [COLOR_BIANCHI setStroke];
//    [path setLineWidth:4];
//    
//    [path moveToPoint:CGPointMake(50 - lineWidth / 2, (size.height - width) / 2 + lineLenght)];
//    [path addLineToPoint:CGPointMake(50 - lineWidth / 2, (size.height - width) / 2 - lineWidth / 2)];
//    [path addLineToPoint:CGPointMake(50 - lineWidth / 2 + lineLenght, (size.height - width) / 2 - lineWidth / 2)];
//    
//    [path moveToPoint:CGPointMake(size.width - 50 - lineLenght, (size.height - width) / 2 - lineWidth / 2)];
//    [path addLineToPoint:CGPointMake(size.width - 50 + lineWidth / 2, (size.height - width) / 2 - lineWidth / 2)];
//    [path addLineToPoint:CGPointMake(size.width - 50 + lineWidth / 2, (size.height - width) / 2 + lineLenght)];
//    
//    [path moveToPoint:CGPointMake(size.width - 50 + lineWidth / 2, (size.height + width) / 2 - lineLenght)];
//    [path addLineToPoint:CGPointMake(size.width - 50 + lineWidth / 2, (size.height + width) / 2 + lineWidth / 2)];
//    [path addLineToPoint:CGPointMake(size.width - 50 - lineLenght, (size.height + width) / 2 + lineWidth / 2)];
//    
//    [path moveToPoint:CGPointMake(50 - lineWidth / 2 + lineLenght, (size.height + width) / 2 + lineWidth / 2)];
//    [path addLineToPoint:CGPointMake(50 - lineWidth / 2, (size.height + width) / 2 + lineWidth / 2)];
//    [path addLineToPoint:CGPointMake(50 - lineWidth / 2, (size.height + width) / 2 - lineLenght)];
//    
//    [path stroke];
//    }

}
