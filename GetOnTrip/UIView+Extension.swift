//
//  extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

extension UIView {
    
    convenience init(color: UIColor, alphaF: CGFloat = 1) {
        self.init()
        
        backgroundColor = color
        alpha = alphaF
    }
}


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

class ShareView: UIView {
    
    /// 分享底view
    lazy var shareView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
    /// 微信
    lazy var shareBtn1: shareButton = shareButton(image: "share_weixin", title: "微信好友", fontSize: 12, titleColor: SceneColor.fontGray)
    /// 朋友圈
    lazy var shareBtn2: shareButton = shareButton(image: "share_weixinfri", title: "朋友圈", fontSize: 12, titleColor: SceneColor.fontGray)
    /// 新浪微博
    lazy var shareBtn3: shareButton = shareButton(image: "share_weibo", title: "新浪微博", fontSize: 12, titleColor: SceneColor.fontGray)
    /// qq
    lazy var shareBtn4: shareButton = shareButton(image: "share_qq", title: "QQ空间", fontSize: 12, titleColor: SceneColor.fontGray)
    /// 复制链接
    lazy var shareBtn5: shareButton = shareButton(image: "share_link", title: "复制链接", fontSize: 12, titleColor: SceneColor.fontGray)
    /// 取消按钮
    lazy var shareCancle: UIButton = UIButton(title: "取消", fontSize: 13, radius: 15)
    /// 分享至标题
    lazy var shareLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "分享至", fontSize: 13, mutiLines: true)
    /// 分享view y
    var shareViewCY : NSLayoutConstraint?
    /// 微信约束y
    var shareBtnY1: NSLayoutConstraint?
    /// 朋友圈约束y
    var shareBtnY2: NSLayoutConstraint?
    /// 新浪微博约束y
    var shareBtnY3: NSLayoutConstraint?
    /// qq约束y
    var shareBtnY4: NSLayoutConstraint?
    /// 复制链接y
    var shareBtnY5: NSLayoutConstraint?
    /// 分享参数
    var shareParames = NSMutableDictionary()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        shareView.alpha = 1
        shareView.contentView.backgroundColor = UIColor.whiteColor()
        shareView.contentView.alpha = 0.5
        
        self.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - 197, UIScreen.mainScreen().bounds.width, 197)
        setupProperty()
        setupAutoLayout()
    }
    
    private func setupProperty() {
        addSubview(shareView)
        shareView.addSubview(shareLabel)
        shareView.addSubview(shareBtn1)
        shareView.addSubview(shareBtn2)
        shareView.addSubview(shareBtn3)
        shareView.addSubview(shareBtn4)
        shareView.addSubview(shareBtn5)
        shareView.addSubview(shareCancle)
        shareBtn1.tag = 1
        shareBtn2.tag = 2
        shareBtn3.tag = 3
        shareBtn4.tag = 4
        shareBtn5.tag = 5
        
        shareCancle.backgroundColor = SceneColor.lightYellow
        shareCancle.setTitleColor(SceneColor.bgBlack, forState: UIControlState.Normal)
        
        shareCancle.addTarget(self, action: "shareCancleClick", forControlEvents: UIControlEvents.TouchUpInside)
        shareBtn1.addTarget(self, action: "shareClick:", forControlEvents: UIControlEvents.TouchUpInside)
        shareBtn2.addTarget(self, action: "shareClick:", forControlEvents: UIControlEvents.TouchUpInside)
        shareBtn3.addTarget(self, action: "shareClick:", forControlEvents: UIControlEvents.TouchUpInside)
        shareBtn4.addTarget(self, action: "shareClick:", forControlEvents: UIControlEvents.TouchUpInside)
        shareBtn5.addTarget(self, action: "shareClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupAutoLayout() {
        let sbx: CGFloat = CGFloat((bounds.width - (50 * 5)) / 6)
        let size = CGSizeMake(50, 73)
        
        
        let shareVCons = shareView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: self, size: CGSize(width: bounds.width, height: 197), offset: CGPoint(x: 0, y: 0))

        let s1 = shareBtn1.ff_AlignInner(ff_AlignType.CenterLeft, referView: shareView, size: size, offset: CGPoint(x: sbx, y: 150))
        let s2 = shareBtn2.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: shareBtn1, size: size, offset: CGPoint(x: sbx, y: 200))
        let s3 = shareBtn3.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: shareBtn2, size: size, offset: CGPoint(x: sbx, y: 250))
        let s4 = shareBtn4.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: shareBtn3, size: size, offset: CGPoint(x: sbx, y: 300))
        let s5 = shareBtn5.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: shareBtn4, size: size, offset: CGPoint(x: sbx, y: 350))
        shareCancle.ff_AlignInner(ff_AlignType.BottomCenter, referView: shareView, size: CGSizeMake(93, 34), offset: CGPointMake(0, -17))
        shareBtnY1 = shareBtn1.ff_Constraint(s1, attribute: NSLayoutAttribute.CenterY)
        shareBtnY2 = shareBtn2.ff_Constraint(s2, attribute: NSLayoutAttribute.CenterY)
        shareBtnY3 = shareBtn3.ff_Constraint(s3, attribute: NSLayoutAttribute.CenterY)
        shareBtnY4 = shareBtn4.ff_Constraint(s4, attribute: NSLayoutAttribute.CenterY)
        shareBtnY5 = shareBtn5.ff_Constraint(s5, attribute: NSLayoutAttribute.CenterY)
        
        shareLabel.ff_AlignInner(ff_AlignType.TopCenter, referView: shareView, size: nil, offset: CGPointMake(0, 18))
        shareViewCY = shareView.ff_Constraint(shareVCons, attribute: NSLayoutAttribute.Top)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///  分享方法
    ///
    ///  - parameter subview:     需要添加到哪个view，一般传所在控制器的view
    ///  - parameter topic:       话题或书籍对象
    ///  - parameter images:      分享图片
    ///  - parameter isTopicBook: true为话题false为书籍
    func getShowShareAction(subview: UIView, url: String?, images: UIImage?, text: String?) {
        
        ///  显示控件
        subview.addSubview(self)
        self.shareView.layoutIfNeeded()
        let y =  197 * 0.5 - (shareCancle.frame.origin.y - CGRectGetMaxY(shareLabel.frame) - 3)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.shareViewCY?.constant = -197
            self.shareView.layoutIfNeeded()
            
            }) { (_) -> Void in
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    self.shareBtnY1?.constant = y
                    
                    self.shareBtnY2?.constant = 0
                    self.shareBtnY3?.constant = 0
                    self.shareBtnY4?.constant = 0
                    self.shareBtnY5?.constant = 0
                    self.shareBtn1.layoutIfNeeded()
                    self.shareBtn2.layoutIfNeeded()
                    self.shareBtn3.layoutIfNeeded()
                    self.shareBtn4.layoutIfNeeded()
                    self.shareBtn5.layoutIfNeeded()
                }, completion: nil)
        }
        
        ///  加载分享参数
        shareParames.SSDKSetupShareParamsByText(url ?? "",
            images : images ?? nil,
            url : NSURL(string: url ?? ""),
            title : text ?? "",
            type : SSDKContentType.Auto)
    }
    
    
    // MARK: - 分享 微信好友
    func shareClick(sender: UIButton) {
        switch sender.tag {
        case 1: shareFriendCircle(SSDKPlatformType.SubTypeWechatSession)
        case 2: shareFriendCircle(SSDKPlatformType.SubTypeWechatTimeline)
        case 3: shareFriendCircle(SSDKPlatformType.TypeSinaWeibo)
        case 4: shareFriendCircle(SSDKPlatformType.SubTypeQZone)
        case 5: shareFriendCircle(SSDKPlatformType.TypeCopy)
        default:
            break
        }
    }
    
    ///  朋友圈
    func shareFriendCircle(type: SSDKPlatformType) {
        
        ShareSDK.share(type, parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
            
            switch state{
            case SSDKResponseState.Success:
                print("分享成功")
                let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "取消")
                alert.show()
            case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  print("分享取消")
                
            default:
                break
            }
        }
    }
    
    func shareCancleClick() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.shareBtnY1?.constant = 150
            self.shareBtnY2?.constant = 200
            self.shareBtnY3?.constant = 250
            self.shareBtnY4?.constant = 300
            self.shareBtnY5?.constant = 350
            self.shareBtn1.layoutIfNeeded()
            self.shareBtn2.layoutIfNeeded()
            self.shareBtn3.layoutIfNeeded()
            self.shareBtn4.layoutIfNeeded()
            self.shareBtn5.layoutIfNeeded()
            }) { (_) -> Void in
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.shareViewCY?.constant = self.bounds.height
                    self.shareView.layoutIfNeeded()
                    }, completion: { (_) -> Void in
                        self.removeFromSuperview()
                })
        }
    }
}



