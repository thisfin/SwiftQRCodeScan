//
//  AppDelegate.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2016/11/8.
//  Copyright © 2016年 wenyou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.screen = UIScreen.main
        
        let tabBarController: UITabBarController = UITabBarController()
        tabBarController.viewControllers = [
            {
                let controller: ScanViewController = ScanViewController()
                controller.title = "扫描";
                controller.tabBarItem.image = WYIconfont.imageWithIcon(content: "\u{f029}", fontSize: 24)
                return controller;
            }(), {
                let controller: HistoryViewController = HistoryViewController()
                controller.title = "历史";
                controller.tabBarItem.image = nil
                controller.tabBarItem.image = WYIconfont.imageWithIcon(content: "\u{f03a}", fontSize: 24)
                let navController: UINavigationController = UINavigationController.init(rootViewController: controller)
                return navController
            }()]
        tabBarController.tabBar.barStyle = UIBarStyle.black
        tabBarController.tabBar.tintColor = UIColor.blue
        
        window?.rootViewController = tabBarController;
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
