//
//  AppDelegate.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2016/11/8.
//  Copyright © 2016年 wenyou. All rights reserved.
//

import UIKit
import WYKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
//        window = UIWindow(frame: UIScreen.main.bounds)
        window?.screen = UIScreen.main
        window?.rootViewController = {
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [
                {
                    let controller = ScanViewController()
                    controller.title = "扫描"
                    controller.tabBarItem.image = WYIconfont.imageWithIcon(content: Constants.iconfontScan, fontSize: 24)
                    return controller
                }(), {
                    let controller = HistoryViewController()
                    controller.title = "历史"
                    controller.tabBarItem.image = nil
                    controller.tabBarItem.image = WYIconfont.imageWithIcon(content: Constants.iconfontHistory, fontSize: 24)
                    let navController = UINavigationController(rootViewController: controller)
                    return navController
                }()]
            tabBarController.tabBar.barStyle = UIBarStyle.black
            tabBarController.tabBar.tintColor = Constants.colorBianchi
            return tabBarController
        }()
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
