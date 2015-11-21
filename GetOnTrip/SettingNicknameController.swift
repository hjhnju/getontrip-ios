//
//  SettingNicknameController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/21.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SettingNicknameController: MenuViewController {

    lazy var newNickNameLabel = UILabel(color: UIColor(hex: 0x1C1C1C, alpha: 0.7), title: "新昵称", fontSize: 14, mutiLines: true)
    
    lazy var baseLineView     = UIView(color: SceneColor.shallowGrey, alphaF: 0.3)
    
    lazy var userNameTextField = UITextField(alignment: NSTextAlignment.Left, sizeFout: 16, color: UIColor.blackColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initTextField()
        setupBarButtonItem()
        navBar.setTitle(SettingViewController.name)
    }
    
    private func initView() {
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(newNickNameLabel)
        view.addSubview(baseLineView)
        view.addSubview(userNameTextField)
        newNickNameLabel.ff_AlignInner(.TopLeft, referView: view, size: nil, offset: CGPointMake(9, 88))
        baseLineView.ff_AlignVertical(.BottomLeft, referView: newNickNameLabel, size: CGSizeMake(view.bounds.width - 18, 0.5), offset: CGPointMake(0, 2))
        userNameTextField.ff_AlignVertical(.BottomLeft, referView: newNickNameLabel, size: CGSizeMake(view.bounds.width - 18, 42), offset: CGPointMake(0, 0))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "nickNameTextFieldTextDidChangeNotification:", name: UITextFieldTextDidChangeNotification, object: userNameTextField)
    }
    
    private func initTextField() {
        userNameTextField.borderStyle         = UITextBorderStyle.None
        userNameTextField.autocorrectionType  = UITextAutocorrectionType.No
        userNameTextField.autocapitalizationType = UITextAutocapitalizationType.None
        userNameTextField.returnKeyType       = UIReturnKeyType.Done
        userNameTextField.clearButtonMode     = UITextFieldViewMode.Always
    }
    
    ///  初始化导航
    private func setupBarButtonItem() {
        
        navBar.rightButton.removeTarget(self, action: "searchAction:", forControlEvents: .TouchUpInside)
        navBar.setRightBarButton(nil, title: "保存", target: self, action: "saveUserName")
        navBar.rightButton.selected = false
        navBar.rightButton.setTitleColor(SceneColor.thinGray, forState: .Normal)
        navBar.rightButton.setTitleColor(UIColor.yellowColor(), forState: .Selected)
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")

    }
    
    ///  昵称的文本改变时调用的通知
    ///
    ///  - parameter notification: 通知
    func nickNameTextFieldTextDidChangeNotification(notification: NSNotification) {
        
        let textField = notification.object as! UITextField
        userNameTextField.text = textField.text
        
        let vc = parentViewController as? UINavigationController ?? UINavigationController()
        for vc in vc.viewControllers {
            if vc.isKindOfClass(NSClassFromString("GetOnTrip.SettingViewController")!) {
                if let vc = vc as? SettingViewController {
                    if globalUser?.nickname != textField.text && textField.text != "" {
                        vc.saveButton = true
                        navBar.rightButton.selected = true
                    } else {
                        vc.saveButton = false
                        navBar.rightButton.selected = false
                    }
                }
            }
        }
        
    }
    
    ///  移除通知
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: userNameTextField)
    }

    
    /// 保存用户名
    func saveUserName() {
        if navBar.rightButton.selected == false { return }
        let vc = parentViewController as? UINavigationController ?? UINavigationController()
        for vc in vc.viewControllers {
            if vc.isKindOfClass(NSClassFromString("GetOnTrip.SettingViewController")!) {
                if let vc = vc as? SettingViewController {
                    vc.nickName.text = userNameTextField.text
                }
            }
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
}
