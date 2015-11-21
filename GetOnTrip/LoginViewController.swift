//
//  LoginViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/20.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

class LoginViewController: MainViewController {
    
    // MARK: - 属性
    
    /// 欢迎label
    lazy var welcomeLabel     = UILabel(color: UIColor.whiteColor(), title: "Welcome", fontSize: 44, mutiLines: true)
    
    /// 邮箱
    lazy var emailTextField   = UITextField(alignment: NSTextAlignment.Left, sizeFout: 18, color: UIColor.blackColor())
    
    /// 密码
    lazy var passwordTextField = UITextField(alignment: NSTextAlignment.Left, sizeFout: 18, color: UIColor.blackColor())
    
    /// 登录
    lazy var loginButton      = UIButton(title: "登录", fontSize: 20, radius: 2, titleColor: UIColor.whiteColor())
    
    /// 取消
    lazy var cancleButton     = UIButton(title: "取消", fontSize: 20, radius: 2, titleColor: UIColor.whiteColor())
    
    /// 忘忆密码
    lazy var retrievePwButton = UIButton(title: "忘记密码", fontSize: 13, radius: 0, titleColor: UIColor.whiteColor())
    
    /// 注册
    lazy var registerButton   = UIButton(title: "新用户注册", fontSize: 13, radius: 0, titleColor: UIColor.whiteColor())
    
    /// 其他登陆方式
    lazy var elseLoginLabel   = UILabel(color: UIColor.whiteColor(), title: "或使用第三方账号登录", fontSize: 13, mutiLines: true)
    
    /// 基线
    lazy var baseLineView     = UIView(color: UIColor.whiteColor(), alphaF: 0.5)
    
    /// 微信
    lazy var wechatButton     = UIButton(icon: "icon_weixin", masksToBounds: true)
    
    /// qq
    lazy var qqButton         = UIButton(icon: "icon_qq", masksToBounds: true)
    
    /// weibo
    lazy var weiboButton      = UIButton(icon: "icon_weibo", masksToBounds: true)

    let emailLabel            = UILabel(color: SceneColor.lightGrayEM, title: "  邮箱 ", fontSize: 18, mutiLines: true)
    
    let passwLabel            = UILabel(color: SceneColor.lightGrayEM, title: "  密码 ", fontSize: 18, mutiLines: true)
    
    lazy var keyboardTakebackBtn = UIButton()
    
    let passwordEyeButton     = UIButton(image: "topic_eye_gray", title: "", fontSize: 0)
    
    /// 回调用于做完之后不影响之前的操作
    typealias LoginFinishedHandler = (result: Bool, error: NSError?) -> ()

    var loginFinished: LoginFinishedHandler?
    
