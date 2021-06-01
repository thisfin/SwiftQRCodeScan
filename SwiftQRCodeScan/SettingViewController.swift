//
//  SettingViewController.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2018/5/5.
//  Copyright © 2018年 wenyou. All rights reserved.
//

import NSObject_Rx
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit

class SettingViewController: ViewController {
    private let github = "https://github.com/thisfin/SwiftQRCodeScan"
    private let store = "itms-apps://itunes.apple.com/app/id1196789571"

    private let shockSwitch = UISwitch(frame: .zero)
    lazy var shockVariable: BehaviorRelay<Bool> = BehaviorRelay(value: UserDefaultsHelp.shared.shock)

    override func viewDidLoad() {
        super.viewDidLoad()

//        title = "设置"

        let items = Observable.just([
            SectionModel(model: "", items: ["\u{f09b}  源代码", "\u{f1e0}  分享", "\u{f126}  版本"]),
            SectionModel(model: "", items: ["\u{f0e3}  震动提示"])])

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (_, tableView, indexPath, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(IndexViewController.self)") ?? UITableViewCell(style: .value1, reuseIdentifier: "\(IndexViewController.self)")
            cell.selectionStyle = .none // 取消选中色

            cell.textLabel?.attributedText = NSMutableAttributedString(string: element).then {
                if indexPath.section == 0, indexPath.row == 0 {
                    $0.addAttribute(kCTFontAttributeName as NSAttributedString.Key, value: Iconfont.fontOfSize(20, fontInfo: Iconfont.brandsFont), range: NSRange(location: 0, length: 1))
                } else {
                    $0.addAttribute(kCTFontAttributeName as NSAttributedString.Key, value: Iconfont.fontOfSize(20, fontInfo: Iconfont.solidFont), range: NSRange(location: 0, length: 1))
                }
            }
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0, 1:
                    cell.accessoryType = .disclosureIndicator
                case 2:
                    cell.detailTextLabel?.text = "\(Bundle.main.tool.version ?? "") (\(Bundle.main.tool.build ?? ""))"
                default:
                    ()
                }
            case 1:
                switch indexPath.row {
                case 0:
                    cell.accessoryView = self.shockSwitch
                default:
                    ()
                }
            default:
                ()
            }
            return cell
        }, titleForFooterInSection: { (dataSource, i) -> String? in
            i + 1 == dataSource.sectionModels.count ? nil : " " // section 分隔
        })

        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain).then {
            $0.tableFooterView = UIView(frame: .zero) // 去除尾部空白行
            $0.bounces = false // 禁止超限滑动
            $0.sectionFooterHeight = 10
            self.view.addSubview($0)
            $0.snp.makeConstraints({ maker in
                maker.edges.equalToSuperview()
            })
        }

        _ = items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)

        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            if let strongSelf = self {
                if indexPath.section == 0 && indexPath.row == 0 {
                    if let url = URL(string: strongSelf.github), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } else if indexPath.section == 0 && indexPath.row == 1 {
                    if let url = URL(string: strongSelf.store) {
                        strongSelf.present(UIActivityViewController(activityItems: [url], applicationActivities: nil), animated: true, completion: nil)
                    }
                } else if indexPath.section == 0 && indexPath.row == 2 {
                    if let url = URL(string: strongSelf.store), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }).disposed(by: rx.disposeBag)

        _ = shockSwitch.rx.isOn <-> shockVariable // 双向绑定
        shockVariable.asObservable().skip(1).subscribe(onNext: { value in // 第二次赋值
            UserDefaultsHelp.shared.shock = value
        }).disposed(by: rx.disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

//        navigationController?.navigationBar.prefersLargeTitles = false
    }
}
