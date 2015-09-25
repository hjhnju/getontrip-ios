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
    /// 底图图片
    @IBOutlet weak var bgImageView: UIImageView!
    
    //MARK: Properties
    var logined: Bool = true
    
//    var headImage: UIImage? {
//        didSet {
////            headButton.imageView
////            headButton.setBackgroundImage(headImage, forState: UIControlState.Normal)
//        }
//    }
    
//    var userName: String? {
//        didSet {
//            if let name = userName {
//                user_name.text = "\(name)"
//            }
//        }
//    }

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
    /// 用户名称
    @IBOutlet weak var user_name: UILabel!
    /// 用户头像
    @IBOutlet weak var iconView: UIImageView!
    
    /// 第三登陆未显示view
    @IBOutlet weak var unloginView: UIView!
    /// 第三登陆已登陆显示view
    @IBOutlet weak var loginView: UIView!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //backgroud
        bgImageView.contentMode = UIViewContentMode.ScaleToFill
        bgImageView.clipsToBounds = true
        
//        if logined {
//            refresh()
//        }
//        welcome_label.hidden = logined ?? false
        
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        iconView.clipsToBounds = true
    }
    
    func refresh() {
        if logined {
            unloginView.hidden = true
            loginView.hidden = false
            iconView.sd_setImageWithURL(NSURL(string: sharedUserAccount?.icon! ?? ""))
            user_name.text  = sharedUserAccount!.nickname
        } else {
            unloginView.hidden = false
            loginView.hidden = true
        }
    }
    
    // MARK: - 第三方登陆 微信登陆
//    @IBAction func wechatLogin(sender: UIButton) {
////        UserAccount()!.wechatLogin()
//        ShareSDK.authorize(SSDKPlatformType.TypeWechat, settings: nil, onStateChanged: { (state : SSDKResponseState, user : SSDKUser!, error : NSError!) -> Void in
//            
//            switch state{
//                
//            case SSDKResponseState.Success: print("授权成功,用户信息为\(user)\n ----- 授权凭证为\(user.credential)")
//            self.login(Int(user.uid)!, type: 3)
//            let account = UserAccount(user: user, type: 2)
//            
//            sharedUserAccount = account
//            self.logined = true
//            self.refresh()
//                
//            case SSDKResponseState.Fail:    print("授权失败,错误描述:\(error)")
//            case SSDKResponseState.Cancel:  print("操作取消")
//                
//            default:
//                break
//            }
//        })
//    }
//    
//    /// MARK: - qq登陆
//    @IBAction func qqLogin(sender: UIButton) {
//        ShareSDK.authorize(SSDKPlatformType.TypeQQ, settings: nil, onStateChanged: { (state : SSDKResponseState, user : SSDKUser!, error : NSError!) -> Void in
//            
//            switch state{
//                
//            case SSDKResponseState.Success: print("授权成功,用户信息为\(user)\n ----- 授权凭证为\(user.credential)")
////            self.login(Int(user.uid!)!, type: 3)
//            let account = UserAccount(user: user, type: 1)
//            sharedUserAccount = account
////            self.logined = true
////            self.refresh()
//                
//            case SSDKResponseState.Fail:    print("授权失败,错误描述:\(error)")
//            case SSDKResponseState.Cancel:  print("操作取消")
//                
//            default:
//                break
//            }
//        })
//    }
//    
//    var lastSuccessRequest: UserLoghtRequest?
//
//    
//    /// MARK: - 新浪微博登陆
//    @IBAction func SinaWeiboLogin(sender: UIButton) {
//        //授权
//        ShareSDK.authorize(SSDKPlatformType.TypeSinaWeibo, settings: nil, onStateChanged: { (state : SSDKResponseState, user : SSDKUser!, error : NSError!) -> Void in
//            
//            switch state{
//                
//            case SSDKResponseState.Success: print("授权成功,用户信息为\(user)\n ----- 授权凭证为\(user.credential)")
////                login(openId: Int)
//            self.login(Int(user.uid!)!, type: 3)
//            let account = UserAccount(user: user, type: 3)
//            
//                sharedUserAccount = account
//                sharedUserAccount?.saveAccount()
//                self.logined = true
//                self.refresh()
//                
//            case SSDKResponseState.Fail:    print("授权失败,错误描述:\(error)")
//            case SSDKResponseState.Cancel:  print("操作取消")
//                
//            default:
//                break
//            }
//        })        
//    }
    
    // MARK: 告诉后台用户已登陆
    private func login(openId: Int, type: Int) {
        UserLoghtRequest(openId: openId, type: type).fetchLoginModels()
    }
        
}
    
    

