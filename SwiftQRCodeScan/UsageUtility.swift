//
//  UsageUtility.swift
//  SwiftQRCodeScan
//
//  Created by wenyou on 2016/11/9.
//  Copyright © 2016年 wenyou. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class UsageUtility {
    public static func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    public static func isAVAuthorization() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return !(authStatus == .restricted || authStatus == .denied)
    }

    public static func isPHAuthorization() -> Bool {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        return !(authStatus == .restricted || authStatus == .denied)
    }

    public static func checkCamera(controller: UIViewController) -> Bool {
        if !UsageUtility.isCameraAvailable() {
            controller.present(
                UIAlertController(title: "摄像头不可用", message: nil, preferredStyle: .alert).then {
                $0.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            }, animated: true, completion: nil)
            return false
        }
        if !UsageUtility.isAVAuthorization() {
            controller.present(
                UIAlertController(title: "未获得授权使用摄像头", message: "请在\"设置\"-\"隐私\"-\"相机\"中打开", preferredStyle: .alert).then {
                $0.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            }, animated: true, completion: nil)
            return false
        }
        return true
    }

    public static func checkPhoto(controller: UIViewController) -> Bool {
        if !UsageUtility.isPHAuthorization() {
            controller.present(UIAlertController(title: "未获得授权使用相册", message: "请在\"设置\"-\"隐私\"-\"相机\"中打开", preferredStyle: .alert).then {
                $0.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            }, animated: true, completion: nil)
            return false
        }
        return true
    }
}
