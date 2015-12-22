//
//  Photograph.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class PhotographViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /// 切换照片控制器
    var switchPhotoVC: SwitchPhotoViewController = SwitchPhotoViewController()
    
    /// 所在的控制器
    weak var superViewController: UIViewController?
    
    /// 需要设置的图片
    weak var setPhotoImageView: UIImageView?
    
    /// 选择照片方法
    var imagePicker: UIImagePickerController!
    func switchPhotoAction(viewController: UIViewController, sourceview: UIView, setPhoto: UIImageView) {
        superViewController = viewController
        setPhotoImageView  = setPhoto
        let alerController = UIAlertController(title: "", message: "请选择图片来源", preferredStyle: .ActionSheet)
        let actionCancle   = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let phootPicture   = UIAlertAction(title: "拍照", style: .Default) { [weak self] (_) -> Void in
            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                ProgressHUD.showErrorHUD(nil, text: "当前设备不支持拍照功能")
                return
            }
            self?.imagePicker = UIImagePickerController()
            self?.imagePicker.delegate = self
            self?.imagePicker.sourceType = .Camera
            viewController.presentViewController(self?.imagePicker ?? UIImagePickerController(), animated: true, completion: nil)
        }
        let existingPicture = UIAlertAction(title: "从手机相册选择", style: .Default) { [weak self] (_) -> Void in
            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                ProgressHUD.showErrorHUD(self?.view, text: "当前相册不可用")
                return
            }
            self?.imagePicker = UIImagePickerController()
            self?.imagePicker.delegate = self
            viewController.presentViewController(self?.imagePicker ?? UIImagePickerController(), animated: true, completion: nil)
        }
        alerController.addAction(actionCancle)
        alerController.addAction(phootPicture)
        alerController.addAction(existingPicture)
        alerController.modalPresentationStyle = .Popover
        alerController.popoverPresentationController?.sourceView = sourceview
        alerController.popoverPresentationController?.sourceRect = sourceview.frame ?? CGRectZero
        viewController.presentViewController(alerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        superViewController?.navigationController?.pushViewController(switchPhotoVC, animated: true)
        switchPhotoVC.photoView.img = image
        setPhotoImageView?.image = image
        superViewController?.dismissViewControllerAnimated(true) { [weak self] () -> Void in
            self?.imagePicker = nil
        }
        // 重新设回导航栏样式
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    deinit {
        print("会消失吗")
    }
    
}
