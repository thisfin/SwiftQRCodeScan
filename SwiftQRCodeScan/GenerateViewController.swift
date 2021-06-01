//
//  GenerateViewController.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2018/5/6.
//  Copyright © 2018年 wenyou. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import ToastSwiftFramework
import UIKit

class GenerateViewController: ViewController {
    var tableView: UITableView!
    var textView: UITextView!
//    let types: [(String, QRType)]
//    let typeRelay: BehaviorRelay<(String, QRType)>
    private let typeRelay: BehaviorRelay<QRType>
    let frontColorRelay: BehaviorRelay<UIColor>
    let backgroundColorRelay: BehaviorRelay<UIColor>
    private var colorSelectedType: ColorSelectedType = .front

    init() {
//        types = [("文本", QRType.text), ("网址", QRType.url)]
        typeRelay = BehaviorRelay(value: .text)
        frontColorRelay = BehaviorRelay(value: UIColor(hex: 0x000000))
        backgroundColorRelay = BehaviorRelay(value: UIColor(hex: 0xFFFFFF))

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
//        navigationController?.navigationBar.isTranslucent = false // navigation 遮挡

        textView = UITextView().then {
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
        view.addSubview(textView)
        textView.snp.makeConstraints { maker in
            maker.top.left.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.height.equalToSuperview().multipliedBy(0.4)
        }

        let items = Observable.just([SectionModel(model: "", items: ["类型", "前景色", "背景色", "生成"])])
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (_, tableView, indexPath, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(GenerateViewController.self)") ?? UITableViewCell(style: .value1, reuseIdentifier: "\(GenerateViewController.self)")
            cell.selectionStyle = .none // 取消选中色
            cell.textLabel?.text = element
            switch indexPath.row {
            case 0:
                if let label = cell.detailTextLabel {
                    self.typeRelay.asObservable().map { type -> String in
                        type.rawValue
                    }.bind(to: label.rx.text).disposed(by: self.rx.disposeBag)
                }
            case 1:
                let view = UIView().then {
                    $0.frame.size = CGSize(width: 35, height: 25)
                    $0.layer.borderColor = UIColor.gray.cgColor
                    $0.layer.borderWidth = 0.5
                    self.frontColorRelay.asObservable().bind(to: $0.rx.backgroundColor).disposed(by: self.rx.disposeBag)
                }
                cell.accessoryView = view
            case 2:
                let view = UIView().then {
                    $0.frame.size = CGSize(width: 35, height: 25)
                    $0.layer.borderColor = UIColor.gray.cgColor
                    $0.layer.borderWidth = 0.5
                    self.backgroundColorRelay.asObservable().bind(to: $0.rx.backgroundColor).disposed(by: self.rx.disposeBag)
                }
                cell.accessoryView = view
            case 3:
                cell.accessoryType = .disclosureIndicator
            default:
                ()
            }
            return cell
        })
        tableView = UITableView(frame: UIScreen.main.bounds, style: .plain).then {
            $0.tableFooterView = UIView(frame: .zero) // 去除尾部空白行
            $0.bounces = false // 禁止超限滑动
            $0.sectionHeaderHeight = self.view.frame.width
            self.view.addSubview($0)
            $0.snp.makeConstraints({ maker in
                maker.top.equalTo(textView.snp.bottom).offset(10)
                maker.left.right.equalToSuperview()
                maker.bottom.equalTo(self.view.safeAreaInsets.bottom)
            })
        }
        _ = items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)

        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let `self` = self else {
                return
            }

            if indexPath.row == 0 {
                self.present(UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet).then { controller in
                    QRType.allCases.forEach { type in
                        controller.addAction(UIAlertAction(title: "\(type.rawValue)", style: .default, handler: { _ in
                            self.typeRelay.accept(type)
                        }))
                    }
                }, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                self.colorSelectedType = .front
                self.present(UIColorPickerViewController().then {
                    $0.selectedColor = self.frontColorRelay.value
                    $0.delegate = self
                }, animated: true, completion: nil)
            } else if indexPath.row == 2 {
                self.colorSelectedType = .background
                self.present(UIColorPickerViewController().then {
                    $0.selectedColor = self.backgroundColorRelay.value
                    $0.delegate = self
                }, animated: true, completion: nil)
            } else if indexPath.row == 3 {
                if let text = self.textView.text,
                   let content = (self.typeRelay.value == .text) ? text : text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   content.count > 0,
                   let image = self.createColorImage(content, frontColor: self.frontColorRelay.value, backgroundColor: self.backgroundColorRelay.value) {
                    if let navigationController = self.navigationController {
                        navigationController.pushViewController(PreviewViewController().then {
                            $0.image = image
                        }, animated: true)
                    }
                } else {
                    self.view.makeToast("二维码生成失败", duration: 2, position: .center)
                }
            }
        }).disposed(by: rx.disposeBag)

//        DispatchQueue.main.async { // 只有这样才生效
//            self.tableView.contentOffset = CGPoint(x: 0, y: -self.view.frame.width)
//        }
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

private extension GenerateViewController {
    func createQRImage(content: String) -> CIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator"), let infoData = content.data(using: .utf8) else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(infoData, forKey: "inputMessage")
        filter.setValue("H", forKeyPath: "inputCorrectionLevel")
        return filter.outputImage
    }

    func createSizeImage(content: String, imageWidth: Int) -> UIImage? {
        guard let ciImage = createQRImage(content: content) else {
            return nil
        }
        let scale = CGFloat(imageWidth) / ciImage.extent.integral.width
        let colorSpace = CGColorSpaceCreateDeviceGray()
        guard let bitmapRef = CGContext(data: nil, width: imageWidth, height: imageWidth, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0), let bitmapImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent.integral) else {
            return nil
        }
        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: ciImage.extent.integral)
        guard let scaledImage = bitmapRef.makeImage() else {
            return nil
        }
        return UIImage(cgImage: scaledImage)
    }

    func createColorImage(_ content: String, imageWidth: Int = 1024, frontColor: UIColor = .black, backgroundColor: UIColor = .white) -> UIImage? {
        guard let sizeImage = createSizeImage(content: content, imageWidth: imageWidth), let ciImage = CIImage(image: sizeImage), let filter = CIFilter(name: "CIFalseColor") else {
            return nil
        } // 图片需在拉伸后设置
        filter.setDefaults()
        filter.setValue(ciImage, forKeyPath: "inputImage")
        filter.setValue(CIColor(color: frontColor), forKeyPath: "inputColor0")
        filter.setValue(CIColor(color: backgroundColor), forKeyPath: "inputColor1")
        if let outputImage = filter.outputImage, let cgImage = CIContext(options: nil).createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage) // 必须使用 cg 转换一下, ci 直接初始化会有格式问题
        }
        return nil
    }
}

extension GenerateViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        switch colorSelectedType {
        case .front:
            frontColorRelay.accept(viewController.selectedColor)
        case .background:
            backgroundColorRelay.accept(viewController.selectedColor)
        }
    }

    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        switch colorSelectedType {
        case .front:
            frontColorRelay.accept(viewController.selectedColor)
        case .background:
            backgroundColorRelay.accept(viewController.selectedColor)
        }
    }
}

private class TextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 15, dy: 15)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 15, dy: 15)
    }
}

fileprivate enum QRType: String, CaseIterable {
    case text = "文本"
    case url = "网址"
}

fileprivate enum ColorSelectedType {
    case front
    case background
}
