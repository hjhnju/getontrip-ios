
//
//  NewUserRegisterViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/20.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

class NewUserRegisterViewController: UIViewController {

    /// 邮箱
    lazy var emailTextField     = UITextField(alignment: NSTextAlignment.Left, sizeFout: 18, color: UIColor.blackColor())
    
    /// 密码
    lazy var passwordTextField  = UITextField(alignment: NSTextAlignment.Left, sizeFout: 18, color: UIColor.blackColor())
    
    /// 下一步按钮
    lazy var nextButton         = UIButton(title: "下一步", fontSize: 20, radius: 2, titleColor: UIColor.whiteColor())
    
    /// 邮箱字
    let emailLabel: UILabel     = UILabel(color: SceneColor.lightGrayEM, title: "  邮箱 ", fontSize: 18, mutiLines: true)
    
    /// 密码字
    let passwLabel: UILabel     = UILabel(color: SceneColor.lightGrayEM, title: "  密码 ", fontSize: 18, mutiLines: true)
    
    /// 用户协议
    lazy var userProtocolButton = UIButton(title: "我已阅读并同意《用户注册协议》", fontSize: 11, radius: 0, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.7))
    
    /// 用户
    lazy var userAgreeButton    = UIButton(image: "userProtocol_false", title: "", fontSize: 11)
    
    lazy var backButton         = UIButton(image: "back_white", title: "", fontSize: 0)
    
    lazy var navTitleLabel      = UILabel(color: UIColor.whiteColor(), title: "注册", fontSize: 24, mutiLines: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperty()
        initView()
        initTextField()
        initAutoLayout()
    }
    
    private func initView() {
        
        view.addSubview(backButton)
        view.addSubview(navTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        view.addSubview(userProtocolButton)
        view.addSubview(userAgreeButton)
    }
    
    private func initProperty() {
        view.backgroundColor = UIColor.whiteColor()
        let backgroundImageView = UIImageView(image: UIImage(named: "login_background"))
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = UIScreen.mainScreen().bounds
        userAgreeButton.setImage(UIImage(named: "userProtocol_true"), forState: .Selected)
        userAgreeButton.addTarget(self, action: "userAgreeAction:", forControlEvents: .TouchUpInside)
        userProtocolButton.addTarget(self, action: "userProtocolAction:", forControlEvents: .TouchUpInside)
        nextButton.backgroundColor = SceneColor.lightblue
        backButton.addTarget(self, action: "backAction", forControlEvents: .TouchUpInside)
        nextButton.addTarget(self, action: "nexButtonAction", forControlEvents: .TouchUpInside)
    }

    private func initTextField() {
        let size = emailLabel.text?.sizeofStringWithFount1(UIFont.systemFontOfSize(18), maxSize: CGSizeMake(CGFloat.max, CGFloat.max))
        emailTextField.borderStyle         = UITextBorderStyle.RoundedRect
        emailTextField.autocorrectionType  = UITextAutocorrectionType.Default
        emailTextField.returnKeyType       = UIReturnKeyType.Done
        emailTextField.clearButtonMode     = UITextFieldViewMode.WhileEditing
        emailTextField.leftView            = emailLabel
        emailTextField.leftViewMode        = UITextFieldViewMode.Always
        emailLabel.bounds           = CGRectMake(0, 0, size!.width, size!.height)
        
        passwordTextField.borderStyle      = UITextBorderStyle.RoundedRect
        passwordTextField.leftView         = passwLabel
        passwordTextField.leftViewMode     = UITextFieldViewMode.Always
        passwordTextField.autocorrectionType = UITextAutocorrectionType.Default
        passwordTextField.returnKeyType    = UIReturnKeyType.Done
        passwordTextField.clearButtonMode  = UITextFieldViewMode.WhileEditing
        passwordTextField.secureTextEntry  = true
        passwLabel.bounds           = CGRectMake(0, 0, size!.width, size!.height)
    }
    
    private func initAutoLayout() {
        let screen = UIScreen.mainScreen().bounds
        let size = CGSizeMake(screen.width - 110, 42)
        backButton.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(13, 26), offset: CGPointMake(12, 23))
        navTitleLabel.ff_AlignInner(.TopCenter, referView: view, size: nil, offset: CGPointMake(0, 23))
        nextButton.ff_AlignInner(.CenterCenter, referView: view, size: size, offset: CGPointMake(0, 0))
        passwordTextField.ff_AlignVertical(.TopCenter, referView: nextButton, size: size, offset: CGPointMake(0, -87))
        emailTextField.ff_AlignVertical(.TopCenter, referView: passwordTextField, size: size, offset: CGPointMake(0, -6))
        userAgreeButton.ff_AlignVertical(.BottomLeft, referView: passwordTextField, size: CGSizeMake(15, 15), offset: CGPointMake(0, 5))
        userProtocolButton.ff_AlignHorizontal(.CenterRight, referView: userAgreeButton, size: nil, offset: CGPointMake(5, 0))
    }
    
    // MARK: - 自定义方法
    func userAgreeAction(btn: UIButton) {
        btn.selected = !btn.selected
    }
    
    func userProtocolAction(btn: UIButton) {
        let vc = DetailWebViewController()
        vc.url = "http://www.getontrip.cn/privacy"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func backAction() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func nexButtonAction() {
        
        if userAgreeButton.selected == false {
            SVProgressHUD.showInfoWithStatus("请阅读《用户注册协议》")
            return
        }
        
        let emailStr = emailTextField.text ?? ""
        let passwStr = passwordTextField.text ?? ""
        if emailStr.validateEmail(emailStr) {
            if passwStr.validatePassword(passwStr) {
                UserRegisterRequest.userRegister(emailStr, passwd: passwStr, handler: { (result, status) -> Void in
                    if status == RetCode.SUCCESS {
                        UserLogin.sharedInstance.loadAccount({ (result, status) -> Void in
                            if status == RetCode.SUCCESS {
                                UserLogin.sharedInstance.loadAccount({ (result, status) -> Void in
                                    if status == RetCode.SUCCESS {
                                        let vc = self.parentViewController?.presentingViewController as? SlideMenuViewController
                                        vc?.dismissViewControllerAnimated(true, completion: { () -> Void in
                                            vc?.curVCType = SettingViewController.self
                                            
                                        })
                                    } else {
                                        SVProgressHUD.showInfoWithStatus("登陆失败，请重新登陆")
                                    }
                                })
                            } else {
                                SVProgressHUD.showInfoWithStatus("登陆失败，请重新登陆")
                            }
                        })
                    } else {
                        SVProgressHUD.showInfoWithStatus("网络连接失败，请稍候注册")
                    }
                })
            } else {
                SVProgressHUD.showInfoWithStatus("请输入6～32位字母、数字及常用符号组成")
            }
        } else {
            SVProgressHUD.showInfoWithStatus("邮箱格式错误")
        }
    }
}
