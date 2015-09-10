//
//  SideViewController.swift
//  GetOnTrip
//
//  Created by guojinli on 15/7/27.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import SDWebImage

class MenuViewController: UIViewController {
    
    @IBOutlet weak var sideTableViewController: UIView!
    
    
    @IBOutlet weak var iconView: UIImageView!
    //MARK: Properties
    var logined: Bool = false
    
    var headImage: UIImage? {
        didSet {
//            headButton.imageView
            headButton.setBackgroundImage(headImage, forState: UIControlState.Normal)
        }
    }
    
    var userName: String? {
        didSet {
            if let name = userName {
                user_name.text = "\(name)"
            }
        }
    }

    var bgImageUrl: String? {
        didSet {
            if let url = bgImageUrl {
                ImageLoader.sharedLoader.imageForUrl(url) { (image:UIImage?, url:String) in
                    self.bgImageView.image = image
                    // blur process
                    let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
                    blur.frame = self.bgImageView.frame
                    for v in self.bgImageView.subviews {
                        v.removeFromSuperview()
                    }
                    self.bgImageView.addSubview(blur)
                }
            }
        }
    }
    
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var unloginView: UIView!
    @IBOutlet weak var headButton: UIButton!
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var welcome_label: UILabel!
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //backgroud
        bgImageView.contentMode = UIViewContentMode.ScaleToFill
        bgImageView.clipsToBounds = true
        
        if logined {
            refresh()
        }
        welcome_label.hidden = logined ?? false
    }
    
    func refresh() {
        if logined {
            iconView.sd_setImageWithURL(NSURL(string: sharedUserAccount!.icon!))
            iconView.layer.cornerRadius = iconView.frame.width / 2
            iconView.clipsToBounds = true
            userName  = sharedUserAccount?.nickname
            unloginView.hidden = true
            headButton.hidden = false
            //圆角头像
            headButton.layer.cornerRadius = headButton.frame.width / 2
            headButton.clipsToBounds = true
            headButton.setTitle("", forState: .Normal)
            user_name.hidden = false
            welcome_label.hidden = true
        }else {
            headButton.hidden = true
            iconView.hidden = true
        }
    }
    
    // MARK: - 第三方登陆 微信登陆
    @IBAction func wechatLogin(sender: UIButton) {
//        UserAccount()!.wechatLogin()
        ShareSDK.authorize(SSDKPlatformType.TypeWechat, settings: nil, onStateChanged: { (state : SSDKResponseState, user : SSDKUser!, error : NSError!) -> Void in
            
            switch state{
                
            case SSDKResponseState.Success: println("授权成功,用户信息为\(user)\n ----- 授权凭证为\(user.credential)")
            self.login(user.uid.toInt()!, type: 3)
            var account = UserAccount(user: user)
            
            sharedUserAccount = account
            self.logined = true
            self.refresh()
                
            case SSDKResponseState.Fail:    println("授权失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  println("操作取消")
                
            default:
                break
            }
        })
    }
    
    /// MARK: - qq登陆
    @IBAction func qqLogin(sender: UIButton) {
        ShareSDK.authorize(SSDKPlatformType.TypeQQ, settings: nil, onStateChanged: { (state : SSDKResponseState, user : SSDKUser!, error : NSError!) -> Void in
            
            switch state{
                
            case SSDKResponseState.Success: println("授权成功,用户信息为\(user)\n ----- 授权凭证为\(user.credential)")
            self.login(user.uid.toInt()!, type: 3)
            var account = UserAccount(user: user)
            
            sharedUserAccount = account
            self.logined = true
            self.refresh()
                
            case SSDKResponseState.Fail:    println("授权失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  println("操作取消")
                
            default:
                break
            }
        })
    }
    
    var lastSuccessRequest: UserLoghtRequest?

    
    /// MARK: - 新浪微博登陆
    @IBAction func SinaWeiboLogin(sender: UIButton) {
        //授权
        ShareSDK.authorize(SSDKPlatformType.TypeSinaWeibo, settings: nil, onStateChanged: { (state : SSDKResponseState, user : SSDKUser!, error : NSError!) -> Void in
            
            switch state{
                
            case SSDKResponseState.Success: println("授权成功,用户信息为\(user)\n ----- 授权凭证为\(user.credential)")
//                login(openId: Int)
            self.login(user.uid.toInt()!, type: 3)
            var account = UserAccount(user: user)
            
                sharedUserAccount = account
                self.logined = true
                self.refresh()
                
            case SSDKResponseState.Fail:    println("授权失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  println("操作取消")
                
            default:
                break
            }
        })
        
        // 发送数据，进行登陆告知
    }
    
    // MARK: 告诉后台用户已登陆
    private func login(openId: Int, type: Int) {
        UserLoghtRequest(openId: openId, type: type).fetchLoginModels()
    }
        
}
    
    

