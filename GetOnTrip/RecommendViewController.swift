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
    static let headerViewHeight:CGFloat = 244
    static let rowHeight:CGFloat = 192

    //search
    static let recommendTableViewCellID = "SearchRecommendTableViewCellID"
    static let recommendTopicViewCellID = "RecommendTopicViewCellID"
}

class RecommendViewController: MainViewController, UITableViewDataSource, UITableViewDelegate {
    
    //导航栏容器，包含状态栏的高度
    lazy var navContainerView:UIView = UIView()
    
    let slideNavButton: RecommendSlideButton = RecommendSlideButton(image: "icon_hamburger", title: "", fontSize: 0, titleColor: UIColor.whiteColor())
    
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
    
    /// 网络请求加载数据(添加)
    var lastRequest: RecommendRequest?
    
    /// 数据源 - 推荐标签
    var recommendLabels = [RecommendLabel]() {
        didSet{
            if currentSearchLabelButton == nil {
                addSearchLabelButton()
            }
        }
    }
    
    /// 数据源 - 推荐列表数据
    var recommendCells  = [RecommendCellData]()
    
    /// 搜索顶部
    var headerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, RecommendContant.headerViewHeight))
    
    /// 搜索顶部图片
    var headerImageView = UIImageView()
    
    /// headerView的顶部约束
    var headerViewTopConstraint: NSLayoutConstraint?
    
    /// 底部的tableView
    lazy var tableView = UITableView()
    
    /// 搜索控制器
    lazy var searchController: SearchViewController! = SearchViewController()
    
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
    
    /// 记录状态按钮
    var currentSearchLabelButton: UIButton?
    
    // MARK: - 初始化
    //电池栏状态
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchBar()
        initViewSetting()
        initRefresh()
        initTableView()
        setupAutoLayout()
        loadData()
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
        headerImageView.contentMode = UIViewContentMode.ScaleAspectFill
        //为header添加黑色蒙板
        let maskView = UIView(color: SceneColor.bgBlack, alphaF: 0.45)
        headerView.addSubview(maskView)
        maskView.ff_Fill(headerView)
        view.bringSubviewToFront(navContainerView)
    }
    
    /// 初始化刷新控件
    private func initRefresh() {
        
        //下拉刷新
        let tbHeaderView = MJRefreshNormalHeader { [weak self] () -> Void in
            self?.loadData()
        }
        tbHeaderView.automaticallyChangeAlpha = true
        tbHeaderView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        tbHeaderView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbHeaderView.lastUpdatedTimeLabel?.font = UIFont.systemFontOfSize(11)
        tbHeaderView.stateLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.hidden = true
        tbHeaderView.stateLabel?.hidden = true
        tbHeaderView.arrowView?.image = UIImage()
        
        //上拉刷新
        let tbFooterView = MJRefreshAutoNormalFooter { [weak self] () -> Void in
            self?.loadMore()
        } //
        tbFooterView.automaticallyRefresh = true
        tbFooterView.automaticallyChangeAlpha = true
        tbFooterView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        tbFooterView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbFooterView.stateLabel?.textColor = SceneColor.lightGray
        
        tableView.mj_header = tbHeaderView
        tableView.mj_footer = tbFooterView
    }
    
    /// 初始化tableView
    private func initTableView() {
        //添加tableview相关属性
        view.addSubview(tableView)
        tableView.dataSource      = self
        tableView.delegate        = self
        tableView.tableHeaderView = nil
        tableView.rowHeight       = RecommendContant.rowHeight
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle  = UITableViewCellSeparatorStyle.None
        tableView.contentInset    = UIEdgeInsets(top: RecommendContant.headerViewHeight, left: 0, bottom: 64, right: 0)
        
        tableView.registerClass(RecommendTableViewCell.self, forCellReuseIdentifier: RecommendContant.recommendTableViewCellID)
        tableView.registerClass(RecommendTopicViewCell.self, forCellReuseIdentifier: RecommendContant.recommendTopicViewCellID)
//        view.sendSubviewToBack(tableView)
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if textfile?.text != "" {
            defaultPrompt.titleLabel?.hidden = true
        } else {
            defaultPrompt.titleLabel?.hidden = false
        }
        
        refreshBar()
    }

    
    func refreshBar(){
        //更新导航背景
        navContainerView.backgroundColor = SceneColor.frontBlack.colorWithAlphaComponent(navBarAlpha)
        
        //更新导航高度
        navBarHeight = (MainViewContant.MaxNavbarHeight - MainViewContant.MinNavbarHeight) * (1-navBarAlpha) + MainViewContant.MinNavbarHeight
        navContainerView.frame = CGRectMake(0, 0, view.bounds.width, MainViewContant.StatusBarHeight + navBarHeight)
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
        let cons = headerView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, RecommendContant.headerViewHeight), offset: CGPointMake(0, 0))
        headerViewTopConstraint = headerView.ff_Constraint(cons, attribute: NSLayoutAttribute.Top)
        
        //表格
        tableView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height + 64), offset: CGPointMake(0, 0))
        headerImageView.ff_Fill(headerView)
    }
    
    ///  添加搜索标签按钮
    private func addSearchLabelButton() {
        //参数
        let btnWidth:CGFloat  = 95
        let btnHeight:CGFloat = (244 - 75) / 3 - 15
        let totalCol:Int      = 2
        let totalRow:Int      = 3
        let yOffset:CGFloat   = 75
        let marginX:CGFloat   = (headerView.bounds.size.width - btnWidth * CGFloat(totalCol)) / CGFloat(totalCol + 1)
        let marginY:CGFloat   = 15

        for (var i = 0; i < recommendLabels.count; i++) {
            let btn: UIButton = UIButton(title: recommendLabels[i].name, fontSize: 14, radius: 0)
            headerView.addSubview(btn)
            btn.contentHorizontalAlignment = .Center
            btn.addTarget(self, action: "clkSearchLabelMethod:", forControlEvents: .TouchUpInside)
            btn.setTitleColor(UIColor(hex: 0xFFFFFF, alpha: 0.6), forState: .Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            btn.tag = Int(recommendLabels[i].order) ?? 1
            if i == 0 {
                btn.selected = true
                currentSearchLabelButton = btn
            }
            let row:Int = i / totalCol
            let col:Int = i % totalCol
            
            if row >= totalRow {
                break
            }
            
            var btnX:CGFloat = marginX + (marginX + btnWidth) * CGFloat(col)
            let btnY:CGFloat = yOffset + (marginY + btnHeight) * CGFloat(row)
            
            btnX += i % 2 == 0 ? 5 : -5
            if i == 0 || i == 1 {
                btn.contentVerticalAlignment = .Bottom
            } else if i == 4 || i == 5 {
                btn.contentVerticalAlignment = .Top
            }
            btn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight)
        }
    }
    
    /// 是否正在加载中
    var isLoading:Bool = false
    
    //MARK: ScrollViewDelegate
    var yOffset: CGFloat = 0.0
    
    deinit {
        autoreleasepool { () -> () in
            searchController
        }
    }
}

