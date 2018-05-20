//
//  ScanViewController.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2016/11/8.
//  Copyright © 2016年 wenyou. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import SnapKit
import Toast_Swift
import RxCocoa
import RxSwift
import NSObject_Rx

class ScanViewController: ViewController, UINavigationControllerDelegate {
    private var device: AVCaptureDevice!
    private var session: AVCaptureSession!
    private var bgView: UIView!
    private var lightButton: UIButton!
    private var supportCamera: Bool = false
    private var hasAlert: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.setNeedsStatusBarAppearanceUpdate()

        NotificationCenter.default.rx.notification(Notification.Name.UIApplicationWillEnterForeground).subscribe(onNext: { (notification) in
            if self.supportCamera {
                self.session.startRunning()
            }
        }).disposed(by: rx.disposeBag)

        bgView = UIView().then {
            $0.backgroundColor = .black
            $0.isHidden = false
        }
        view.addSubview(bgView)
        bgView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        let shadowView = ShadowView(frame: view.bounds)
        view.addSubview(shadowView)
        shadowView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.left.right.equalTo(self.view)
                maker.bottom.equalTo(self.view.safeAreaInsets.bottom)
            } else {
                maker.edges.equalTo(self.view)
            }
        }

        let imageButton = UIButton(type: .custom).then {
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.titleLabel?.font = Iconfont.fontOfSize(20, fontInfo: Iconfont.solidFont)
            $0.backgroundColor = UIColor.colorWithHexValue(0x000000, alpha: 32)
            $0.setTitle("\u{f03e}", for: .normal)
            $0.rx.tap.subscribe(onNext: { () in
                if UsageUtility.checkPhoto(controller: self) {
                    self.present(UIImagePickerController().then {
                        $0.delegate = self
                        $0.sourceType = .photoLibrary // photoLibrary 相册; camera 相机; photosAlbum 照片库
                        $0.allowsEditing = true
                        $0.modalTransitionStyle = .crossDissolve
                    }, animated: true, completion: nil)
                }
            }).disposed(by: rx.disposeBag)
        }
        shadowView.addSubview(imageButton)
        imageButton.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview().offset(-20)
            make.height.width.equalTo(40)
        }

        lightButton = UIButton(type: .custom).then {
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.titleLabel?.font = Iconfont.fontOfSize(20, fontInfo: Iconfont.solidFont)
            $0.backgroundColor = UIColor.colorWithHexValue(0x000000, alpha: 32)
            $0.setTitle("\u{f0e7}", for: .normal)
            $0.rx.tap.subscribe(onNext: { () in
                try! self.device.lockForConfiguration()
                switch self.device.torchMode {
                case .on:
                    self.device.torchMode = .off
                    break
                case .off:
                    self.device.torchMode = .on
                    break
                case .auto:
                    self.device.torchMode = .on
                }
                self.device.unlockForConfiguration()
                self.setLightButtonStyle()
            }).disposed(by: rx.disposeBag)
        }
        shadowView.addSubview(lightButton)
        lightButton.snp.makeConstraints { (make) in
            make.right.equalTo(imageButton.snp.left).offset(-20)
            make.bottom.height.width.equalTo(imageButton)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 隐藏 navigationBar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if hasAlert {
            supportCamera = UsageUtility.isCameraAvailable() && UsageUtility.isAVAuthorization()
        } else {
            supportCamera = UsageUtility.checkCamera(controller: self)
        }
        bgView.isHidden = supportCamera
        lightButton.isHidden = !supportCamera

        if supportCamera {
            initDevice()
            setLightButtonStyle()
            session.startRunning()
        } else {
            hasAlert = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.isTranslucent = false

        if let session = session {
            session.stopRunning()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    static func handleValue(_ value: String, viewController: UIViewController, endBlock: (() -> Void)?) {
        if UserDefaultsHelp.shared.shock {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        viewController.present(UIAlertController(title: value, message: nil, preferredStyle: .actionSheet).then {
            if let url = URL(string: value), UIApplication.shared.canOpenURL(url) {
                $0.addAction(UIAlertAction(title: "用浏览器打开", style: .default, handler: { (action) in
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }))
            }
            $0.addAction(UIAlertAction(title: "拷贝到剪贴板", style: .default, handler: { (action) in
                UIPasteboard.general.string = value
                if let block = endBlock {
                    block()
                }
            }))
            $0.addAction(UIAlertAction(title: "继续", style: .cancel, handler: { (action) in
                if let block = endBlock {
                    block()
                }
            }))
        }, animated: true, completion: nil)
    }
}

private extension ScanViewController {
    private func initDevice() {
        if device == nil {
            device = AVCaptureDevice.default(for: AVMediaType.video)
            let input = try! AVCaptureDeviceInput(device: device)
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            session = AVCaptureSession()
            session.sessionPreset = UIScreen.main.bounds.size.height < 500 ? AVCaptureSession.Preset.vga640x480 : AVCaptureSession.Preset.high
            session.addInput(input)
            session.addOutput(output)

            let windowSize = UIScreen.main.bounds.size
            let scanSize = CGSize(width: windowSize.width - 100, height: windowSize.width - 100)
            var scanRect = CGRect(x: (windowSize.width - scanSize.width) / 2, y: (windowSize.height - scanSize.height) / 2, width: scanSize.width, height: scanSize.height)
            scanRect = CGRect(x: scanRect.origin.y / windowSize.height, y: scanRect.origin.x / windowSize.width, width: scanRect.size.height / windowSize.height, height: scanRect.size.width / windowSize.width) // 计算rectOfInterest 注意x, y交换位置
            output.rectOfInterest = scanRect
            output.metadataObjectTypes = [.qr, .ean13]

            let layer = AVCaptureVideoPreviewLayer(session: session)
            layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            layer.frame = UIScreen.main.bounds
            view.layer.insertSublayer(layer, at: 0)
        }
    }

    private func setLightButtonStyle() {
        switch device.torchMode {
        case .on:
            lightButton.setTitleColor(UIColor.red, for: .normal)
        case .off:
            lightButton.setTitleColor(UIColor.white, for: .normal)
        case .auto:
            lightButton.setTitleColor(UIColor.yellow, for: .normal)
        }
    }
}

extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count < 1 else {
            session.stopRunning()
            let metadataObject: AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            HistoryDataCache.sharedInstance.addCacheValue(metadataObject.stringValue!)
            ScanViewController.handleValue(metadataObject.stringValue!, viewController: self, endBlock: { [weak self] () -> Void in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.session.startRunning()
            })
            return
        }
    }
}

extension ScanViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) -> Void {
        picker.view.makeToastActivity(.center)
        let pickImage: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let ciImage: CIImage = CIImage(data: UIImagePNGRepresentation(pickImage)!)!
        let detector: CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])!
        let features: [CIFeature] = detector.features(in: ciImage)
        picker.view.hideToastActivity()

        picker.dismiss(animated: true, completion: {
            if features.count > 0 {
                let feature: CIQRCodeFeature = features.first as! CIQRCodeFeature
                HistoryDataCache.sharedInstance.addCacheValue(feature.messageString!)
                ScanViewController.handleValue(feature.messageString!, viewController: self, endBlock: nil)
            } else {
                self.present({
                    let controller = UIAlertController(title: "该图片识别不出二维码", message: nil, preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                    return controller
                }(), animated: true, completion: nil)
            }
        })
    }
}
