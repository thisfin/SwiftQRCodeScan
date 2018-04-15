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
import RxCocoa
import RxSwift
import RxDataSources


class HistoryViewController: UIViewController {
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.automaticallyAdjustsScrollViewInsets = false               // scrollView 遮挡
        self.navigationController?.navigationBar.isTranslucent = false  // navigation 遮挡
        self.tabBarController?.tabBar.isTranslucent = false             // tabbar 遮挡
//        self.edgesForExtendedLayout = []

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIButton(type: .custom).then {
            $0.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            $0.titleLabel?.font = WYIconfont.fontOfSize(20)
            $0.setTitle(Constants.iconfontDelete, for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.rx.tap.subscribe(onNext: { [weak self] () in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.present(UIAlertController(title: "确认全部删除", message: nil, preferredStyle: .alert).then {
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

//        let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, String>>(
//            animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .fade),
//            configureCell: { (dataSource, tableView, indexPath, element) -> UITableViewCell in
//                let cell = tableView.dequeueReusableCell(withIdentifier: "") ?? UITableViewCell(style: .value1, reuseIdentifier: "")
//                if let label = cell.textLabel {
//                    label.text = HistoryDataCache.sharedInstance.getCacheValues()[indexPath.row]
//                }
//                return cell
//        },titleForHeaderInSection: { (dataSource, indexPath) in return "aaa" },
//          titleForFooterInSection: { (dataSource, indexPath) in return "bbb" },
//            canEditRowAtIndexPath: { (dataSource, indexPath) -> Bool in
//                return true
//        })
//
//        let items = Observable.just([AnimatableSectionModel<String, String>(model: "", items: HistoryDataCache.sharedInstance.getCacheValues())])
//        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)
//
//        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
//            ScanViewController.handleValue(HistoryDataCache.sharedInstance.getCacheValues()[indexPath.row], viewController: self, endBlock: nil)
//        }).disposed(by: rx.disposeBag)
//
//
//        tableView.rx.itemDeleted.subscribe(onNext: { (indexPath) in
//            HistoryDataCache.sharedInstance.deleteCacheValue(atIndex: indexPath.row)
////            self.tableView.deleteRows(at: [indexPath], with: .fade)
//        }).disposed(by: rx.disposeBag)
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
        cell?.textLabel?.text = HistoryDataCache.sharedInstance.getCacheValues()[indexPath.row]
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
        ScanViewController.handleValue(HistoryDataCache.sharedInstance.getCacheValues()[indexPath.row], viewController: self, endBlock: nil)
    }
}
