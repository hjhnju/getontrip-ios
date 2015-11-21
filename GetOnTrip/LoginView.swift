
//
//  LoginView.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/3.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import FFAutoLayout
import SVProgressHUD

class LoginView: UIView {
    
    static let sharedLoginView = LoginView()
    
    lazy var loginBackground: UIButton = UIButton()
    
    lazy var loginPrompt: UILabel = UILabel(color: UIColor.whiteColor(), title: "使用以下账号直接登录", fontSize: 16, mutiLines: true)

    lazy var wechatButton: UIButton = UIButton(icon: "icon_weixin", masksToBounds: true)

    lazy var qqButton: UIButton = UIButton(icon: "icon_qq", masksToBounds: true)
    
    lazy var moreButton: UIButton = UIButton(icon: "more_white", masksToBounds: true)
    
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
        addSubview(moreButton)
        
        loginBackground.backgroundColor = UIColor.blackColor()
        loginBackground.alpha = 0.7
        
        loginBackground.addTarget(self, action: "dismissFloating", forControlEvents: UIControlEvents.TouchUpInside)
        wechatButton.addTarget(self, action: "wechatLogin", forControlEvents: UIControlEvents.TouchUpInside)
        moreButton.addTarget(self, action: "moreLogin", forControlEvents: UIControlEvents.TouchUpInside)
        qqButton.addTarget(self, action: "qqLogin", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupAutoLayout() {
        loginBackground.ff_Fill(self)
        loginPrompt.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, -55))
        qqButton.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: CGSizeMake(55, 55), offset: CGPointMake(0, 0))
        moreButton.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: qqButton, size: CGSizeMake(55, 55), offset: CGPointMake(50, 0))
        wechatButton.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: qqButton, size: CGSizeMake(55, 55), offset: CGPointMake(-50, 0))
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
                self.loginFinishedHandler?(result: false, error: nil)
        }
    }
    
    //微信登陆
    func wechatLogin() {
        UserLogin.sharedInstance.thirdLogin(LoginType.Weixin, finishHandler: self.loginFinishedHandler)
        dismissFloating()
    }
    
    //qq登陆
    func qqLogin() {
        UserLogin.sharedInstance.thirdLogin(LoginType.QQ, finishHandler: self.loginFinishedHandler)
        dismissFloating()
    }
    
    //新浪微博登陆
    func moreLogin() {
        let log = LoginViewController()
        log.loginFinished = self.loginFinishedHandler
        self.dismissFloating()
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(log, animated: true, completion: { () -> Void in
        })

//        UserLogin.sharedInstance.thirdLogin(LoginType.Weibo, finishHandler: self.loginFinishedHandler)
//        dismissFloating()
    }
}
