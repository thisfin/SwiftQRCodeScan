//
//  GenerateViewController.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2018/5/6.
//  Copyright © 2018年 wenyou. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import IQKeyboardManagerSwift

class GenerateViewController: ViewController {
    var tableView: UITableView!
    var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = false  // navigation 遮挡
        self.title = "二维码生成"

        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "完成";



        self.textView = UITextView().then {
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.cornerRadius = 4
            $0.font = UIFont.systemFont(ofSize: 20)
            $0.delegate = self
            // 回车在中间时候不好用
//            $0.rx.text.asObservable().subscribe(onNext: { [weak self] (str) in
//                if let strongSelf = self, let str = str, str.contains("\n") {
//                    strongSelf.textView.resignFirstResponder()
//                }
//            }).disposed(by: rx.disposeBag)
        }
        self.view.addSubview(textView)
        textView.snp.makeConstraints { (maker) in
            maker.top.left.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.height.equalToSuperview().multipliedBy(0.4)
        }

        let items = Observable.just([SectionModel(model: "", items: ["类型", "前景色", "背景色"])])
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, tableView, indexPath, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(IndexViewController.self)") ?? UITableViewCell(style: .value1, reuseIdentifier: "\(IndexViewController.self)")
            cell.selectionStyle = .none // 取消选中色
            cell.textLabel?.text = element
            cell.accessoryType = .disclosureIndicator
            return cell
        })
         tableView = UITableView(frame: UIScreen.main.bounds, style: .plain).then {
//            if #available(iOS 11.0, *) {
//                $0.contentInsetAdjustmentBehavior = .never
//            }
            $0.tableFooterView = UIView(frame: .zero) // 去除尾部空白行
            $0.bounces = false // 禁止超限滑动
            $0.sectionHeaderHeight = self.view.frame.width
            self.view.addSubview($0)
            $0.snp.makeConstraints({ (maker) in
                maker.top.equalTo(textView.snp.bottom).offset(10)
                maker.left.right.equalToSuperview()
                if #available(iOS 11.0, *) {
                    maker.bottom.equalTo(self.view.safeAreaInsets.bottom)
                } else {
                    maker.bottom.equalToSuperview()
                }
            })
        }
        _ = items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)

//        tableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
//            if let strongSelf = self {
//                if indexPath.section == 0 && indexPath.row == 0 {
//                    if let url = URL(string: strongSelf.github), UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
//                } else if indexPath.section == 0 && indexPath.row == 1 {
//                    if let url = URL(string: strongSelf.store), UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
//                } else if indexPath.section == 1 && indexPath.row == 0 {
//                    if let url = URL(string: strongSelf.store) {
//                        strongSelf.present(UIActivityViewController(activityItems: [url], applicationActivities: nil), animated: true, completion: nil)
//                    }
//                }
//            }
//        }).disposed(by: rx.disposeBag)

//        DispatchQueue.main.async { // 只有这样才生效
//            self.tableView.contentOffset = CGPoint(x: 0, y: -self.view.frame.width)
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        IQKeyboardManager.sharedManager().enable = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.textView.resignFirstResponder()
        IQKeyboardManager.sharedManager().enable = false
    }
}

extension GenerateViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.textView.resignFirstResponder()
        }
        return true
    }
}

class TextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
}
