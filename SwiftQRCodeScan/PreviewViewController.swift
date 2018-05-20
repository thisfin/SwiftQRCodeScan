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
import RxCocoa
import RxSwift
import RxDataSources
import NSObject_Rx
import Photos
import Toast_Swift

class PreviewViewController: ViewController {
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.title = "预览"

        let imageView = UIImageView(image: self.image)
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalToSuperview()
            maker.height.equalTo(imageView.snp.width)
        }

        let items = Observable.just([SectionModel(model: "", items: ["保存", "分享"])])
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, tableView, indexPath, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(IndexViewController.self)") ?? UITableViewCell(style: .value1, reuseIdentifier: "\(IndexViewController.self)")
            cell.selectionStyle = .none // 取消选中色
            cell.textLabel?.text = element
            cell.accessoryType = .disclosureIndicator
            return cell
        })
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain).then {
            $0.tableFooterView = UIView(frame: .zero) // 去除尾部空白行
            $0.bounces = false // 禁止超限滑动
            $0.sectionHeaderHeight = self.view.frame.width
            self.view.addSubview($0)
            $0.snp.makeConstraints({ (maker) in
                maker.top.equalTo(imageView.snp.bottom).offset(10)
                maker.left.right.equalToSuperview()
                if #available(iOS 11.0, *) {
                    maker.bottom.equalTo(self.view.safeAreaInsets.bottom)
                } else {
                    maker.bottom.equalToSuperview()
                }
            })
        }
        _ = items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            if let image = self.image {
                switch indexPath.row {
                case 0:
                    PHPhotoLibrary.shared().performChanges({
                        _ = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }, completionHandler: { [weak self] (success, error) in
                        if success {
                            if let strongSelf = self {
                                DispatchQueue.main.async {
                                    strongSelf.view.makeToast("图片保存成功", duration: 2, position: .center)
                                }
                            }
                        } else if let error = error {
                            print("\(error.localizedDescription)")
                        }
                    })
                case 1:
                    self.present(UIActivityViewController(activityItems: [image], applicationActivities: nil), animated: true, completion: nil)
                default:
                    ()
                }
            }
        }).disposed(by: rx.disposeBag)
    }
}
