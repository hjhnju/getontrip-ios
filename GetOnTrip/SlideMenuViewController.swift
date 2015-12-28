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
import JGProgressHUD

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
    //menu
    static let MenuTableViewCellID = "MenuTableViewCellID"
}

protocol SlideMenuViewControllerDelegate {
    //打开或关闭
    func toggle() -> Void
    //恢复
    func reset() -> Void
}

let UserInfoChangeNotification = "UserInfoChangeNotification"

class SlideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SlideMenuViewControllerDelegate {
    
    // MARK: Properties and Views
    
    //当前选择的主窗体对象
    var curVCType: AnyClass! {
        didSet {
            if curVCType != oldValue {
                if let vcType =  curVCType as? UIViewController.Type {
                    let vc = vcType.init()
                    mainViewController = vc as! MainViewController
                }
            }
            //关闭侧边栏
            didClose()
        }
    }
    
    //主窗体Controller
    var mainViewController: MainViewController! {
        didSet{
            mainNavViewController.setViewControllers([mainViewController], animated: false)
            
            //初始化蒙板
            maskView = UIView(color: UIColor.blackColor(), alphaF: 0.1)
            mainViewController.view.addSubview(maskView)
            mainViewController.view.bringSubviewToFront(maskView)
            maskView.frame = mainViewController.view.bounds
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapGestureHandler:")
            maskView.addGestureRecognizer(tapGestureRecognizer)
            
            if mainViewController.isKindOfClass(NSClassFromString("GetOnTrip.FavoriteViewController")!) {
                let vc = mainViewController as! FavoriteViewController
                vc.slideView.addGestureRecognizer(tapGestureRecognizer)
            }
            
            if globalUser != nil {                
                if mainViewController.isKindOfClass(NSClassFromString("GetOnTrip.MessageViewController")!) {
                    let vc = mainViewController as! MessageViewController
                    panGestureRecognizer.delegate = vc
                    panGestureRecognizer2.delegate = vc
                }
            }
            
            mainViewController.view.addGestureRecognizer(panGestureRecognizer)
            mainViewController.slideDelegate = self
            refreshMask()
        }
    }
    
    //带导航的主窗体
    lazy var mainNavViewController: UINavigationController = UINavigationController()
    
