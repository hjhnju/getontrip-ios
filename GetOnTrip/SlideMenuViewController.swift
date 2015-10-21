//
//  菜单控制器
//  MenuViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import CoreLocation

//定义侧边栏的两种状态（打开，关闭）枚举类型
enum SlideMenuState: Int {
    case Opening = 1
    case Closing
    mutating func toggle() {
        switch self {
        case .Closing:
            self = .Opening
        case .Opening:
            self = .Closing
        }
    }
}

struct SlideMenuOptions {
    //拉伸的宽度
    static let DrawerWidth: CGFloat = UIScreen.mainScreen().bounds.width * 0.75
    //高度
    static let DrawerHeight: CGFloat = UIScreen.mainScreen().bounds.height
    //超过该滑动阀值开始自动展开/关闭菜单
    static var AutoSlideXOffSet : CGFloat  = 60.0
}

protocol SlideMenuViewControllerDelegate {
    //打开或关闭
    func toggle() -> Void
    
    //恢复
    func reset() -> Void
}

let UserInfoChangeNotification = "UserInfoChangeNotification"

class SlideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, SlideMenuViewControllerDelegate {
    
    // MARK: Properties and Views    
    
    //主窗体Controller
    var mainViewController: MainViewController = SearchRecommendViewController()
    
    //带导航的主窗体
    lazy var mainNavViewController: UINavigationController = { [unowned self] in
        return UINavigationController(rootViewController: self.mainViewController)
    }()
    
    //主窗体的遮罩层
    var maskView: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.5)
    
    //左侧菜单
    var menuView: UIView = UIView()
    
    //菜单底图图片
    lazy var bgImageView: UIImageView = UIImageView(image: UIImage(named: "menu-bg")!)
    
    //菜单底图模糊
    lazy var blurView: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        return blur
        }()
    
    //菜单侧边列表项
    lazy var tableView: UITableView = {
        let tab = UITableView()
        tab.backgroundColor = UIColor.clearColor()
        return tab
        }()
    
    //登陆后，底view
    lazy var loginAfter: UIView = UIView()
    
    //登陆前，底view
    lazy var loginBefore: UIView = UIView()
    
    //欢迎
    lazy var welcomeLabel = UILabel(color: UIColor.whiteColor(), fontSize: 36, mutiLines: true)
    //说明
    lazy var descLabel    = UILabel(color: UIColor.whiteColor(), fontSize: 12, mutiLines: true)
    //登陆后，头像
    lazy var headerView: UIImageView = UIImageView()
    //登陆后，名称
    lazy var nameLabel: UILabel = UILabel(color: UIColor.whiteColor(), fontSize: 24, mutiLines: true)
    
    //微信
    lazy var wechatButton: UIButton = UIButton(icon: "icon_weixin", masksToBounds: true)
    //QQ
    lazy var qqButton: UIButton = UIButton(icon: "icon_qq", masksToBounds: true)
    //微博
    lazy var weiboButton: UIButton = UIButton(icon: "icon_weibo", masksToBounds: true)
    
    //当前城市
    lazy var currentCityButton: UIButton = UIButton(image: "icon_locate", title: "当前城市未知", fontSize: 10)
