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

class SlideMenuViewController: BaseViewController, UITableViewDataSource, CLLocationManagerDelegate, UITableViewDelegate, SlideMenuViewControllerDelegate {
    
    // MARK: Properties and Views
    
    //当前选择的主窗体对象
    var curVCType: AnyClass! {
        didSet {
            if curVCType != oldValue {
                if let vcType =  curVCType as? UIViewController.Type {
                    Statistics.shareStatistics.event(Event.home_click_menuViewController_eid)
                    mainViewController = vcType == RecommendViewController.self ?
                        RecommendViewController.sharedRecommendViewController   :
                        vcType.init() as! MainViewController
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
            mainViewController.view.addSubview(maskView)
            mainViewController.view.bringSubviewToFront(maskView)
            maskView.ff_Fill(mainViewController.view)
            
            //初始化蒙板
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapGestureHandler:")
            maskView.addGestureRecognizer(tapGestureRecognizer)
            
            if mainViewController.isKindOfClass(NSClassFromString("GetOnTrip.FavoriteViewController")!) {
                let vc = mainViewController as! FavoriteViewController
                vc.slideView.addGestureRecognizer(tapGestureRecognizer)
            }
            
            if mainViewController.isKindOfClass(NSClassFromString("GetOnTrip.RecommendViewController")!) {
                let vc = mainViewController as! RecommendViewController
                panGestureRecognizer.delegate = vc
                panGestureRecognizer2.delegate = vc
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
    
    //欢迎
    lazy var welcomeButton = UIButton(title: "Welcome", fontSize: 48, radius: 0, titleColor: SceneColor.thinGreen, fontName: Font.HelveticaNeueThin)
    //登录后，头像
    lazy var headerView: UIImageView = UIImageView(image: PlaceholderImage.defaultUser)
    //登录后，名称
    lazy var nameLabel: UILabel = UILabel(color: SceneColor.thinGreen, title: "途知", fontSize: 24, mutiLines: true, fontName: Font.PingFangTCThin)
    /// 设置按钮
    lazy var settingButton: SettingButton = SettingButton(image: "setting_slideMenu", title: "    设置", fontSize: 12)
    /// 点此登录
    lazy var loginPromptButton: UIButton = UIButton(title: "点此登录", fontSize: 12, radius: 0, titleColor: SceneColor.thinGreen, fontName: Font.PingFangSCLight)
    
    //设置菜单的数据源
    let tableViewDataSource = ["首页", CityBrowseViewController.name, SettingDatumViewController.name, MessageViewController.name, FeedBackViewController.name]
    
    //菜单对应元类
    let usingVCTypes: [AnyClass] = [RecommendViewController.self, CityBrowseViewController.self, SettingDatumViewController.self, MessageViewController.self, FeedBackViewController.self]
    
    //定义当前侧边栏的状态
    var slideMenuState: SlideMenuState = SlideMenuState.Closing
    
    //登录状态
    var logined: Bool = true
    
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
        
        //default
        curVCType = self.usingVCTypes[0]
        
        setupInit()
        setupAutoLayout()
        refreshLoginStatus()
        initLocationManager()
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
        menuView.addSubview(settingButton)
        menuView.addSubview(welcomeButton)
        menuView.addSubview(headerView)
        menuView.addSubview(nameLabel)
        menuView.addSubview(loginPromptButton)
        //初始菜单
        view.addSubview(menuView)
        
        //初始化主窗体
        addChildViewController(mainNavViewController)
        view.addSubview(mainNavViewController.view)
        
        //菜单subviews
        bgImageView.contentMode = .ScaleToFill
        welcomeButton.addTarget(self, action: "loginAction", forControlEvents: .TouchUpInside)
        loginPromptButton.addTarget(self, action: "loginAction", forControlEvents: .TouchUpInside)
        settingButton.addTarget(self, action: "settingAction:", forControlEvents: .TouchUpInside)
        
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.rowHeight = view.bounds.height * 0.4 * 0.2
        tableView.registerClass(MenuSettingTableViewCell.self, forCellReuseIdentifier: SlideMenuOptions.MenuTableViewCellID)
        tableView.separatorStyle = .None
        tableView.scrollEnabled = false
        
        //添加手势
        menuView.addGestureRecognizer(panGestureRecognizer2)
    }
    
    /// 初始化定位
    private func initLocationManager() {
        /// 应用程序使用期间允许定位
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        /// 开始定位
        locationManager.startUpdatingLocation()
        /// 移动1000米再次定位
        locationManager.distanceFilter = 1000
        /// 精准度100米
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
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
        tableView.ff_AlignInner(.CenterCenter, referView: menuView, size: CGSizeMake(SlideMenuOptions.DrawerWidth, view.bounds.height * 0.4), offset: CGPointMake(0, 0))
        
        // TODO: -在这里
        settingButton.ff_AlignInner(.BottomRight, referView: menuView, size: nil, offset: CGPointMake(-13, -16))
        welcomeButton.ff_AlignInner(.TopCenter, referView: menuView, size: nil, offset: CGPointMake(0, Frame.screen.width * 0.14))
        loginPromptButton.ff_AlignVertical(.BottomCenter, referView: welcomeButton, size: nil, offset: CGPointMake(0, -10))
        headerView.ff_AlignInner(.TopCenter, referView: menuView, size: CGSizeMake(93, 93), offset: CGPointMake(0, Frame.screen.width * 0.13))
        nameLabel.ff_AlignVertical(.BottomCenter, referView: headerView, size: nil, offset: CGPointMake(0, 5))
        
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
            welcomeButton.hidden = true
            loginPromptButton.hidden = true
            headerView.hidden = false
            nameLabel.hidden = false
            user.icon == "" ? headerView.image = PlaceholderImage.defaultUser : headerView.sd_setImageWithURL(NSURL(string: user.icon))
            nameLabel.text = user.nickname
            if mainViewController.isKindOfClass(NSClassFromString("GetOnTrip.SettingDatumViewController")!) {
                let vc = mainViewController as! SettingDatumViewController
                vc.isLoginStatus = true
            }
            (mainViewController as? OtherSettingController)?.refreshLoginStatus()
        } else {
            welcomeButton.hidden = false
            loginPromptButton.hidden = false
            headerView.hidden = true
            nameLabel.hidden = true
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
    
    // MARK: 登录
    func loginAction() {
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
    
    // MARK: - 定位代理
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error.code == 1 {
            ProgressHUD.showSuccessHUD(view, text: "您已拒绝定位，请到设置中打开定位")
            currentCityId = "-1"
        } else {
            currentCityId = "0"
        }
    }
    
    // MARK: - 地理定位代理方法
    var isLocationLoad: Bool = false
    var lastLocationX = ""
    var lastLocationY = ""
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 获取位置信息
        let coordinate = locations.first?.coordinate
        // 反地理编码
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
        LocateToCity.sharedLocateToCity.location = location
        if LocateToCity.sharedLocateToCity.y == "\(coordinate!.latitude)" && LocateToCity.sharedLocateToCity.x == "\(coordinate!.longitude)" {
            return
        }
        
        LocateToCity.sharedLocateToCity.x = "\(coordinate!.longitude)"
        LocateToCity.sharedLocateToCity.y = "\(coordinate!.latitude)"
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) -> Void in
            if let locality = placemarks?.first?.locality {
                if !self!.isLocationLoad {
                    self?.isLocationLoad = true
                    if self?.lastLocationX == "\(coordinate!.longitude)" && self?.lastLocationY == "\(coordinate!.latitude)" {
                        return
                    }
                    
                    LocateToCity.sharedLocateToCity.locate(locality, handler: { (result, status) -> Void in
                        self?.lastLocationX = "\(coordinate!.longitude)"
                        self?.lastLocationY = "\(coordinate!.latitude)"
                        self?.isLocationLoad = false
                        if status == RetCode.SUCCESS {
                            currentCityId = result ?? "-2"
                        } else {
                            ProgressHUD.showSuccessHUD(self?.view, text: "网络连接失败，请检查网络")
                        }
                    })
                }
            }
        }
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
