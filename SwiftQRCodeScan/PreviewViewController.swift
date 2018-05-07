//
//  PreviewViewController.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2018/5/7.
//  Copyright © 2018年 wenyou. All rights reserved.
//

import UIKit
import Then
import SnapKit

class PreviewViewController: ViewController {
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()


        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: UIButton(type: .custom).then {
                $0.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
                $0.titleLabel?.font = Iconfont.fontOfSize(20, fontInfo: Iconfont.solidFont)
                $0.setTitle("\u{f14d}", for: .normal)
                $0.setTitleColor(UIColor.black, for: .normal)
                $0.rx.tap.subscribe(onNext: { [weak self] () in
                    guard let strongSelf = self else {
                        return
                    }
                    if let image = UIImage.init(named: "") {
                        strongSelf.present(UIActivityViewController(activityItems: [image], applicationActivities: nil), animated: true, completion: nil)
                    }
//                    strongSelf.present(UIAlertController(title: "确认全部删除", message: nil, preferredStyle: .actionSheet).then {
//                        $0.addAction(UIAlertAction(title: "确定", style: .default, handler: { [weak self] (action) in
//                            guard let strongSelf = self else {
//                                return
//                            }
//                            HistoryDataCache.sharedInstance.deleteCacheValueAll()
//                            strongSelf.tableView.reloadData()
//                        }))
//                        $0.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
//                    }, animated: true, completion: nil)
                }).disposed(by: rx.disposeBag)
            }),
            UIBarButtonItem(customView: UIButton(type: .custom).then {
                $0.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
                $0.titleLabel?.font = Iconfont.fontOfSize(20, fontInfo: Iconfont.solidFont)
                $0.setTitle("\u{f07c}", for: .normal)
                $0.setTitleColor(UIColor.black, for: .normal)
                $0.rx.tap.subscribe(onNext: { [weak self] () in
                    guard let strongSelf = self else {
                        return
                    }
                    // save
                    //                    strongSelf.present(UIAlertController(title: "确认全部删除", message: nil, preferredStyle: .actionSheet).then {
                    //                        $0.addAction(UIAlertAction(title: "确定", style: .default, handler: { [weak self] (action) in
                    //                            guard let strongSelf = self else {
                    //                                return
                    //                            }
                    //                            HistoryDataCache.sharedInstance.deleteCacheValueAll()
                    //                            strongSelf.tableView.reloadData()
                    //                        }))
                    //                        $0.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                    //                    }, animated: true, completion: nil)
                }).disposed(by: rx.disposeBag)
            })]

        if let image = self.image {
            let imageView = UIImageView(image: image)
            self.view.addSubview(imageView)
            imageView.snp.makeConstraints { (maker) in
                maker.center.width.equalToSuperview()
                maker.height.equalTo(imageView.snp.width)
            }
        }
    }
}
