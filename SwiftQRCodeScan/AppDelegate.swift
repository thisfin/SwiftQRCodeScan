//
//  AppDelegate.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2016/11/8.
//  Copyright © 2016年 wenyou. All rights reserved.
//

import UIKit
import Then

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds).then {
            $0.backgroundColor = .white
            $0.rootViewController = UINavigationController(rootViewController: IndexViewController())
            $0.makeKeyAndVisible()
        }
        return true
    }
}