    //主窗体的遮罩层
    var maskView: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.1)
    
    //左侧菜单
    var menuView: UIView = UIView()
    
    //菜单底图图片
    lazy var bgImageView: UIImageView = UIImageView(image: UIImage(named: "menu_bg")!)
    
    //菜单侧边列表项
    lazy var tableView: UITableView = {
        let tab = UITableView()
        tab.backgroundColor = UIColor.clearColor()
        return tab
        }()
    
    //登录后，底view
    lazy var loginAfter: UIView = UIView()
    
    //登录前，底view
    lazy var loginBefore: UIView = UIView()
    
    //欢迎
    lazy var welcomeLabel = UILabel(color: UIColor.whiteColor(), fontSize: 36, mutiLines: true)
    //说明
    lazy var descLabel    = UILabel(color: UIColor.whiteColor(), fontSize: 12, mutiLines: true)
    //登录后，头像
    lazy var headerView: UIImageView = UIImageView(image: PlaceholderImage.defaultUser)
    //登录后，名称
    lazy var nameLabel: UILabel = UILabel(color: UIColor.whiteColor(), fontSize: 24, mutiLines: true)
    
    /// 微信
    lazy var wechatButton: UIButton = UIButton(icon: "icon_weixin", masksToBounds: true)
    /// QQ
    lazy var qqButton: UIButton = UIButton(icon: "icon_qq", masksToBounds: true)
    /// 更多登录方式按钮
    lazy var moreButton: UIButton = UIButton(icon: "more_white", masksToBounds: true)
    
    //设置菜单的数据源
    let tableViewDataSource = ["首页", CityBrowseViewController.name, SettingDatumViewController.name, MessageViewController.name] // FeedBackViewController.name
    
    //菜单对应元类
    let usingVCTypes: [AnyClass] = [RecommendViewController.self, CityBrowseViewController.self, SettingDatumViewController.self, MessageViewController.self]
    
    //定义当前侧边栏的状态
    var slideMenuState: SlideMenuState = SlideMenuState.Closing
    
    //登录状态
    var logined: Bool = true
    
    lazy var settingButton: SettingButton = SettingButton(image: "setting_slideMenu", title: "", fontSize: 0)
    
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
    
    // MARK: - 初始化方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //default
        curVCType = self.usingVCTypes[0]
        
        setupInit()
        setupAutoLayout()
        refreshLoginStatus()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userInfoDidChangeNotification:", name: UserInfoChangeNotification, object: nil)
        
        isInstallLoginClientSide()
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
        menuView.addSubview(settingButton)
        //初始菜单
        view.addSubview(menuView)
        
        //初始化主窗体
        addChildViewController(mainNavViewController)
        view.addSubview(mainNavViewController.view)
        
        //菜单subviews
        bgImageView.contentMode = .ScaleToFill
        
        loginAfter.addSubview(headerView)
        loginAfter.addSubview(nameLabel)
        loginBefore.addSubview(wechatButton)
        loginBefore.addSubview(qqButton)
        loginBefore.addSubview(moreButton)
        loginBefore.addSubview(welcomeLabel)
        loginBefore.addSubview(descLabel)
        
        welcomeLabel.text = "Hello!"
        if #available(iOS 9.0, *) {
            welcomeLabel.font = UIFont(name: Font.defaultFont, size: 36)
        } else {
            // Fallback on earlier versions
        }

        descLabel.text   = "登录/注册"
        wechatButton.addTarget(self, action: "wechatLogin", forControlEvents: .TouchUpInside)
        moreButton.addTarget(self, action: "moreLogin", forControlEvents: .TouchUpInside)
        qqButton.addTarget(self, action: "qqLogin", forControlEvents: .TouchUpInside)
        settingButton.addTarget(self, action: "settingAction:", forControlEvents: .TouchUpInside)
        
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.rowHeight = view.bounds.height * 0.5 * 0.2
        tableView.registerClass(MenuSettingTableViewCell.self, forCellReuseIdentifier: SlideMenuOptions.MenuTableViewCellID)
        tableView.separatorStyle = .None
        tableView.scrollEnabled = false
        
        //添加手势
        menuView.addGestureRecognizer(panGestureRecognizer2)
        
    }
    
    private func isInstallLoginClientSide() {
        
        let wechaInstall = Device.isWeixinInstalled()
        let qqInstall    = Device.isQQInstalled()
        
        if wechaInstall && qqInstall {
            qqButton.ff_AlignInner(.BottomCenter, referView: loginBefore, size: CGSizeMake(42, 40), offset: CGPointMake(0, 0))
            wechatButton.ff_AlignHorizontal(.CenterLeft, referView: qqButton, size: CGSizeMake(42, 40), offset: CGPointMake(-40,0))
            moreButton.ff_AlignHorizontal(.CenterRight, referView: qqButton, size: CGSizeMake(42, 40), offset: CGPointMake(40,0))
        } else if !wechaInstall && !qqInstall {
            moreButton.ff_AlignInner(.BottomCenter, referView: loginBefore, size: CGSizeMake(42, 42), offset: CGPointMake(0, 0))
            wechatButton.hidden = true
            qqButton.hidden = true
        } else if !wechaInstall {
            qqButton.ff_AlignInner(.BottomCenter, referView: loginBefore, size: CGSizeMake(42, 40), offset: CGPointMake(-40, 0))
            moreButton.ff_AlignInner(.BottomCenter, referView: loginBefore, size: CGSizeMake(42, 40), offset: CGPointMake(40, 0))
            wechatButton.hidden = true
        } else if !qqInstall {
            wechatButton.ff_AlignInner(.BottomCenter, referView: loginBefore, size: CGSizeMake(42, 40), offset: CGPointMake(-40, 0))
            moreButton.ff_AlignInner(.BottomCenter, referView: loginBefore, size: CGSizeMake(42, 40), offset: CGPointMake(40, 0))
            qqButton.hidden = true
        }
    }
    
    func refreshMask() {
        let masked = self.slideMenuState == SlideMenuState.Opening ? true : false
        maskView.hidden = !masked
    }
    
    //初始化自动布局
    private func setupAutoLayout() {
        //menu
        menuView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(SlideMenuOptions.DrawerWidth, view.bounds.height - 20), offset: CGPointMake(0, 20))
        bgImageView.ff_Fill(menuView)
        tableView.ff_AlignInner(.CenterCenter, referView: menuView, size: CGSizeMake(SlideMenuOptions.DrawerWidth, view.bounds.height * 0.5), offset: CGPointMake(0, 50))
        settingButton.ff_AlignInner(.BottomLeft, referView: menuView, size: CGSizeMake(34, 39), offset: CGPointMake(0, 0))
        
        loginAfter.ff_AlignInner(.TopCenter, referView: menuView, size: CGSizeMake(bgImageView.bounds.width * 0.6, view.bounds.height * 0.2), offset: CGPointMake(0, 54))
        headerView.ff_AlignInner(.TopCenter, referView: loginAfter, size: CGSizeMake(60, 60), offset: CGPointMake(0, 0))
        nameLabel.ff_AlignVertical(.BottomCenter, referView: headerView, size: nil, offset: CGPointMake(0, 8))
        
        if UIScreen.mainScreen().bounds.width == 320 {
            loginBefore.ff_AlignInner(.TopCenter, referView: menuView, size: CGSizeMake(SlideMenuOptions.DrawerWidth, view.bounds.height * 0.2 + 10), offset: CGPointMake(0, 34))
        } else {
            loginBefore.ff_AlignInner(.TopCenter, referView: menuView, size: CGSizeMake(SlideMenuOptions.DrawerWidth, view.bounds.height * 0.17), offset: CGPointMake(0, 54))
        }
        
        welcomeLabel.ff_AlignInner(.TopCenter, referView: loginBefore, size: nil, offset: CGPointMake(0, 0))
        descLabel.ff_AlignInner(.CenterCenter, referView: loginBefore, size: nil, offset: CGPointMake(0, -5))
        //main
        maskView.ff_Fill(mainViewController.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.layer.cornerRadius = min(headerView.bounds.width, headerView.bounds.height) * 0.5
        headerView.clipsToBounds = true
    }
    
    //MARK: - 刷新登录状态
    func refreshLoginStatus() {
        if let user = globalUser {
            loginAfter.hidden = false
            loginBefore.hidden = true
            if user.icon == "" {
                headerView.image = PlaceholderImage.defaultUser
            } else {
                headerView.sd_setImageWithURL(NSURL(string: user.icon))
            }
            nameLabel.text = user.nickname
            if mainViewController.isKindOfClass(NSClassFromString("GetOnTrip.SettingDatumViewController")!) {
                let vc = mainViewController as! SettingDatumViewController
                vc.isLoginStatus = true
            }
            
            if let vc = mainViewController as? OtherSettingController {
                vc.refreshLoginStatus()
            }
        } else {
            loginBefore.hidden = false
            loginAfter.hidden = true
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UserInfoChangeNotification, object: nil)
    }
    
    
    func userInfoDidChangeNotification(notification: NSNotification) {
        refreshLoginStatus()
    }
        
    // MARK: 自定义方法
    //用户touch的点位置
    var panGestureStartLocation : CGPoint!
    
    var menuAlpha:CGFloat = 0.0 {
        didSet{
            menuView.alpha = menuAlpha
        }
    }
    
    
    /// 登录后的操作
    var loginFinishedHandler: UserLogin.LoginFinishedHandler = { (result, error) -> Void in
        if error != nil {
            let hud = JGProgressHUD(style: JGProgressHUDStyle.Dark)
            hud.textLabel.text = "登录失败啦，再试试手气"
            hud.showInView(UIApplication.sharedApplication().keyWindow)
            hud.dismissAfterDelay(3.0)
        }
    }
    
    func tapGestureHandler(sender: UITapGestureRecognizer){
        if sender.state == .Ended {
            toggle()
        }
    }
    
    // MARK: 支持第三方登录
    //微信登录
    func wechatLogin() {
        UserLogin.sharedInstance.thirdLogin(LoginType.Weixin, finishHandler: loginFinishedHandler){ (_) -> Void in
        }
        
    }
    
    //qq登录
    func qqLogin() {
        UserLogin.sharedInstance.thirdLogin(LoginType.QQ, finishHandler: loginFinishedHandler){ (_) -> Void in
        }
    }
    
    // 更多登录方式
    func moreLogin() {
        definesPresentationContext = true
        navigationController
        let lovc = LoginViewController()
        let nav = UINavigationController(rootViewController: lovc)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    /// 设置方法
    func settingAction(sender: UIButton) {
        curVCType = OtherSettingController.self
    }
}
