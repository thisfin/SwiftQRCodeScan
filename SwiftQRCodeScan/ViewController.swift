//
//  ViewController.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2018/5/6.
//  Copyright © 2018年 wenyou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.backButtonTitle = nil
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.navigationBar.isTranslucent = true
    }
}
