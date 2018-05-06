//
//  UIViewController+Help.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2018/5/6.
//  Copyright © 2018年 wenyou. All rights reserved.
//

import UIKit

extension UIViewController {
    var backButtonTitle: String? {
        set {
            if let navigationController = self.navigationController {
                if let navigationItem = navigationController.navigationBar.topItem {
                    navigationItem.backBarButtonItem = UIBarButtonItem(title: newValue ?? "", style: .plain, target: nil, action: nil)
                } else if let navigationItem = navigationController.navigationBar.backItem {
                    navigationItem.title = newValue ?? ""
                }
            }
        }
        get {
            return nil
        }
    }
}
