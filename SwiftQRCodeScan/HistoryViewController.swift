//
//  HistoryViewController.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2016/11/8.
//  Copyright © 2016年 wenyou. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import WYKit

class HistoryViewController: UIViewController {
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.automaticallyAdjustsScrollViewInsets = false               // scrollView 遮挡
        self.navigationController?.navigationBar.isTranslucent = false  // navigation 遮挡
        self.tabBarController?.tabBar.isTranslucent = false             // tabbar 遮挡
//        self.edgesForExtendedLayout = []

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            button.titleLabel?.font = WYIconfont.fontOfSize(20)
            button.setTitle(Constants.iconfontDelete, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.addTarget(self, action: #selector(deleteButtonClicked(_:)), for: .touchUpInside)
            return button
        }())

        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view)
                make.left.equalTo(self.view)
                make.right.equalTo(self.view)
                make.bottom.equalTo(self.view.safeAreaInsets.bottom)
            } else {
                make.edges.equalTo(self.view)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HistoryDataCache.sharedInstance.getCacheValues().count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        }
        cell?.textLabel?.text = HistoryDataCache.sharedInstance.getCacheValues().object(at: indexPath.row) as? String
        return cell!
    }
}

extension HistoryViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        HistoryDataCache.sharedInstance.deleteCacheValue(atIndex: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ScanViewController.handleValue(HistoryDataCache.sharedInstance.getCacheValues().object(at: indexPath.row) as! String, viewController: self, endBlock: nil)
    }
}

@objc extension HistoryViewController {
    private func deleteButtonClicked(_ sender: AnyObject) {
        self.present({
            let controller = UIAlertController(title: "确认全部删除", message: nil, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                HistoryDataCache.sharedInstance.deleteCacheValueAll()
                self.tableView.reloadData()
            }))
            controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            return controller
        }(), animated: true, completion: nil)
    }
}
