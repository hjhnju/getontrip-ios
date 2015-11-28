
//
//  ShareView.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/3.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import FFAutoLayout

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
    lazy var shareBtn4: shareButton = shareButton(image: "share_qq_zone", title: "QQ空间", fontSize: 12, titleColor: SceneColor.fontGray)
    /// 复制链接
    lazy var shareBtn5: shareButton = shareButton(image: "share_qq", title: "qq好友", fontSize: 12, titleColor: SceneColor.fontGray)
    /// 取消按钮
    lazy var shareCancle: UIButton = UIButton(title: "取消", fontSize: 13, radius: 15)
    /// 分享至标题
    lazy var shareLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "分享至", fontSize: 15, mutiLines: true)
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
        initView()
        initAutoLayout()
    }
    
    ///  初始化view
    private func initView() {
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
        
        shareCancle.addTarget(self, action: "shareCancleAction", forControlEvents: .TouchUpInside)
        shareBtn1.addTarget(self, action: "shareAction:", forControlEvents: .TouchUpInside)
        shareBtn2.addTarget(self, action: "shareAction:", forControlEvents: .TouchUpInside)
        shareBtn3.addTarget(self, action: "shareAction:", forControlEvents: .TouchUpInside)
        shareBtn4.addTarget(self, action: "shareAction:", forControlEvents: .TouchUpInside)
        shareBtn5.addTarget(self, action: "shareAction:", forControlEvents: .TouchUpInside)
    }
    
    ///  初始化自动布局
    private func initAutoLayout() {
        let sbx: CGFloat = CGFloat((bounds.width - (50 * 5)) / 6)
        let size = CGSizeMake(50, 73)
        
        
        let shareVCons = shareView.ff_AlignVertical(.BottomLeft, referView: self, size: CGSize(width: bounds.width, height: 197), offset: CGPoint(x: 0, y: 0))
        
        let s1 = shareBtn1.ff_AlignInner(.CenterLeft, referView: shareView, size: size, offset: CGPoint(x: sbx, y: 150))
        let s2 = shareBtn2.ff_AlignHorizontal(.CenterRight, referView: shareBtn1, size: size, offset: CGPoint(x: sbx, y: 200))
        let s3 = shareBtn3.ff_AlignHorizontal(.CenterRight, referView: shareBtn2, size: size, offset: CGPoint(x: sbx, y: 250))
        let s4 = shareBtn4.ff_AlignHorizontal(.CenterRight, referView: shareBtn3, size: size, offset: CGPoint(x: sbx, y: 300))
        let s5 = shareBtn5.ff_AlignHorizontal(.CenterRight, referView: shareBtn4, size: size, offset: CGPoint(x: sbx, y: 350))
        shareCancle.ff_AlignInner(.BottomCenter, referView: shareView, size: CGSizeMake(93, 34), offset: CGPointMake(0, -17))
        shareBtnY1 = shareBtn1.ff_Constraint(s1, attribute: .CenterY)
        shareBtnY2 = shareBtn2.ff_Constraint(s2, attribute: .CenterY)
        shareBtnY3 = shareBtn3.ff_Constraint(s3, attribute: .CenterY)
        shareBtnY4 = shareBtn4.ff_Constraint(s4, attribute: .CenterY)
        shareBtnY5 = shareBtn5.ff_Constraint(s5, attribute: .CenterY)
        
        shareLabel.ff_AlignInner(.TopCenter, referView: shareView, size: nil, offset: CGPointMake(0, 18))
        shareViewCY = shareView.ff_Constraint(shareVCons, attribute: .Top)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///  分享外界参数访问
    ///
    ///  - parameter subview:  需要添加的view
    ///  - parameter url:      分享url
    ///  - parameter images:   分享图片
    ///  - parameter title:    分享标题
    ///  - parameter subtitle: 分享副标题
    ///  - parameter result:   结果回调，成功有提示，失败无提示
    func showShareAction(subview: UIView, url: String?, images: UIImage?, title: String?, subtitle: String?) {
        
        ///  显示控件
        subview.addSubview(self)
        self.shareView.layoutIfNeeded()
        let y =  197 * 0.5 - (shareCancle.frame.origin.y - CGRectGetMaxY(shareLabel.frame) - 3)
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.shareViewCY?.constant = -197
            self.shareView.layoutIfNeeded()
            
            }) { (_) -> Void in
                UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
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
        
        ///  加载分享描述参数参数
        var text = ""
        if subtitle != nil {
            let lab = NSString(string: subtitle!)
            if lab.length > 25 {
                text = lab.substringWithRange(NSMakeRange(0, 25))
            } else {
                text = lab as String
            }
        }
        
        shareParames.SSDKSetupShareParamsByText(text,
            images : images?.scaleImage(200) ?? nil,
            url : NSURL(string: url ?? ""),
            title : title ?? "",
            type : SSDKContentType.Auto)
    }
    
    
    // MARK: - 分享方法
    func shareAction(sender: UIButton) {
        switch sender.tag {
        case 1: shareFullType(SSDKPlatformType.SubTypeWechatSession)
        case 2: shareFullType(SSDKPlatformType.SubTypeWechatTimeline)
        case 3: shareFullType(SSDKPlatformType.TypeSinaWeibo)
        case 4: shareFullType(SSDKPlatformType.SubTypeQZone)
        case 5: shareFullType(SSDKPlatformType.SubTypeQQFriend)
        default:
            break
        }
    }
    
    ///  分享方法（所有类型）
    private func shareFullType(type: SSDKPlatformType) {
        var shareAlert = "微信"
        let shareParame: NSMutableDictionary = NSMutableDictionary(dictionary: shareParames)
        if type == SSDKPlatformType.TypeSinaWeibo {
            let text = (shareParames["text"] ?? "") as! String + (shareParames["url"] as! NSURL).absoluteString ?? ""
            shareParame["text"] = text
            shareAlert = "微博"
        }
        
        if type == SSDKPlatformType.SubTypeQZone || type == SSDKPlatformType.SubTypeQQFriend {
            shareAlert = "qq"
        }
        
        ShareSDK.share(type, parameters: shareParame)
            { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
            
            switch state{
            case SSDKResponseState.Success:
                let alert = UIAlertView(title: "分享成功", message: "", delegate: self, cancelButtonTitle: "确定")
                alert.show()
            case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
            if error.code == 208 {
                let alert = UIAlertView(title: "分享失败", message: "您未安装\(shareAlert)无法进行分享", delegate: self, cancelButtonTitle: "确定")
                alert.show()
            } else {
                let alert = UIAlertView(title: "分享失败", message: "您的网络不稳定，请稍候分享", delegate: self, cancelButtonTitle: "确定")
                alert.show()
            }
            
            case SSDKResponseState.Cancel:  print("分享取消")
                
            default:
                break
            }
        }
    }
    
    ///  隐藏所有控件
    func shareCancleAction() {
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