//    var currentCityButton = UIButton()
    
    //设置菜单的数据源
    let tableViewDataSource = ["切换城市", "我的收藏", "消息", "设置", "反馈"]
    
    //定义当前侧边栏的状态
    var slideMenuState: SlideMenuState = SlideMenuState.Closing
    
    //地理位置
    var city: String?
    
    //登陆状态
    var logined: Bool = true
    
    //主窗体遮罩层点击手势
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    //滑动手势
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action:"panGestureHandler:")
        return pan
    }()
    
    lazy var panGestureRecognizer2: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action:"panGestureHandler:")
        return pan
        }()
    
    //位置管理器
    lazy var locationManager: CLLocationManager = CLLocationManager()
    
    // MARK: - 初始化方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 应用程序使用期间允许定位
        /*
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()*/
        
        setupInit()
        setupAutoLayout()
        refreshLoginStatus()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userInfoDidChangeNotification:", name: UserInfoChangeNotification, object: nil)
    }
    
    //电池栏状态
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //初始化相关设置
    private func setupInit() {
        menuView.addSubview(bgImageView)
        menuView.sendSubviewToBack(bgImageView)
        menuView.addSubview(tableView)
        menuView.addSubview(loginAfter)
        menuView.addSubview(loginBefore)
        menuView.addSubview(currentCityButton)
        
        //初始菜单
        view.addSubview(menuView)
        
        //初始化主窗体
        mainViewController.slideDelegate = self
        addChildViewController(mainNavViewController)
        view.addSubview(mainNavViewController.view)
        
        //菜单subviews
        bgImageView.addSubview(blurView)
        bgImageView.bringSubviewToFront(blurView)
        
        loginAfter.addSubview(headerView)
        loginAfter.addSubview(nameLabel)
        
        loginBefore.addSubview(wechatButton)
        loginBefore.addSubview(qqButton)
        loginBefore.addSubview(weiboButton)
        loginBefore.addSubview(welcomeLabel)
        loginBefore.addSubview(descLabel)
        
        welcomeLabel.text = "Hello!"
        descLabel.text   = "使用以下账号直接登录"
        currentCityButton.alpha = 0.7
        
        wechatButton.addTarget(self, action: "wechatLogin", forControlEvents: UIControlEvents.TouchUpInside)
        weiboButton.addTarget(self, action: "weiboLogin", forControlEvents: UIControlEvents.TouchUpInside)
        qqButton.addTarget(self, action: "qqLogin", forControlEvents: UIControlEvents.TouchUpInside)
        
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.rowHeight = view.bounds.height * 0.5 * 0.2
        tableView.registerClass(MenuSettingTableViewCell.self, forCellReuseIdentifier: StoryBoardIdentifier.MenuTableViewCellID)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.scrollEnabled = false
        
        //初始化蒙板
        mainNavViewController.view.addSubview(maskView)
        mainNavViewController.view.bringSubviewToFront(maskView)
        maskView.frame = mainNavViewController.view.bounds
        refreshMask()
        
        //添加手势
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapGestureHandler:")
        maskView.addGestureRecognizer(tapGestureRecognizer)
        mainViewController.view.addGestureRecognizer(panGestureRecognizer)
        menuView.addGestureRecognizer(panGestureRecognizer2)
    }
    
    func refreshMask() {
        let masked = self.slideMenuState == SlideMenuState.Opening ? true : false
        self.maskView.hidden = !masked
    }
    
    //初始化自动布局
    private func setupAutoLayout() {
        //menu
        menuView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(SlideMenuOptions.DrawerWidth, view.bounds.height - 20), offset: CGPointMake(0, 20))
        bgImageView.ff_Fill(menuView)
        blurView.ff_Fill(bgImageView)
        tableView.ff_AlignInner(ff_AlignType.CenterCenter, referView: menuView, size: CGSizeMake(SlideMenuOptions.DrawerWidth, view.bounds.height * 0.5), offset: CGPointMake(0, 50))
        loginAfter.ff_AlignInner(ff_AlignType.TopCenter, referView: menuView, size: CGSizeMake(bgImageView.bounds.width * 0.6, view.bounds.height * 0.2), offset: CGPointMake(0, 54))
        loginBefore.ff_AlignInner(ff_AlignType.TopCenter, referView: menuView, size: CGSizeMake(bgImageView.bounds.width * 0.6, view.bounds.height * 0.17), offset: CGPointMake(0, 54))
        headerView.ff_AlignInner(ff_AlignType.TopCenter, referView: loginAfter, size: CGSizeMake(60, 60), offset: CGPointMake(0, 0))
        nameLabel.ff_AlignVertical(ff_AlignType.BottomCenter, referView: headerView, size: nil, offset: CGPointMake(0, 8))
        wechatButton.ff_AlignInner(ff_AlignType.BottomLeft, referView: loginBefore, size: CGSizeMake(40, 40), offset: CGPointMake(0, 0))
        qqButton.ff_AlignInner(ff_AlignType.BottomCenter, referView: loginBefore, size: CGSizeMake(40, 40), offset: CGPointMake(0, 0))
        weiboButton.ff_AlignInner(ff_AlignType.BottomRight, referView: loginBefore, size: CGSizeMake(40, 40), offset: CGPointMake(0, 0))
        welcomeLabel.ff_AlignInner(ff_AlignType.TopCenter, referView: loginBefore, size: nil, offset: CGPointMake(0, 0))
        descLabel.ff_AlignVertical(ff_AlignType.BottomCenter, referView: welcomeLabel, size: nil, offset: CGPointMake(0, 8))
        currentCityButton.ff_AlignInner(ff_AlignType.BottomCenter, referView: menuView, size: nil, offset: CGPointMake(0, -21))
        
        //main
        maskView.ff_Fill(mainNavViewController.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.layer.cornerRadius = min(headerView.bounds.width, headerView.bounds.height) * 0.5
        headerView.clipsToBounds = true
    }
    
    //MARK: - 刷新登陆状态
    func refreshLoginStatus() {
        if sharedUserAccount != nil {
            loginAfter.hidden = false
            loginBefore.hidden = true
        } else {
            loginBefore.hidden = false
            loginAfter.hidden = true
        }
        if sharedUserAccount == nil { return }
        headerView.sd_setImageWithURL(NSURL(string: (sharedUserAccount?.icon)!), placeholderImage: UIImage(named: placeholderImage.userIcon))
        nameLabel.text = sharedUserAccount?.nickname
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UserInfoChangeNotification, object: nil)
    }
    
    
    func userInfoDidChangeNotification(notification: NSNotification) {
        refreshLoginStatus()
    }
    
    // MARK: tableView数据源方法
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableViewDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.MenuTableViewCellID, forIndexPath: indexPath) as! MenuSettingTableViewCell
        cell.titleLabel.text = tableViewDataSource[indexPath.row]
        
        // 添加tableview顶上的线
        /*if indexPath.row == 0 {
            let baselineView = UIView(color: UIColor(white: 0xFFFFFF, alpha: 1), alphaF: 0.3)
            cell.addSubview(baselineView)
            baselineView.ff_AlignInner(ff_AlignType.TopLeft, referView: cell, size: CGSizeMake(cell.bounds.width, 0.5), offset: CGPointMake(0, 0))
        }*/
        
        //最后一行无底部横线
        if indexPath.row == tableViewDataSource.count - 1 {
            cell.isBaseLineVisabled = false
        }
        
        return cell
    }
    
    //跳转控制器
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.didClose()
        
        if indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 {
            if sharedUserAccount == nil {
                let alertView = UIAlertView(title: nil, message: "亲，请先登陆，么么哒", delegate: self, cancelButtonTitle: "亲一个")
                alertView.show()
                return
            }
        }
        
        var VC: UIViewController?
        if indexPath.row == 0 {
            VC = SwitchCityViewController()
        } else if indexPath.row == 1 {
            VC = FavoriteViewController()
        } else if indexPath.row == 2 {
            VC = MessageViewController()
        } else if indexPath.row == 3 {
            VC = SettingViewController()
        } else  {
            VC = FeedBackViewController()
        }
        
        mainNavViewController.pushViewController(VC!, animated: true)
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
    /*
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NSLog("开始定位")
    
        locationManager.stopUpdatingLocation()

        // 获取位置信息
        let coordinate = locations.first?.coordinate
        // 反地理编码
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude)

        geocoder.reverseGeocodeLocation(location) { [unowned self] (placemarks, error) -> Void in
            if (placemarks?.count == 0 || error != nil) {
                NSLog("无地理位置信息")
                return
            } else {
                let firstPlacemark: NSString = NSString(string: "\(placemarks!.first!.locality!)")
                self.city = firstPlacemark.substringToIndex(firstPlacemark.length - 1)
                
                struct Static {
                    static var onceToken: dispatch_once_t = 0
                }
                
                //TODO: 地理位置 是异步加载的，在获取到地理位置之前应该先显示什么
                dispatch_once(&Static.onceToken, { [unowned self] in
                    self.setupSideController()
                    self.currentCity.setTitle("  当前在" + self.city!, forState: UIControlState.Normal)
                })
            }
        }
    }*/
    
    // MARK: 自定义方法
    
    func tapGestureHandler(sender: UITapGestureRecognizer){
        if sender.state == .Ended {
            toggle()
        }
    }
    
    //用户touch的点位置
    var panGestureStartLocation : CGPoint!
    
    //左右滑动效果
    func panGestureHandler(sender: UIPanGestureRecognizer){
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
        //动效
        UIView.animateWithDuration(0.7,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations:{ self.mainNavViewController.view.frame = mainSize; },
            completion: { (finished: Bool) -> Void in }
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
        UIView.animateWithDuration(0.7,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: { self.mainNavViewController.view.frame = mainSize; },
            completion: { (finished: Bool) -> Void in }
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
    
    // MARK: 第三方登陆
    
    //微信登陆
    func wechatLogin() {
         thirdParthLogin(SSDKPlatformType.TypeWechat)
    }
    
    //qq登陆
    func qqLogin() {
         thirdParthLogin(SSDKPlatformType.TypeQQ)
    }
    
    //新浪微博登陆
    func weiboLogin() {
         thirdParthLogin(SSDKPlatformType.TypeSinaWeibo)
    }
    
    //第三方登陆
        func thirdParthLogin(type: SSDKPlatformType) {
            //授权
            ShareSDK.authorize(type, settings: nil, onStateChanged: { [unowned self] (state : SSDKResponseState, user : SSDKUser!, error : NSError!) -> Void in
    
                switch state{
    
                case SSDKResponseState.Success: print("授权成功,用户信息为\(user)\n ----- 授权凭证为\(user.credential)")
                let account = UserAccount(user: user, type: 3)
//                sharedUserAccount = account
                self.refreshLoginStatus()
    
                case SSDKResponseState.Fail:    print("授权失败,错误描述:\(error)")
                case SSDKResponseState.Cancel:  print("操作取消")
    
                default:
                    break
                }
            })
        }
}

