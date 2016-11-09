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

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    private var device: AVCaptureDevice!
    private var session: AVCaptureSession!
    private var bgView: UIView!
    private var lightButton: UIButton!
    private var supportCamera: Bool = false
    private var hasAlert: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        bgView = UIView(frame: view.bounds)
        bgView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        bgView.backgroundColor = UIColor.black
        bgView.isHidden = true
        view.addSubview(bgView)

        let shadowView = ShadowView.init(frame: view.bounds)
        shadowView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        view.addSubview(shadowView)

        let imageButton = UIButton(type: .custom)
        imageButton.layer.cornerRadius = 20;
        imageButton.clipsToBounds = true;
        imageButton.titleLabel?.font = WYIconfont.fontOfSize(20)
        imageButton.backgroundColor = UIColor.colorWithHexValue(0x000000, alpha: 32)
        imageButton.setTitle(Constants.iconfontImage, for: .normal)
        imageButton.addTarget(self, action: #selector(imageButtonClicked(_:)), for: .touchUpInside)
        shadowView.addSubview(imageButton)
        imageButton.snp.makeConstraints { (make) in
            make.right.equalTo(shadowView).offset(-20)
            make.bottom.equalTo(shadowView).offset(-20 - 48)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }

        lightButton = UIButton(type: .custom)
        lightButton.layer.cornerRadius = 20
        lightButton.clipsToBounds = true
        lightButton.titleLabel?.font = WYIconfont.fontOfSize(20)
        lightButton.backgroundColor = UIColor.colorWithHexValue(0x000000, alpha: 32)
        lightButton.setTitle(Constants.iconfontlight, for: .normal)
        lightButton.addTarget(self, action: #selector(lightButtonClicked(_:)), for: .touchUpInside)
        shadowView.addSubview(lightButton)
        lightButton.snp.makeConstraints { (make) in
            make.right.equalTo(imageButton.snp.left).offset(-20)
            make.bottom.equalTo(imageButton)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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

        if session != nil {
            session.stopRunning()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        guard metadataObjects == nil || metadataObjects.count < 1 else {
            session.stopRunning()
            let metadataObject: AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            //HistoryDataCache
            ScanViewController.handleValue(metadataObject.stringValue, viewController: self, endBlock: {
                self.session.startRunning()
            })
            return
        }
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) -> Void {
        picker.dismiss(animated: true, completion: {
            let pickImage: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
            let ciImage: CIImage = CIImage(data: UIImagePNGRepresentation(pickImage)!)!
            let detector: CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])!
            let features: [CIFeature] = detector.features(in: ciImage)
            if features.count > 0 {
                let feature: CIQRCodeFeature = features.first as! CIQRCodeFeature
                // TODO:
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

    // MARK: - private
    private func initDevice() {
        if device != nil {
            device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            let input = try! AVCaptureDeviceInput(device: device)
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            session = AVCaptureSession()
            session.sessionPreset = UIScreen.main.bounds.size.height < 500 ? AVCaptureSessionPreset640x480 : AVCaptureSessionPresetHigh
            session.addInput(input)
            session.addOutput(output)

            let windowSize = UIScreen.main.bounds.size
            let scanSize = CGSize(width: windowSize.width - 100, height: windowSize.width - 100)
            var scanRect = CGRect(x: (windowSize.width - scanSize.width) / 2, y: (windowSize.height - scanSize.height) / 2, width: scanSize.width, height: scanSize.height)
            scanRect = CGRect(x: scanRect.origin.y / windowSize.height, y: scanRect.origin.x / windowSize.width, width: scanRect.size.height / windowSize.height, height: scanRect.size.width / windowSize.width) // 计算rectOfInterest 注意x, y交换位置
            output.rectOfInterest = scanRect
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]

            let layer = AVCaptureVideoPreviewLayer(session: session)
            layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            layer?.frame = UIScreen.main.bounds
            view.layer.insertSublayer(layer!, at: 0)
        }
    }

    private func setLightButtonStyle() {
        switch device.torchMode {
        case .on:
            lightButton.setTitleColor(UIColor.red, for: .normal)
            break
        case .off:
            lightButton.setTitleColor(UIColor.white, for: .normal)
            break
        case .auto:
            lightButton.setTitleColor(UIColor.yellow, for: .normal)
            break
        }
    }

    @objc private func lightButtonClicked(_ sender: AnyObject?) {
        try! device.lockForConfiguration()
        switch device.torchMode {
        case .on:
            device.torchMode = .off
            break
        case .off:
            device.torchMode = .on
            break
        case .auto:
            device.torchMode = .on
        }
        device.unlockForConfiguration()
        setLightButtonStyle()
    }

    @objc private func applicationWillEnterForeground(_ notification: NSNotification) {
        if supportCamera {
            session.startRunning()
        }
    }

    @objc private func imageButtonClicked(_ sender: AnyObject?) {
        if UsageUtility.checkPhoto(controller: self) {
            let controller = UIImagePickerController()
            controller.delegate = self
            // photoLibrary 相册; camera 相机; photosAlbum 照片库
            controller.sourceType = .photoLibrary
            controller.allowsEditing = true
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
            //            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    static func handleValue(_ value: String, viewController: UIViewController, endBlock: SimpleBlockNoneParameter!) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        viewController.present({
            let controller = UIAlertController(title: value, message: nil, preferredStyle: .actionSheet)
            if UIApplication.shared.canOpenURL(URL(string: value)!) {
                controller.addAction(UIAlertAction(title: "用浏览器打开", style: .default, handler: { (action: UIAlertAction) in
                    UIApplication.shared.open(URL(string: value)!, options: [:], completionHandler: nil)
                }))
            }
            controller.addAction(UIAlertAction(title: "拷贝到剪贴板", style: .default, handler: { (action: UIAlertAction) in
                let pasteboard = UIPasteboard.general
                pasteboard.string = value
                if endBlock != nil {
                    endBlock()
                }
            }))
            controller.addAction(UIAlertAction(title: "继续", style: .cancel, handler: { (action: UIAlertAction) in
                if endBlock != nil {
                    endBlock();
                }
            }))
            return controller
        }(), animated: true, completion: nil)
    }
}