    // MARK: - 初始化属性、设置
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initAutoLayout()
        initTextField()
    }

    private func initView() {
        let backgroundImageView = UIImageView(image: UIImage(named: "login_background"))
        view.addSubview(backgroundImageView)
        view.addSubview(keyboardTakebackBtn)
        backgroundImageView.frame = UIScreen.mainScreen().bounds
        keyboardTakebackBtn.frame = UIScreen.mainScreen().bounds
        keyboardTakebackBtn.addTarget(self, action: "keyboardTakebackBtnAction:", forControlEvents: .TouchUpInside)
        
        view.addSubview(welcomeLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(cancleButton)
        view.addSubview(retrievePwButton)
        view.addSubview(registerButton)
        view.addSubview(elseLoginLabel)
        view.addSubview(baseLineView)
        view.addSubview(wechatButton)
        view.addSubview(qqButton)
        view.addSubview(weiboButton)
        
        cancleButton.backgroundColor = SceneColor.lightgrey
        loginButton.backgroundColor  = SceneColor.lightblue
        welcomeLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 44)
        passwordEyeButton.addTarget(self, action: "passwordEyeButton:", forControlEvents: .TouchUpInside)
        retrievePwButton.addTarget(self, action: "retrievePasswordAction", forControlEvents: .TouchUpInside)
        loginButton .addTarget(self, action: "loginButtonAction", forControlEvents: .TouchUpInside)
        registerButton .addTarget(self, action: "newUserRegisterAction", forControlEvents: .TouchUpInside)
        cancleButton.addTarget(self, action: "cancleAction", forControlEvents: .TouchUpInside)
        wechatButton.addTarget(self, action: "wechatLogin", forControlEvents: .TouchUpInside)
        weiboButton .addTarget(self, action: "weiboLogin", forControlEvents: .TouchUpInside)
        qqButton    .addTarget(self, action: "qqLogin", forControlEvents: .TouchUpInside)
    }
    
    private func initTextField() {
        let size = emailLabel.text?.sizeofStringWithFount1(UIFont.systemFontOfSize(18), maxSize: CGSizeMake(CGFloat.max, CGFloat.max))
        emailTextField.borderStyle         = UITextBorderStyle.RoundedRect
        emailTextField.autocorrectionType  = UITextAutocorrectionType.No
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.None
        emailTextField.returnKeyType       = UIReturnKeyType.Done
        emailTextField.clearButtonMode     = UITextFieldViewMode.WhileEditing
        emailTextField.leftView            = emailLabel
        emailTextField.leftViewMode        = UITextFieldViewMode.Always
        emailLabel.bounds           = CGRectMake(0, 0, size!.width, size!.height)
        
        passwordTextField.borderStyle      = UITextBorderStyle.RoundedRect
        passwordTextField.leftView         = passwLabel
        passwordTextField.leftViewMode     = UITextFieldViewMode.Always
        passwordTextField.autocorrectionType = UITextAutocorrectionType.No
        passwordTextField.returnKeyType    = UIReturnKeyType.Done
        passwordTextField.clearButtonMode  = UITextFieldViewMode.WhileEditing
        passwordTextField.rightView        = passwordEyeButton
        passwordTextField.rightViewMode    = UITextFieldViewMode.Always
        passwordTextField.secureTextEntry  = true
        passwLabel.bounds                  = CGRectMake(0, 0, size!.width, size!.height)
        passwordEyeButton.bounds           = CGRectMake(0, 0, 15, 11)
    }
    
    private func initAutoLayout() {
        let screen = UIScreen.mainScreen().bounds
        let size = CGSizeMake(screen.width * 0.73, 42)
        emailTextField.ff_AlignInner(.TopCenter, referView: view, size: size, offset: CGPointMake(0, screen.height * 0.2))
        passwordTextField.ff_AlignVertical(.BottomCenter, referView: emailTextField, size: size, offset: CGPointMake(0, 6))
        loginButton.ff_AlignVertical(.BottomCenter, referView: passwordTextField, size: size, offset: CGPointMake(0, screen.height * 0.04))
        cancleButton.ff_AlignVertical(.BottomCenter, referView: loginButton, size: size, offset: CGPointMake(0, 6))
        welcomeLabel.ff_AlignInner(.TopCenter, referView: view, size: nil, offset: CGPointMake(0, screen.height * 0.1))
        retrievePwButton.ff_AlignVertical(.BottomLeft, referView: cancleButton, size: nil, offset: CGPointMake(0, screen.height * 0.02))
        registerButton.ff_AlignVertical(.BottomRight, referView: cancleButton, size: nil, offset: CGPointMake(0, screen.height * 0.02))
        qqButton.ff_AlignInner(.BottomCenter, referView: view, size: CGSizeMake(45, 45), offset: CGPointMake(0, -(screen.height * 0.13)))
        wechatButton.ff_AlignHorizontal(.CenterLeft, referView: qqButton, size: CGSizeMake(45, 45), offset: CGPointMake(-49, 0))
        weiboButton.ff_AlignHorizontal(.CenterRight, referView: qqButton, size: CGSizeMake(45, 45), offset: CGPointMake(49, 0))
        baseLineView.ff_AlignVertical(.TopCenter, referView: qqButton, size: CGSizeMake(screen.width * 0.84, 0.5), offset: CGPointMake(0, -(screen.height * 0.033)))
        elseLoginLabel.ff_AlignVertical(.TopCenter, referView: baseLineView, size: nil, offset: CGPointMake(0, -5))
    }
    
    // MARK: - 自定义方法
    func cancleAction() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 收回键盘方法
    func keyboardTakebackBtnAction(btn: UIButton) {
        view.endEditing(true)
    }
    
    //微信登陆
    func wechatLogin() {
        UserLogin.sharedInstance.thirdLogin(LoginType.Weixin) { (result, error) -> () in
            self.loginResultDispose(result, error: error)
        }
    }
    
    //qq登陆
    func qqLogin() {
        UserLogin.sharedInstance.thirdLogin(LoginType.QQ) { (result, error) -> () in
            self.loginResultDispose(result, error: error)
        }
    }
    
    //新浪微博登陆
    func weiboLogin() {
        UserLogin.sharedInstance.thirdLogin(LoginType.Weibo) { (result, error) -> () in
            self.loginResultDispose(result, error: error)
        }
    }
    
    /// 登陆后的处理
    private func loginResultDispose(result: Bool, error: NSError?) {
        if error != nil {
            SVProgressHUD.showWithStatus("您的网络链接不稳定，请稍候登录")
            return
        } else {
            if result == true {
                cancleAction()
            } else {
                SVProgressHUD.showWithStatus("您的网络链接不稳定，请稍候登录")
            }
        }
    }
    
    /// 新用户注册方法
    func newUserRegisterAction() {
        (parentViewController as? UINavigationController)?.pushViewController(NewUserRegisterViewController(), animated: true)
    }
    
    /// 找回密码方法
    func retrievePasswordAction() {
        (parentViewController as? UINavigationController)?.pushViewController(RetrievePasswordController(), animated: true)
    }
    
    func passwordEyeButton(btn: UIButton) {
        btn.selected = !btn.selected
        passwordTextField.secureTextEntry  = btn.selected
    }
    
    /// 登陆方法
    func loginButtonAction() {
        
        let emailStr = emailTextField.text ?? ""
        let passwStr = passwordTextField.text ?? ""
        if emailStr.validateEmail(emailStr) {
            if passwStr.validatePassword(passwStr) {
                UserRegisterRequest.userEmailLogin(emailStr, passwd: passwStr, handler: { (result, status) -> Void in
                    if status == RetCode.SUCCESS {
                        UserLogin.sharedInstance.loadAccount({ (result, status) -> Void in
                            if status == RetCode.SUCCESS {
                                UserLogin.sharedInstance.loadAccount({ (result, status) -> Void in
                                    if status == RetCode.SUCCESS {
                                        let vc = self.parentViewController?.presentingViewController as? SlideMenuViewController
                                            vc?.dismissViewControllerAnimated(true, completion: { () -> Void in
                                            vc?.curVCType = RecommendViewController.self
                                            self.loginFinished?(result: true, error: nil)
                                        })
                                        if vc == nil {
                                            UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
                                            self.loginFinished?(result: true, error: nil)
                                        }
                                    } else {
                                        SVProgressHUD.showInfoWithStatus("登陆失败，请重新登陆")
                                        self.loginFinished?(result: false, error: nil)
                                    }
                                })
                            } else {
                                SVProgressHUD.showInfoWithStatus("登陆失败，请重新登陆")
                                self.loginFinished?(result: false, error: nil)
                            }
                        })
                    } else {
                        SVProgressHUD.showInfoWithStatus("登陆失败，请重新登陆")
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
