//
//  UIView+Rx+Help.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2018/5/14.
//  Copyright © 2018年 wenyou. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIView {
    public var backgroundColor: Binder<UIColor> {
        return Binder(base) { view, backgroundColor in
            view.backgroundColor = backgroundColor
        }
    }
}
