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
    var welcome   = UILabel(color: UIColor.whiteColor(), title: "Welcome", fontSize: 44, mutiLines: true)
    
    /// 邮箱
    var email     = UITextField(alignment: NSTextAlignment.Left, sizeFout: 18, color: UIColor.blackColor())
    
    /// 密码
    var password  = UITextField(alignment: NSTextAlignment.Left, sizeFout: 18, color: UIColor.blackColor())
    
    /// 登录
    var loginBtn  = UIButton(title: "登录", fontSize: 20, radius: 2, titleColor: UIColor.whiteColor())
    
    /// 取消
    var cancleBtn = UIButton(title: "取消", fontSize: 20, radius: 2, titleColor: UIColor.whiteColor())
    
    /// 忘忆密码
    var retrievePw = UIButton(title: "忘记密码", fontSize: 13, radius: 0, titleColor: UIColor.whiteColor())
    
    /// 注册
    var register  = UIButton(title: "新用户注册", fontSize: 13, radius: 0, titleColor: UIColor.whiteColor())
    
    /// 其他登陆方式
    var elseLogin = UILabel(color: UIColor.whiteColor(), title: "或使用第三方账号登录", fontSize: 13, mutiLines: true)
    
    /// 基线
    var baseLine  = UIView(color: UIColor.whiteColor(), alphaF: 0.5)
    
    /// 微信
    var wechatBtn = UIButton(icon: "icon_weixin", masksToBounds: true)
    
    /// qq
    var qqBtn     = UIButton(icon: "icon_qq", masksToBounds: true)
    
    /// weibo
    var weiboBtn  = UIButton(icon: "icon_weibo", masksToBounds: true)
    
    let emailLab = UILabel(color: SceneColor.lightGrayEM, title: "  邮箱 ", fontSize: 18, mutiLines: true)
    
    let passwLab = UILabel(color: SceneColor.lightGrayEM, title: "  密码 ", fontSize: 18, mutiLines: true)
    
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
        backgroundImageView.frame = UIScreen.mainScreen().bounds
        
        view.addSubview(welcome)
        view.addSubview(email)
        view.addSubview(password)
        view.addSubview(loginBtn)
        view.addSubview(cancleBtn)
        view.addSubview(retrievePw)
        view.addSubview(register)
        view.addSubview(elseLogin)
        view.addSubview(baseLine)
        view.addSubview(wechatBtn)
        view.addSubview(qqBtn)
        view.addSubview(weiboBtn)
        
        cancleBtn.backgroundColor = SceneColor.lightgrey
        loginBtn.backgroundColor  = SceneColor.lightblue
        retrievePw.addTarget(self, action: "retrievePasswordAction", forControlEvents: .TouchUpInside)
        loginBtn .addTarget(self, action: "loginButtonAction", forControlEvents: .TouchUpInside)
        register .addTarget(self, action: "newUserRegisterAction", forControlEvents: .TouchUpInside)
        cancleBtn.addTarget(self, action: "cancleAction", forControlEvents: .TouchUpInside)
        wechatBtn.addTarget(self, action: "wechatLogin", forControlEvents: .TouchUpInside)
        weiboBtn .addTarget(self, action: "weiboLogin", forControlEvents: .TouchUpInside)
        qqBtn    .addTarget(self, action: "qqLogin", forControlEvents: .TouchUpInside)
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
        cancleBtn.ff_AlignInner(.CenterCenter, referView: view, size: size, offset: CGPointMake(0, 0))
        loginBtn.ff_AlignVertical(.TopCenter, referView: cancleBtn, size: size, offset: CGPointMake(0, -6))
        password.ff_AlignVertical(.TopCenter, referView: loginBtn, size: size, offset: CGPointMake(0, -30))
        email.ff_AlignVertical(.TopCenter, referView: password, size: size, offset: CGPointMake(0, -6))
        welcome.ff_AlignInner(.TopCenter, referView: view, size: nil, offset: CGPointMake(0, 42))
        retrievePw.ff_AlignVertical(.BottomLeft, referView: cancleBtn, size: nil, offset: CGPointMake(0, 20))
        register.ff_AlignVertical(.BottomRight, referView: cancleBtn, size: nil, offset: CGPointMake(0, 20))
        qqBtn.ff_AlignInner(.BottomCenter, referView: view, size: CGSizeMake(45, 45), offset: CGPointMake(0, -(screen.height * 0.16)))
        wechatBtn.ff_AlignHorizontal(.CenterLeft, referView: qqBtn, size: CGSizeMake(45, 45), offset: CGPointMake(-49, 0))
        weiboBtn.ff_AlignHorizontal(.CenterRight, referView: qqBtn, size: CGSizeMake(45, 45), offset: CGPointMake(49, 0))
        baseLine.ff_AlignVertical(.TopCenter, referView: qqBtn, size: CGSizeMake(screen.width - 66, 0.5), offset: CGPointMake(0, -25))
        elseLogin.ff_AlignVertical(.TopCenter, referView: baseLine, size: nil, offset: CGPointMake(0, -5))
    }
    
    // MARK: - 自定义方法
    func cancleAction() {
        dismissViewControllerAnimated(true, completion: nil)
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
        (parentViewController as! UINavigationController).pushViewController(NewUserRegisterViewController(), animated: true)
    }
    
    /// 找回密码方法
    func retrievePasswordAction() {
        (parentViewController as! UINavigationController).pushViewController(RetrievePasswordController(), animated: true)
    }
    
    /// 登陆方法
    func loginButtonAction() {
        
        let emailStr = email.text
        if emailStr!.validateEmail(emailStr!) {
            if password.text!.validatePassword(password.text!) {
                UserRegisterRequest.userEmailLogin(email.text!, passwd: password.text!, handler: { (result, status) -> Void in
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
