//
//  ColorSelectViewController.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2018/5/14.
//  Copyright © 2018年 wenyou. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx
import Then
import SnapKit
import ChromaColorPicker

class ColorSelectViewController: ViewController {
    var defaultColor: UIColor?
    var colorChange: ((UIColor) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        let segment = UISegmentedControl(items: ["simple", "detail"]).then {
            $0.selectedSegmentIndex = 0
        }
        self.navigationItem.titleView = segment

        let ctColorView = CTColorView().then {
            $0.colorSelected = { [weak self] (color) in
                if let strongSelf = self, let block = strongSelf.colorChange {
                    block(color)
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }
        }
        self.view.addSubview(ctColorView)
        ctColorView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        segment.rx.selectedSegmentIndex.map { (i) -> Bool in
            i != 0
        }.bind(to: ctColorView.rx.isHidden).disposed(by: rx.disposeBag)

        let picker = ChromaColorPicker(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))).then {
            $0.delegate = self
            if let color = defaultColor {
                $0.adjustToColor(color)
            }
        }
        self.view.addSubview(picker)
        segment.rx.selectedSegmentIndex.map { (i) -> Bool in
            i != 1
        }.bind(to: picker.rx.isHidden).disposed(by: rx.disposeBag)
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        if let _ = parent {
        } else {
            // 数据回写 暂时无用
        }
    }
}

extension ColorSelectViewController: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        if let colorChange = self.colorChange {
            colorChange(color)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
