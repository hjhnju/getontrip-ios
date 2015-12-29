//
//  SearchListPageController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import Alamofire
import MJRefresh
import ReachabilitySwift

struct MainViewContant {
    //状态栏高度
    static let StatusBarHeight:CGFloat = 20
    //初始化导航栏高度
    static let MaxNavbarHeight:CGFloat = 74
    //导航栏最小高度
    static let MinNavbarHeight:CGFloat = 44
    //搜索栏高度
    static let SearchBarHeight:CGFloat = 34
}

struct RecommendContant {
    static let headerViewHeight:CGFloat = 255
    static let rowHeight:CGFloat = 192

    //search
    static let recommendTableViewCellID = "SearchRecommendTableViewCellID"
    static let recommendTopicViewCellID = "RecommendTopicViewCellID"
}

class RecommendViewController: MainViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
        
    //导航栏容器，包含状态栏的高度
    lazy var navContainerView:UIView = UIView()
    
    /// 侧滑导航按钮
    let slideNavButton: RecommendSlideButton = RecommendSlideButton(image: "icon_hamburger", title: "", fontSize: 0, titleColor: .whiteColor())
    
    //自定义导航栏
    lazy var custNavView:UIView = { [weak self] in
        let view = UIView()
        self?.slideButton.removeFromSuperview()
        self?.slideNavButton.addTarget(self, action: "toggleMenu", forControlEvents: .TouchUpInside)
        view.addSubview(self?.slideNavButton ?? UIView())
        return view
    }()
    
    //导航高度
    var navBarHeight:CGFloat = 0.0
    
    //导航透明度
    var navBarAlpha:CGFloat = 0.0 {
        didSet{
            refreshBar()
        }
    }
    
    /// 搜索顶部
    var headerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, RecommendContant.headerViewHeight))
    
    /// 搜索顶部图片
    var headerImageView: RoundImageView = RoundImageView(frame: CGRectMake(0, 0, Frame.screen.width, 211))
    /// 搜索顶部图片数据源
    var headerImagesData = [String]() {
        didSet {
            headerImageView.arrayImage = headerImagesData
        }
    }
    
    /// headerView的顶部约束
    var headerViewTopConstraint: NSLayoutConstraint?
    
    /// 热门景点和热门内容view
    lazy var titleSelectView: RecommendHotView = { [weak self] in
        let v = RecommendHotView()
//        self?.view.addSubview(v)
        v.hotContentButton.addTarget(self, action: "hotContentAndSightButtonAction:", forControlEvents: .TouchUpInside)
        v.hotSightButton.addTarget(self, action: "hotContentAndSightButtonAction:", forControlEvents: .TouchUpInside)
        return v
    }()
    
    /// 无网络提示view
    lazy var errorView: UIView = { [weak self] in
        let view = UIView()
        let refreshButton = UIButton(icon: "icon_refresh", masksToBounds: true)
        let refreshHint1   = UILabel(color: SceneColor.white.colorWithAlphaComponent(0.5), title: "网速好像不给力", fontSize: 13)
        let refreshHint2   = UILabel(color: SceneColor.white.colorWithAlphaComponent(0.5), title: "点击此处重新加载", fontSize: 13)
        view.frame = CGRectMake(0, RecommendContant.headerViewHeight, UIScreen.mainScreen().bounds.width, 123)
        view.addSubview(refreshButton)
        view.addSubview(refreshHint1)
        view.addSubview(refreshHint2)
        refreshButton.ff_AlignInner(.TopCenter, referView: view, size: CGSize(width: 26, height: 26), offset: CGPointMake(0, 30))
        refreshHint1.ff_AlignVertical(.BottomCenter, referView: refreshButton, size: nil, offset: CGPointMake(0, 12))
        refreshHint2.ff_AlignVertical(.BottomCenter, referView: refreshHint1, size: nil, offset: CGPointMake(0, 0))
        
        //add target
        refreshButton.addTarget(self, action: "refreshFromErrorView:", forControlEvents: UIControlEvents.TouchUpInside)
        self?.view.addSubview(view)
        self?.view.sendSubviewToBack(view)
        view.hidden = true
        return view
        }()
    
    /// 搜索控制器
    lazy var searchController: SearchViewController! = SearchViewController()
    
    /// 顶部搜索框提示
    var defaultPrompt: UIButton = UIButton(image: "search_icon", title: " 搜索城市、景点等内容", fontSize: 14, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.3), fontName: Font.defaultFont)
    
    /// 搜索栏
    var textfile: UITextField? {
        didSet {
            if #available(iOS 9.0, *) {
                textfile?.font = UIFont(name: Font.defaultFont, size: 16)
            } else {
                textfile?.font = UIFont(name: Font.ios8Font, size: 16)
            }
            textfile?.textColor = UIColor.whiteColor()
            textfile?.leftView = UIView(frame: CGRectMake(0, 0, 23, 35))
            textfile?.placeholder = " "
            textfile?.setValue(clearButton, forKey: "_clearButton")
            textfile?.addTarget(self, action: "defaultPromptTextHidden:", forControlEvents: UIControlEvents.EditingChanged)
            defaultPrompt.titleLabel?.hidden = true
            textfile?.addSubview(defaultPrompt)
            defaultPrompt.ff_AlignInner(.CenterLeft, referView: textfile ?? defaultPrompt, size: nil, offset: CGPointMake(11, 0))
        }
    }
    
    /// 网络请求加载数据(添加)
    var lastRequest: RecommendRequest = RecommendRequest()
    
    /// 热门内容推荐
    var hotContentVC = RecommendHotController()
    
    /// 热门景点推荐
    var hotSightVC = RecommendHotController()
    
    /// 数据源 - 推荐标签
    var recommendLabels: [RecommendLabel] = [RecommendLabel]() {
        didSet{
            hotContentVC.order = recommendLabels[0].order ?? "0"
            hotSightVC.order = recommendLabels[1].order ?? "1"
            
            collectionView.reloadData()
            hotContentVC.loadData()
            hotSightVC.loadData()
        }
    }
    
    /// 底部容器view
    lazy var collectionView: UICollectionView = { [weak self] in
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: self!.layout)
        cv.tag = 2
        return cv
    }()
    
    /// 左侧滑动view
    lazy var slideView: UIView = UIView()
        
    /// 流水布局
    lazy var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    // MARK: - 初始化
    //电池栏状态
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshReachable()
        initSearchBar()
        initCollectionLayout()
        initCollectionView()
        initViewSetting()
        setupAutoLayout()
        loadData()
        initController()
    }
    
    private func initController() {
        addChildViewController(hotContentVC)
        addChildViewController(hotSightVC)
        hotContentVC.tableView.tag = 2
        hotSightVC.tableView.tag = 2
        hotContentVC.tableView.frame = Frame.screen
        hotSightVC.tableView.frame = Frame.screen
    }
    
    /// 初始化 collectionview
    private func initCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.bounces    = false
        collectionView.backgroundColor = .clearColor()
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    }
    
    // 初始化collection布局
    private func initCollectionLayout() {
        layout.itemSize = Frame.screen.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing      = 0
        layout.scrollDirection         = .Horizontal
        collectionView.pagingEnabled   = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func refreshReachable() {
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            NSLog("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "reachabilityChanged:",
            name: ReachabilityChangedNotification,
            object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            NSLog("Unable to start Reachability Notifier")
        }
    }
    
    
    /// 初始化searchBar
    /// 清除按钮
    let clearButton = UIButton(image: "delete_searchBar", title: "", fontSize: 0)
    func initSearchBar() {
        
        navContainerView.addSubview(custNavView)
        definesPresentationContext = true
        
        custNavView.addSubview(searchController.searchBar ?? UIView())
        searchController.searchBar.frame = CGRectMake(49, 16, UIScreen.mainScreen().bounds.width - 49, 35)
        clearButton.setImage(UIImage(named: "delete_clear_hei"), forState: .Highlighted)
        clearButton.addTarget(searchController, action: "clearButtonAction", forControlEvents: .TouchUpInside)
        searchController.searchBar.keyboardAppearance = .Default
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "search_box"), forState: .Normal)
        searchController.searchBar.tintColor = UIColor(hex: 0xFFFFFF, alpha: 0.5)
        searchController.searchBar.translucent = true
        
        defaultPrompt.enabled = false
        defaultPrompt.setImage(UIImage(named: "search_icon"), forState: UIControlState.Disabled)

        for item in (searchController.searchBar.subviews) ?? [] {
            for it in item.subviews {
                if it.isKindOfClass(NSClassFromString("UISearchBarBackground")!) {
                    it.removeFromSuperview()
                }
                if it.isKindOfClass(NSClassFromString("UISearchBarTextField")!) {
                    textfile = it as? UITextField
                }
            }
        }
    }
    
    /// 初始化设置
    private func initViewSetting() {
        view.backgroundColor = SceneColor.bgBlack
        
        //nav bar
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(navContainerView)
        navContainerView.addSubview(custNavView)
        
        //header
        headerView.clipsToBounds = true
        view.addSubview(headerView)
        headerView.addSubview(headerImageView)
        headerView.addSubview(titleSelectView)
        headerImageView.contentMode = .ScaleAspectFill
        //为header添加黑色蒙板
//        let maskView = UIView(color: SceneColor.bgBlack, alphaF: 0.45)
//        headerView.addSubview(maskView)
//        headerView.addSubview(titleSelectView)
//        maskView.ff_Fill(headerView)
        view.bringSubviewToFront(navContainerView)
        
        headerImageView.userInteractionEnabled = true
        headerView.userInteractionEnabled = true
        navContainerView.userInteractionEnabled = true
        custNavView.userInteractionEnabled = true
        
        view.addSubview(slideView)
        slideView.frame = CGRectMake(0, 0, 7, UIScreen.mainScreen().bounds.height)
        
    }

    
    var isGestureRecognizer: Bool = true
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if textfile?.text != "" {
            defaultPrompt.titleLabel?.hidden = true
        } else {
            defaultPrompt.titleLabel?.hidden = false
        }
        
        refreshBar()
        isGestureRecognizer = true
        slideView.tag = 1
        self.gestureRecognizer(UIGestureRecognizer(), shouldRecognizeSimultaneouslyWithGestureRecognizer: UIGestureRecognizer())
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let touch = UITouch()
        touch.setValue(slideView, forKey: "view")
        slideView.tag = 2
        self.gestureRecognizer(UIGestureRecognizer(), shouldReceiveTouch: touch)
        
        isGestureRecognizer = false
        self.gestureRecognizer(UIGestureRecognizer(), shouldRecognizeSimultaneouslyWithGestureRecognizer: UIGestureRecognizer())
    }
    
    func refreshBar(){
        //更新导航背景
        navContainerView.backgroundColor = SceneColor.frontBlack.colorWithAlphaComponent(navBarAlpha)
        
        //更新导航高度
        navBarHeight = (MainViewContant.MaxNavbarHeight - MainViewContant.MinNavbarHeight) * (1-navBarAlpha) + MainViewContant.MinNavbarHeight
        navContainerView.frame = CGRectMake(0, 0, view.bounds.width, MainViewContant.StatusBarHeight + navBarHeight)
//        navContainerView.frame = CGRectMake(0, 0, view.bounds.width, 100)
//        custNavView.frame = CGRectMake(0, 0, view.bounds.width, 100)
        custNavView.frame      = CGRectMake(0, MainViewContant.StatusBarHeight, view.bounds.width, navBarHeight)
        slideNavButton.frame   = CGRectMake(0, 0, 50, navBarHeight)
        searchController.searchBar.frame = CGRectMake(searchController.searchBar.frame.origin.x ?? 0, 0, searchController.searchBar.frame.width ?? 0, navBarHeight)
        searchController.searchBarFrame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, navBarHeight)
        searchController.searchBarH = navBarHeight
    }
    
    
    //布局
    private func setupAutoLayout() {
        //导航布局
        slideButton.ff_AlignInner(.CenterLeft, referView: custNavView, size: CGSize(width: 21, height: 14), offset: CGPointMake(9, 0))        
        let cons = headerView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, RecommendContant.headerViewHeight))
        titleSelectView.ff_AlignInner(.BottomLeft, referView: headerView, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 45))
        headerViewTopConstraint = headerView.ff_Constraint(cons, attribute: .Top)
        
        //表格
        collectionView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(Frame.screen.width, Frame.screen.height))
        headerImageView.ff_AlignInner(.TopLeft, referView: headerView, size: CGSizeMake(UIScreen.mainScreen().bounds.width, RecommendContant.headerViewHeight - 45))
    }
    
    /// 是否正在加载中
    var isLoading:Bool = false
    
    //MARK: ScrollViewDelegate
    var yOffset: CGFloat = 0.0
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                UserProfiler.instance.isViaWiFi = true
            } else {
                UserProfiler.instance.isViaWiFi = false
            }
        }
    }
    
    func hotContentAndSightButtonAction(sender: UIButton) {
        
        let isSelected = sender.tag == 3 ? true : false
        titleSelectView.hotContentButton.selected = isSelected
        titleSelectView.hotSightButton.selected   = !isSelected
        
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: sender.tag == 3 ? 0 : 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
        
        UIView.animateWithDuration(0.5) { [weak self] () -> Void in
            self?.titleSelectView.selectView.frame.origin.x = sender.tag == 4 ? UIScreen.mainScreen().bounds.width * 0.5 : 0
        }
    }
    
    var selectedIndex: Int?
    
    // MARK: - 手势
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if touch.view!.isEqual(slideView) {
            return true
        }
        return false
    }
}

