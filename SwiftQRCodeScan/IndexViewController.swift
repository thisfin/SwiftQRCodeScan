//
//  IndexViewController.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2018/5/4.
//  Copyright © 2018年 wenyou. All rights reserved.
//

import NSObject_Rx
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit

class IndexViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        title = Bundle.main.tool.displayName

        let items = Observable.just([SectionModel(model: "", items: [
            ControllerInfo(name: "扫描", type: ScanViewController.self, icon: "\u{f065}"),
            ControllerInfo(name: "扫描记录", type: HistoryViewController.self, icon: "\u{f1da}"),
            ControllerInfo(name: "二维码生成", type: GenerateViewController.self, icon: "\u{f029}"),
            ControllerInfo(name: "设置", type: SettingViewController.self, icon: "\u{f013}")])])

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ControllerInfo>>(configureCell: { (_, tableView, _, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self)) ?? UITableViewCell(style: .value1, reuseIdentifier: String(describing: UITableViewCell.self))
            cell.selectionStyle = .none // 取消选中色
            cell.textLabel?.attributedText = NSMutableAttributedString(string: "\(element.icon)  \(element.name)").then {
                $0.addAttribute(kCTFontAttributeName as NSAttributedString.Key, value: Iconfont.fontOfSize(20, fontInfo: Iconfont.solidFont), range: NSRange(location: 0, length: 1))
            }
            cell.accessoryType = .disclosureIndicator
            return cell
        })

        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain).then {
            $0.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
            $0.tableFooterView = UIView(frame: .zero) // 去除尾部空白行
//            $0.bounces = false // 禁止超限滑动
            self.view.addSubview($0)
            $0.snp.makeConstraints({ maker in
                maker.edges.equalToSuperview()
            })
        }

        _ = items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)

        tableView.rx.modelSelected(ControllerInfo.self).subscribe(onNext: { [weak self] element in
            if let `self` = self, let navigationController = self.navigationController {
                let controller: UIViewController = element.type.init()
                controller.title = element.name
                navigationController.pushViewController(controller, animated: true)
            }
        }).disposed(by: rx.disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

fileprivate struct ControllerInfo {
    var name: String
    var type: UIViewController.Type
    var icon: String
}
