//
//  CTColorView.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2018/5/14.
//  Copyright © 2018年 wenyou. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import NSObject_Rx
import SwiftyJSON

class CTColorView: UIView {
    var colorSelected: ((UIColor) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)

        guard let colorPropertyPath = Bundle.main.path(forResource: "colors", ofType: "json"), let colorData = try? Data(contentsOf: URL(fileURLWithPath: colorPropertyPath)), case let colors?? = try? JSON(data: colorData).array else {
            return
        }

        let items = Observable.just([SectionModel(model: "", items: colors)])
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, JSON>>(configureCell: { (dataSource, tableView, indexPath, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self)) ?? UITableViewCell(style: .subtitle, reuseIdentifier: String(describing: UITableViewCell.self))
            cell.selectionStyle = .none // 取消选中色
            cell.textLabel?.text = element["name"].string
            cell.detailTextLabel?.text = element["desc"].string
            if let name = element["name"].string, let color = self.colorWith(name: name) {
                cell.backgroundColor = color
            }
            return cell
        })
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain).then {
            $0.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
            $0.separatorStyle = .none
            self.addSubview($0)
            $0.snp.makeConstraints({ (maker) in
                maker.edges.equalToSuperview()
            })
        }
        _ = items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)

        tableView.rx.modelSelected(JSON.self).subscribe(onNext: { (element) in
            if let name = element["name"].string, let color = self.colorWith(name: name), let block = self.colorSelected {
                block(color)
            }
        }).disposed(by: rx.disposeBag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CTColorView {
    func colorWith(name: String) -> UIColor? { // 根据名称方法取图片
        if let unmanaged = UIColor.perform(Selector(name)), let color = unmanaged.takeUnretainedValue() as? UIColor {
            return color
        }
        return nil
    }
}
