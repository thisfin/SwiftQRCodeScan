//
//  AppDelegate.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2016/11/8.
//  Copyright © 2016年 wenyou. All rights reserved.
//

import UIKit
import Then
import WYKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow().then {
            $0.screen = UIScreen.main
            $0.backgroundColor = .white
            $0.rootViewController = UITabBarController().then {
                $0.tabBar.barStyle = .black
                $0.tabBar.tintColor = Constants.colorBianchi
                $0.viewControllers = [
                    ScanViewController().then {
                        $0.title = "扫描"
                        $0.tabBarItem.image = WYIconfont.imageWithIcon(content: Constants.iconfontScan, fontSize: 24)
                    },
                    UINavigationController(rootViewController: HistoryViewController().then {
                        $0.title = "历史"
                        $0.tabBarItem.image = WYIconfont.imageWithIcon(content: Constants.iconfontHistory, fontSize: 24)
                    })]
            }
            $0.makeKeyAndVisible()
        }
        return true
    }
}
