
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
    var email     = UITextField(alignment: NSTextAlignment.Left, sizeFout: 18, color: UIColor.blackColor())
    
    /// 密码
    var password  = UITextField(alignment: NSTextAlignment.Left, sizeFout: 18, color: UIColor.blackColor())
    
    /// 下一步按钮
    var nextBtn   = UIButton(title: "下一步", fontSize: 20, radius: 2, titleColor: UIColor.whiteColor())
    
    /// 邮箱字
    let emailLab: UILabel = UILabel(color: SceneColor.lightGrayEM, title: "  邮箱 ", fontSize: 18, mutiLines: true)
    
    /// 密码字
    let passwLab: UILabel = UILabel(color: SceneColor.lightGrayEM, title: "  密码 ", fontSize: 18, mutiLines: true)
    
    /// 用户协议
    var userProtocol = UIButton(title: "我已阅读并同意《用户注册协议》", fontSize: 11, radius: 0, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.7))
    
    /// 用户
    var userAgree    = UIButton(image: "userProtocol_false", title: "", fontSize: 11)
    
    var backButton   = UIButton(image: "back_white", title: "", fontSize: 0)
    
    var navTitle     = UILabel(color: UIColor.whiteColor(), title: "注册", fontSize: 24, mutiLines: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperty()
        initView()
        initTextField()
        initAutoLayout()
    }
    
    private func initView() {
        
        view.addSubview(backButton)
        view.addSubview(navTitle)
        view.addSubview(email)
        view.addSubview(password)
        view.addSubview(nextBtn)
        view.addSubview(userProtocol)
        view.addSubview(userAgree)
    }
    
    private func initProperty() {
        view.backgroundColor = UIColor.whiteColor()
        let backgroundImageView = UIImageView(image: UIImage(named: "login_background"))
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = UIScreen.mainScreen().bounds
        userAgree.setImage(UIImage(named: "userProtocol_true"), forState: .Selected)
        userAgree.addTarget(self, action: "userAgreeAction:", forControlEvents: .TouchUpInside)
        userProtocol.addTarget(self, action: "userProtocolAction:", forControlEvents: .TouchUpInside)
        nextBtn.backgroundColor = SceneColor.lightblue
        backButton.addTarget(self, action: "backAction", forControlEvents: .TouchUpInside)
        nextBtn.addTarget(self, action: "nexButtonAction", forControlEvents: .TouchUpInside)
    }

    private func initTextField() {
        let size = emailLab.text?.sizeofStringWithFount1(UIFont.systemFontOfSize(18), maxSize: CGSizeMake(CGFloat.max, CGFloat.max))
        email.borderStyle         = UITextBorderStyle.RoundedRect
        email.autocorrectionType  = UITextAutocorrectionType.Default
        email.returnKeyType       = UIReturnKeyType.Done
        email.clearButtonMode     = UITextFieldViewMode.WhileEditing
        email.leftView            = emailLab
        email.leftViewMode        = UITextFieldViewMode.Always
        emailLab.bounds           = CGRectMake(0, 0, size!.width, size!.height)
        
        password.borderStyle      = UITextBorderStyle.RoundedRect
        password.leftView         = passwLab
        password.leftViewMode     = UITextFieldViewMode.Always
        password.autocorrectionType = UITextAutocorrectionType.Default
        password.returnKeyType    = UIReturnKeyType.Done
        password.clearButtonMode  = UITextFieldViewMode.WhileEditing
        password.secureTextEntry  = true
        passwLab.bounds           = CGRectMake(0, 0, size!.width, size!.height)
    }
    
    private func initAutoLayout() {
        let screen = UIScreen.mainScreen().bounds
        let size = CGSizeMake(screen.width - 110, 42)
        backButton.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(13, 26), offset: CGPointMake(12, 23))
        navTitle.ff_AlignInner(.TopCenter, referView: view, size: nil, offset: CGPointMake(0, 23))
        nextBtn.ff_AlignInner(.CenterCenter, referView: view, size: size, offset: CGPointMake(0, 0))
        password.ff_AlignVertical(.TopCenter, referView: nextBtn, size: size, offset: CGPointMake(0, -87))
        email.ff_AlignVertical(.TopCenter, referView: password, size: size, offset: CGPointMake(0, -6))
        userAgree.ff_AlignVertical(.BottomLeft, referView: password, size: CGSizeMake(15, 15), offset: CGPointMake(0, 5))
        userProtocol.ff_AlignHorizontal(.CenterRight, referView: userAgree, size: nil, offset: CGPointMake(5, 0))
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
        
        if userAgree.selected == false {
            SVProgressHUD.showInfoWithStatus("请阅读《用户注册协议》")
            return
        }
        
        let emailStr = email.text
        if emailStr!.validateEmail(emailStr!) {
            if password.text!.validatePassword(password.text!) {
                UserRegisterRequest.userRegister(email.text!, passwd: password.text!, handler: { (result, status) -> Void in
                    if status == RetCode.SUCCESS {
                        UserLogin.sharedInstance.loadAccount({ (result, status) -> Void in
                            if status == RetCode.SUCCESS {
                                UserLogin.sharedInstance.loadAccount({ (result, status) -> Void in
                                    if status == RetCode.SUCCESS {
                                        let vc = self.parentViewController!.presentingViewController as? SlideMenuViewController
                                        vc?.dismissViewControllerAnimated(true, completion: { () -> Void in
                                            vc!.curVCType = SettingViewController.self
                                            
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
