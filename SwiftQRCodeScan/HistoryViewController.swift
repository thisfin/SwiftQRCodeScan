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
import RxCocoa
import RxSwift
import RxDataSources


class HistoryViewController: ViewController {
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "扫描记录"

//        self.automaticallyAdjustsScrollViewInsets = false               // scrollView 遮挡
//        self.navigationController?.navigationBar.isTranslucent = false  // navigation 遮挡
//        self.tabBarController?.tabBar.isTranslucent = false             // tabbar 遮挡
//        self.edgesForExtendedLayout = []

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIButton(type: .custom).then {
            $0.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            $0.titleLabel?.font = Iconfont.fontOfSize(20, fontInfo: Iconfont.solidFont)
            $0.setTitle("\u{f2ed}", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.rx.tap.subscribe(onNext: { [weak self] () in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.present(UIAlertController(title: "确认全部删除", message: nil, preferredStyle: .actionSheet).then {
                    $0.addAction(UIAlertAction(title: "确定", style: .default, handler: { [weak self] (action) in
                        guard let strongSelf = self else {
                            return
                        }
                        HistoryDataCache.sharedInstance.deleteCacheValueAll()
                        strongSelf.tableView.reloadData()
                    }))
                    $0.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                }, animated: true, completion: nil)
            }).disposed(by: rx.disposeBag)
        })

        tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HistoryDataCache.sharedInstance.getCacheValues().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "") ?? UITableViewCell(style: .value1, reuseIdentifier: "")
        cell.textLabel?.text = HistoryDataCache.sharedInstance.getCacheValues()[indexPath.row]
        return cell
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
        ScanViewController.handleValue(HistoryDataCache.sharedInstance.getCacheValues()[indexPath.row], viewController: self, endBlock: nil)
    }
}
