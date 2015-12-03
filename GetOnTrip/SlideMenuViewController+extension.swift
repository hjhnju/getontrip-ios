//
//  SlideMenuViewController+extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/2.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

extension SlideMenuViewController {
    
    func tapGestureHandler(sender: UITapGestureRecognizer){
        if sender.state == .Ended {
            toggle()
        }
    }
    
    //左右滑动效果
    func panGestureHandler(sender: UIPanGestureRecognizer) {
        //用户对视图操控的状态。
        let state    = sender.state;
        let location = sender.locationInView(self.mainNavViewController.view)
        var frame    = self.mainNavViewController.view.frame
        
        var startX:CGFloat = 0.0
        switch (state) {
        case UIGestureRecognizerState.Began:
            //记录用户开始点击的位置
            self.panGestureStartLocation = location;
            startX = frame.origin.x
            break;
        case UIGestureRecognizerState.Changed:
            //相比起点Began的x轴距离(每次.Changed调用是累计的
            let xOffSet = sender.translationInView(self.view).x
            //右滑动
            if (xOffSet > 0 && xOffSet < SlideMenuOptions.DrawerWidth){
                if (self.slideMenuState == SlideMenuState.Closing){
                    frame.origin.x = xOffSet + startX
                }
                //左滑动
            }else if (xOffSet < 0 && xOffSet > -SlideMenuOptions.DrawerWidth){
                if (self.slideMenuState == SlideMenuState.Opening){
                    frame.origin.x = xOffSet + SlideMenuOptions.DrawerWidth
                }
            }
            self.mainNavViewController.view.frame = frame;
            //alpha=[0.5 ~ 1.0]
            self.menuAlpha = min(0.5 + frame.origin.x / SlideMenuOptions.DrawerWidth, 1.0)
            break;
        case UIGestureRecognizerState.Ended:
            let xOffSet = sender.translationInView(self.view).x
            //超过阀值需要自动
            if abs(xOffSet) > SlideMenuOptions.AutoSlideXOffSet {
                if xOffSet < 0 && slideMenuState == SlideMenuState.Opening {
                    self.didClose()
                }else if xOffSet > 0 && slideMenuState == SlideMenuState.Closing {
                    self.didOpen()
                }
            } else {
                self.reset()
            }
            break;
        default:
            break;
        }
    }
    
    //打开侧边栏
    func didOpen(){
        //设置主窗体的结束位置
        var mainSize = self.mainNavViewController.view.frame
        mainSize.origin.x = SlideMenuOptions.DrawerWidth
        menuAlpha = max(0.5, menuAlpha)
        //动效
        UIView.animateWithDuration(0.7,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations:{ self.mainNavViewController.view.frame = mainSize;
                self.menuAlpha = 1.0 },
            completion: { (finished: Bool) -> Void in
                self.menuAlpha = 1.0
            }
        )
        
        //将侧边栏的装填标记为打开状态
        self.slideMenuState = SlideMenuState.Opening
        
        refreshMask()
    }
    
    //关闭侧边栏
    func didClose(){
        //点击关闭时要将当前状态标记为关闭
        if slideMenuState == SlideMenuState.Opening {
            slideMenuState = SlideMenuState.Closing
        }
        //将主窗体的起始位置恢复到原始状态
        var mainSize = self.mainNavViewController.view.frame
        mainSize.origin.x = 0
        menuAlpha = min(1.0, menuAlpha)
        UIView.animateWithDuration(0.7,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: { self.mainNavViewController.view.frame = mainSize;
                self.menuAlpha = 0.5 },
            completion: { (finished: Bool) -> Void in
                //偶尔右滑到底时被执行！why
                //self.menuAlpha = 0.0
            }
        )
        
        refreshMask()
    }
    
    // MARK: SlideMenuViewControllerDelegate
    
    func toggle() {
        if self.slideMenuState == SlideMenuState.Opening {
            self.didClose()
        } else {
            self.didOpen()
        }
    }
    
    func reset(){
        if self.slideMenuState == SlideMenuState.Opening {
            self.didOpen()
        } else {
            self.didClose()
        }
    }
    
    // MARK: 支持第三方登录
    //微信登陆
    func wechatLogin() {
        UserLogin.sharedInstance.thirdLogin(LoginType.Weixin, finishHandler: self.loginFinishedHandler){ (_) -> Void in
        }
        
    }
    
    //qq登陆
    func qqLogin() {
        UserLogin.sharedInstance.thirdLogin(LoginType.QQ, finishHandler: self.loginFinishedHandler){ (_) -> Void in
        }
    }
    
    // 更多登陆方式
    func moreLogin() {
        definesPresentationContext = true
        navigationController
        let lovc = LoginViewController()
        let nav = UINavigationController(rootViewController: lovc)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    //侧滑菜单动画效果
    /*var cellx: CGFloat = 0
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
    cellx += 150
    cell.transform = CGAffineTransformMakeTranslation(cellx, 0)
    UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 3, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
    cell.transform = CGAffineTransformIdentity
    }, completion: nil)
    }*/
    
    // MARK: - 地理定位代理方法
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        locationManager.stopUpdatingLocation()
//        
//        // 获取位置信息
//        let coordinate = locations.first?.coordinate
//        // 反地理编码
////        let geocoder = CLGeocoder()
////        let location = CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
//        
//        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) -> Void in
//            if let locality = placemarks?.first?.locality {
//                let firstPlacemark: NSString = NSString(string: " 当前城市\(locality)")
//                self?.city = firstPlacemark.substringToIndex(firstPlacemark.length - 1)
//                
//                struct Static {
//                    static var onceToken: dispatch_once_t = 0
//                }
//                dispatch_once(&Static.onceToken, {
//                    LocateToCity.locate(locality, handler: { (result, status) -> Void in
//                        if status == RetCode.SUCCESS {
//                            currentCityId = result as? String ?? ""
//                        } else {
//                            let hud = JGProgressHUD(style: JGProgressHUDStyle.Dark)
//                            hud.textLabel.text = "网络连接失败，请检查网络"
//                            hud.showInView(self?.view)
//                            hud.dismissAfterDelay(3.0)
//                        }
//                    })
//                })
//            }
//        }
//    }

}