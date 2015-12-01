
//
//  LoginView.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/3.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import FFAutoLayout

class LoginView: UIView {
    
    static let sharedLoginView = LoginView()
    
    lazy var loginBackground: UIButton = UIButton()
    
    lazy var loginPrompt: UILabel      = UILabel(color: UIColor.whiteColor(), title: "使用以下账号直接登录", fontSize: 16, mutiLines: true)

    lazy var wechatButton: UIButton    = UIButton(icon: "icon_weixin", masksToBounds: true)

    lazy var qqButton: UIButton        = UIButton(icon: "icon_qq", masksToBounds: true)
    
    lazy var sinaweiButton: UIButton   = UIButton(icon: "icon_weibo", masksToBounds: true)
    
    lazy var emailButton: UIButton     = UIButton(title: "或使用邮箱密码 登录", fontSize: 16, radius: 0, titleColor: UIColor.whiteColor())
    
    /// 登陆后需要执行的操作
    var loginFinishedHandler: UserLogin.LoginFinishedHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAddProperty()
        setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAddProperty() {
        addSubview(loginBackground)
        addSubview(loginPrompt)
        addSubview(wechatButton)
        addSubview(qqButton)
        addSubview(sinaweiButton)
        addSubview(emailButton)
        
        loginBackground.backgroundColor = UIColor.blackColor()
        loginBackground.alpha = 0.7
        
        loginBackground.addTarget(self, action: "dismissFloating", forControlEvents: .TouchUpInside)
        wechatButton   .addTarget(self, action: "wechatLogin", forControlEvents: .TouchUpInside)
        sinaweiButton  .addTarget(self, action: "moreLogin", forControlEvents: .TouchUpInside)
        qqButton       .addTarget(self, action: "qqLogin", forControlEvents: .TouchUpInside)
        emailButton    .addTarget(self, action: "emailButtonAction", forControlEvents: .TouchUpInside)
        let attr = "或使用邮箱密码 登录".getAttributedStringColor("登录", normalColor: UIColor.whiteColor(), differentColor: SceneColor.lightblue)
        emailButton.setAttributedTitle(attr, forState: .Normal)
    }
    
    private func setupAutoLayout() {
        loginBackground.ff_Fill(self)
        loginPrompt.ff_AlignInner(.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, -75))
        
        
        let wechaInstall = Device.isWeixinInstalled()
        
        if Device.isIPad() && !wechaInstall {
            wechatButton.hidden = true
            qqButton.ff_AlignInner(.CenterCenter, referView: self, size: CGSizeMake(55, 55), offset: CGPointMake(-50, 20))
            sinaweiButton.ff_AlignInner(.CenterCenter, referView: self, size: CGSizeMake(55, 55), offset: CGPointMake(50, 20))
            emailButton.ff_AlignInner(.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 126))
        } else {
            qqButton.ff_AlignInner(.CenterCenter, referView: self, size: CGSizeMake(55, 55), offset: CGPointMake(0, -20))
            sinaweiButton.ff_AlignHorizontal(.CenterRight, referView: qqButton, size: CGSizeMake(55, 55), offset: CGPointMake(50, 0))
            wechatButton.ff_AlignHorizontal(.CenterLeft, referView: qqButton, size: CGSizeMake(55, 55), offset: CGPointMake(-50, 0))
            emailButton.ff_AlignVertical(.BottomCenter, referView: qqButton, size: nil, offset: CGPointMake(0, 126))
        }
    }
    
    // MARK: 自定义方法
    func doAfterLogin(handler: UserLogin.LoginFinishedHandler) {
        //未登录记录操作，待登录后执行；已登陆则直接执行制定操作
        if globalUser == nil {
            showFloating()
            self.loginFinishedHandler = handler
        } else {
            handler(result: true, error: nil)
        }
    }
    
    /**
    展示登录浮层
    */
    private func showFloating() {
        let lv = LoginView.sharedLoginView
        lv.frame = UIScreen.mainScreen().bounds
        UIApplication.sharedApplication().keyWindow?.addSubview(lv)
        lv.alpha = 0
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            lv.alpha = 1
        })
    }
    
    /**
    取消登录浮层
    */
    func dismissFloating() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.alpha = 0
            }) { (_) -> Void in
                self.removeFromSuperview()
                if globalUser == nil {
                    self.loginFinishedHandler?(result: false, error: nil)
                }
        }
    }
    
    //微信登陆
    func wechatLogin() {
        UserLogin.sharedInstance.thirdLogin(LoginType.Weixin, finishHandler: self.loginFinishedHandler){ (_) -> Void in
        }
        self.dismissFloating()
    }
    
    //qq登陆
    func qqLogin() {
        UserLogin.sharedInstance.thirdLogin(LoginType.QQ, finishHandler: self.loginFinishedHandler){ (_) -> Void in
        }
        self.dismissFloating()
    }
    
    //新浪微博登陆
    func moreLogin() {
        UserLogin.sharedInstance.thirdLogin(LoginType.Weibo, finishHandler: self.loginFinishedHandler){ (_) -> Void in
        }
        self.dismissFloating()
    }
    
    // 邮箱登陆
    func emailButtonAction() {
        let log = LoginViewController()
        let nav = UINavigationController(rootViewController: log)
        log.loginFinished = self.loginFinishedHandler
        self.dismissFloating()
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(nav, animated: true, completion: { () -> Void in
            UIApplication.sharedApplication().keyWindow?.bringSubviewToFront(nav.view)
        })
    }
}
