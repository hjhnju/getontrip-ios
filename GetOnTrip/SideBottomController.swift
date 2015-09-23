//
//  SideBottomController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import CoreLocation

class SideBottomController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - 属性
    /// 定义窗体主体Controller
    lazy var masterViewController: UIViewController  = SearchListPageController()
    
    /// 定义侧边栏
    lazy var tableView: UITableView = {
        let tab = UITableView()
        tab.backgroundColor = UIColor.clearColor()
        return tab
    }()
    
    /// 底图图片
    lazy var imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "menu-bg")!)
        return image
    }()
    
    /// 登陆前，底view
    lazy var loginAge: UIView = UIView()
    
    /// 欢迎
    lazy var welcome = UILabel(color: UIColor.whiteColor(), fontSize: 36, mutiLines: true)
    
    /// 说明
    lazy var state = UILabel(color: UIColor.whiteColor(), fontSize: 12, mutiLines: true)
    
    /// 登陆后，底view
    lazy var loginAfter: UIView = {
        let loginAfter = UIView()
        return loginAfter
    }()
    
    /// 登陆后，头像
    lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        return iconView
    }()
    
    /// 登陆后，名称
    lazy var name: UILabel = UILabel(color: UIColor.whiteColor(), fontSize: 24, mutiLines: true)
    
    /// 微信
    lazy var wechatButton: UIButton = UIButton(icon: "weixin_picture")
    /// qq
    lazy var qqButton: UIButton = UIButton(icon: "qq_picture")
    
    /// 微博
    lazy var weiboButton: UIButton = UIButton(icon: "xinlang")
    
    /// 设置菜单的数据源
    let tableViewDataSource = ["切换城市", "我的收藏", "消息", "设置", "反馈"]
    
    /// 位置管理器
    lazy var locationManager: CLLocationManager = CLLocationManager()
    
    /// 地理位置
    var city: String?
    
    /// 主窗口控制器
    var mainEntranceController: UINavigationController?
    // (搜索入口一)
    lazy var searchListPageController: UINavigationController = UINavigationController(rootViewController: SearchListPageController())
    
    /// 城市中间页(入品二)
    lazy var cityCenterPageController: UINavigationController = UINavigationController(rootViewController: CityCenterPageController())
    
    // MARK: - 初始化方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 应用程序使用期间允许定位
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        setupInit()
        setupAutoLayout()
        refreshLoginStatus()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: 加载这里是错误的，临时使用
        setupSideController()
        print(city)
    }
    
    /// 初始化相关设置
    private func setupInit() {
        view.addSubview(imageView)
        view.addSubview(tableView)
        view.addSubview(loginAfter)
        view.addSubview(loginAge)
        loginAfter.addSubview(iconView)
        loginAfter.addSubview(name)
        loginAge.addSubview(wechatButton)
        loginAge.addSubview(qqButton)
        loginAge.addSubview(weiboButton)
        loginAge.addSubview(welcome)
        loginAge.addSubview(state)
        welcome.text = "hello!"
        state.text   = "使用以下账号直接登录"
        
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.hidden = true
        tableView.rowHeight = view.bounds.height * 0.5 * 0.2
        tableView.registerClass(MenuSettingTableViewCell.self, forCellReuseIdentifier: "MenuTableView_Cell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    /// 初始化自动布局
    private func setupAutoLayout() {
        imageView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(UIScreen.mainScreen().bounds.width * 0.75, view.bounds.height - 20), offset: CGPointMake(0, 20))
        tableView.ff_AlignInner(ff_AlignType.CenterCenter, referView: imageView, size: CGSizeMake(UIScreen.mainScreen().bounds.width * 0.75, view.bounds.height * 0.5), offset: CGPointMake(0, 50))
        loginAfter.ff_AlignInner(ff_AlignType.TopCenter, referView: imageView, size: CGSizeMake(imageView.bounds.width * 0.6, view.bounds.height * 0.2), offset: CGPointMake(0, 54))
        loginAge.ff_AlignInner(ff_AlignType.TopCenter, referView: imageView, size: CGSizeMake(imageView.bounds.width * 0.6, view.bounds.height * 0.17), offset: CGPointMake(0, 54))
        iconView.ff_AlignInner(ff_AlignType.TopCenter, referView: loginAfter, size: CGSizeMake(60, 60), offset: CGPointMake(0, 0))
        name.ff_AlignVertical(ff_AlignType.BottomCenter, referView: iconView, size: nil, offset: CGPointMake(0, 8))
        wechatButton.ff_AlignInner(ff_AlignType.BottomLeft, referView: loginAge, size: CGSizeMake(40, 40), offset: CGPointMake(0, 0))
        qqButton.ff_AlignInner(ff_AlignType.BottomCenter, referView: loginAge, size: CGSizeMake(40, 40), offset: CGPointMake(0, 0))
        weiboButton.ff_AlignInner(ff_AlignType.BottomRight, referView: loginAge, size: CGSizeMake(40, 40), offset: CGPointMake(0, 0))
        welcome.ff_AlignInner(ff_AlignType.TopCenter, referView: loginAge, size: nil, offset: CGPointMake(0, 0))
        state.ff_AlignVertical(ff_AlignType.BottomCenter, referView: welcome, size: nil, offset: CGPointMake(0, 8))
    }
    
    /// 初始侧面控制器
    private func setupSideController() {
        
        mainEntranceController = city != nil ? cityCenterPageController : searchListPageController
        addChildViewController(mainEntranceController!)
        view.addSubview(mainEntranceController!.view)
    }
    
    /// 设置行高并刷新
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        iconView.layer.cornerRadius = min(iconView.bounds.width, iconView.bounds.height) * 0.5
        iconView.clipsToBounds = true
    }
    
    /// 电池栏状态
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    /// MARK: - 刷新登陆状态
    func refreshLoginStatus() {
        if sharedUserAccount != nil {
            loginAfter.hidden = false
            loginAge.hidden = true
            iconView.sd_setImageWithURL(NSURL(string: (sharedUserAccount?.icon)!), placeholderImage: UIImage(named: placeholderImage.userIcon))
            name.text = sharedUserAccount?.nickname
        } else {
            loginAge.hidden = false
            loginAfter.hidden = true
        }
    }
    
    // MARK: - tableView数据源方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableViewDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuTableView_Cell", forIndexPath: indexPath) as! MenuSettingTableViewCell
        cell.titleLabel.text = tableViewDataSource[indexPath.row]
        // 添加tableview顶上的线
        if indexPath.row == 0 {
            let baselineView = UIView(color: UIColor(white: 0xFFFFFF, alpha: 1), alphaF: 0.3)
            cell.addSubview(baselineView)
            baselineView.ff_AlignInner(ff_AlignType.TopLeft, referView: cell, size: CGSizeMake(cell.bounds.width, 0.5), offset: CGPointMake(0, 0))
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let close = mainEntranceController?.visibleViewController as! BaseHomeController
        close.openAndCloseView()
        
        /// MARK: 跳转切换城市页面
        if indexPath.row == 0 {
            let switchCityVC = SwitchCityViewController()
            
            
            
            
            mainEntranceController?.pushViewController(switchCityVC, animated: true)
        }
        
        
        
//        let vc = UIViewController()
//        vc.view.backgroundColor = UIColor.orangeColor()
//        vc.view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
//        mainEntranceController?.pushViewController(vc, animated: true)
        
        
        
        
        
        
        
        
        
    }
    
    /// 侧滑菜单动画效果
    var cellx: CGFloat = 0
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cellx += 150
        cell.transform = CGAffineTransformMakeTranslation(cellx, 0)
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 3, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
            cell.transform = CGAffineTransformIdentity
        }, completion: nil)
    }
    
    // MARK: - 地理定位代理方法
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("开始定位，就定了一次")
        locationManager.stopUpdatingLocation()
        // 获取位置信息
        let coordinate = locations.first?.coordinate
        
        // 反地理编码
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude)

        geocoder.reverseGeocodeLocation(location) { [unowned self] (placemarks, error) -> Void in

            if (placemarks?.count == 0 || error != nil) {
                print("地理信息没找到")
                return
            } else {
                let firstPlacemark: NSString = NSString(string: "\(placemarks!.first!.locality!)")
                self.city = firstPlacemark.substringToIndex(firstPlacemark.length - 1)
                
                struct Static {
                    static var onceToken: dispatch_once_t = 0
                }
                
                // TODO: 地理位置 是异步加载的，在获取到地理位置之前应该先显示什么
//                dispatch_once(&Static.onceToken, { [unowned self] in
//                    self.setupSideController()
//                })
            }
        }
    
    }
    
}

// MARK: - 菜单 tableViewCell
class MenuSettingTableViewCell : UITableViewCell {
    
    lazy var titleLabel: UILabel = UILabel(color: UIColor.whiteColor(), fontSize: 16, mutiLines: true)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(baseline)
        addSubview(titleLabel)
        
        backgroundColor = UIColor.clearColor()
        baseline.ff_AlignInner(ff_AlignType.BottomLeft, referView: self, size: CGSizeMake(bounds.width, 0.5), offset: CGPointMake(0, 0))
        titleLabel.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置底线
    lazy var baseline: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(white: 0xFFFFFF, alpha: 0.3)
        return baselineView
    }()
}
