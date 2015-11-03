
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
    
    /// 回调用于做完之后不影响之前的操作
    typealias LoginFinishedOperate = (result: AnyObject?, error: NSError?) -> ()
    
    lazy var loginBackground: UIButton = UIButton()
    
    lazy var loginPrompt: UILabel = UILabel(color: UIColor.whiteColor(), title: "使用以下账号直接登录", fontSize: 16, mutiLines: true)
    
    //微信
    lazy var wechatButton: UIButton = UIButton(icon: "icon_weixin", masksToBounds: true)
    //QQ
    lazy var qqButton: UIButton = UIButton(icon: "icon_qq", masksToBounds: true)
    //微博
    lazy var weiboButton: UIButton = UIButton(icon: "icon_weibo", masksToBounds: true)
    
    static let sharedLoginView = LoginView()
    
    var loginStatus: Bool = false
    
    var loginFinished: LoginFinishedOperate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAddProperty()
        setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAddProperty() {
        addSubview(loginBackground)
        addSubview(loginPrompt)
        addSubview(wechatButton)
        addSubview(qqButton)
        addSubview(weiboButton)
        
        loginBackground.backgroundColor = UIColor.blackColor()
        loginBackground.alpha = 0.7
        
        loginBackground.addTarget(self, action: "loginBackgroundClick", forControlEvents: UIControlEvents.TouchUpInside)
        wechatButton.addTarget(self, action: "wechatLogin", forControlEvents: UIControlEvents.TouchUpInside)
        weiboButton.addTarget(self, action: "weiboLogin", forControlEvents: UIControlEvents.TouchUpInside)
        qqButton.addTarget(self, action: "qqLogin", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    
    func setupAutoLayout() {
        
        loginBackground.ff_Fill(self)
        loginPrompt.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, -55))
        qqButton.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: CGSizeMake(55, 55), offset: CGPointMake(0, 0))
        weiboButton.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: qqButton, size: CGSizeMake(55, 55), offset: CGPointMake(50, 0))
        wechatButton.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: qqButton, size: CGSizeMake(55, 55), offset: CGPointMake(-50, 0))
        
    }
    
    func loginBackgroundClick() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.alpha = 0
            }) { (_) -> Void in
                self.loginFinished!(result: self.loginStatus, error: nil)
                self.removeFromSuperview()
        }
    }
    
    //微信登陆
    func wechatLogin() {
        
        thirdParthLogin(SSDKPlatformType.TypeWechat, loginType: LoginType.weixinLogin) { (result, error) -> () in
            if error != nil {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
            }
        }
    }
    
    //qq登陆
    func qqLogin() {
        thirdParthLogin(SSDKPlatformType.TypeQQ, loginType: LoginType.qqLogin) { (result, error) -> () in
            if error != nil {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
            }
        }
    }
    
    //新浪微博登陆
    func weiboLogin() {
        
        thirdParthLogin(SSDKPlatformType.TypeSinaWeibo, loginType: LoginType.weiboLogin) { (result, error) -> () in
            if error != nil {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
            }
        }
    }
    
    //第三方登陆
    func thirdParthLogin(type: SSDKPlatformType, loginType: Int, finish: LoginFinishedOperate) {
        //授权
        ShareSDK.authorize(type, settings: nil, onStateChanged: { [weak self] (state : SSDKResponseState, user : SSDKUser!, error : NSError!) -> Void in
            
            switch state{
                
            case SSDKResponseState.Success: print("授权成功,用户信息为\(user)\n ----- 授权凭证为\(user.credential)")
            self!.loginStatus = true
            let account = UserAccount(user: user, type: loginType)
            sharedUserAccount = account
            self!.loginBackgroundClick()
            case SSDKResponseState.Fail:    print("授权失败,错误描述:\(error)")
            finish(result: false, error: error)
            case SSDKResponseState.Cancel:  print("操作取消")
            default:
                break
            }
            })
    }
    
    func addLoginFloating(finish: LoginFinishedOperate) {
        let lv = LoginView.sharedLoginView
        lv.frame = UIScreen.mainScreen().bounds
        UIApplication.sharedApplication().keyWindow?.addSubview(lv)
        lv.alpha = 0
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            lv.alpha = 1
        })
        
        loginFinished = finish
    }
}
