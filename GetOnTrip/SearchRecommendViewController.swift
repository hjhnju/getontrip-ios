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
}

class SearchRecommendViewController: MainViewController, UITableViewDataSource, UITableViewDelegate {
    
    //导航栏容器，包含状态栏的高度
    lazy var navContainerView:UIView = {
        let view = UIView()
        view.addSubview(self.custNavView)
        return view
        }()
    
    //自定义导航栏
    lazy var custNavView:UIView = {
        let view = UIView()
        view.addSubview(self.slideButton)
        view.addSubview(self.searchButton)
        return view
        }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.setBackgroundImage(UIImage(named: "search_box"), forState: UIControlState.Normal)
        button.addTarget(self, action: "showSearch", forControlEvents: UIControlEvents.TouchUpInside)
        button.adjustsImageWhenDisabled = false
        button.adjustsImageWhenHighlighted = false
        let descLabel = UILabel(color: UIColor.whiteColor(), title: "搜索景点、城市等内容", fontSize: 12)
        let iconView = UIImageView(image: UIImage(named: "search_icon"))
        button.addSubview(descLabel)
        button.addSubview(iconView)
        iconView.ff_AlignInner(ff_AlignType.CenterLeft, referView: button, size: CGSize(width: 15, height: 16.5), offset: CGPoint(x:8, y:0))
        descLabel.ff_AlignInner(ff_AlignType.CenterLeft, referView: button, size: CGSize(width: 120, height: 12), offset: CGPoint(x: 26, y: 0))
        return button
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
    var lastSuccessRequest: SearchRecommendRequest?
    
    /// 数据源 - 推荐标签
    var recommendLabels = [RecommendLabel]() {
        didSet{
            if currentSearchLabelButton == nil {
                self.addSearchLabelButton()
            }
        }
    }
    
    /// 数据源 - 推荐列表数据
    var recommendCells  = [RecommendCellData]()
    
    /// 搜索顶部
    var headerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, RecommendContant.headerViewHeight))
    
    /// 搜索顶部图片
    var headerImageView = UIImageView(image: UIImage(named: "search_header"))
    
    /// headerView的顶部约束
    var headerViewTopConstraint: NSLayoutConstraint?
    
    /// 底部的tableView
    lazy var tableView = UITableView()
    
    lazy var errorView: UIView = {
        let view = UIView()
        let refreshButton = UIButton(icon: "icon_refresh", masksToBounds: true)
        let refreshHint1   = UILabel(color: SceneColor.white.colorWithAlphaComponent(0.5), title: "网速好像不给力", fontSize: 13)
        let refreshHint2   = UILabel(color: SceneColor.white.colorWithAlphaComponent(0.5), title: "点击此处重新加载", fontSize: 13)
        view.frame = CGRectMake(0, RecommendContant.headerViewHeight, UIScreen.mainScreen().bounds.width, 123)
        view.addSubview(refreshButton)
        view.addSubview(refreshHint1)
        view.addSubview(refreshHint2)
        refreshButton.ff_AlignInner(ff_AlignType.TopCenter, referView: view, size: CGSize(width: 26, height: 26), offset: CGPointMake(0, 30))
        refreshHint1.ff_AlignVertical(ff_AlignType.BottomCenter, referView: refreshButton, size: nil, offset: CGPointMake(0, 12))
        refreshHint2.ff_AlignVertical(ff_AlignType.BottomCenter, referView: refreshHint1, size: nil, offset: CGPointMake(0, 0))
        
        //add target
        refreshButton.addTarget(self, action: "refreshFromErrorView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(view)
        self.view.sendSubviewToBack(view)
        view.hidden = true
        return view
    }()
    /// 记录状态按钮
    weak var currentSearchLabelButton: UIButton?
    
    // MARK: - 初始化
    
    //电池栏状态
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = SceneColor.bgBlack
        
        //nav bar
        navigationController?.navigationBarHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        view.addSubview(navContainerView)
        navContainerView.addSubview(custNavView)
        
        //header
        view.addSubview(headerView)
        headerView.addSubview(headerImageView)
        //headerView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 244)
        //为header添加黑色蒙板
        let maskView = UIView(color: SceneColor.bgBlack, alphaF: 0.55)
        headerView.addSubview(maskView)
        maskView.ff_Fill(headerView)
        
        //上拉刷新
        let tbHeaderView = MJRefreshNormalHeader(refreshingBlock: loadData)
        tbHeaderView.automaticallyChangeAlpha = true
        tbHeaderView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        tbHeaderView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbHeaderView.lastUpdatedTimeLabel?.font = UIFont.systemFontOfSize(11)
        tbHeaderView.stateLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.textColor = SceneColor.lightGray
        
        //上拉刷新
        let tbFooterView = MJRefreshAutoNormalFooter(refreshingBlock: loadMore)
        tbFooterView.automaticallyRefresh = true
        tbFooterView.automaticallyChangeAlpha = true
        tbFooterView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        tbFooterView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbFooterView.stateLabel?.textColor = SceneColor.lightGray
        
        
        self.tableView.header = tbHeaderView
        self.tableView.footer = tbFooterView
        
        //添加tableview相关属性
        view.addSubview(tableView)
        tableView.dataSource      = self
        tableView.delegate        = self
        tableView.tableHeaderView = nil
        tableView.rowHeight       = SearchRecommendTableViewCell.RowHeight
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle  = UITableViewCellSeparatorStyle.None
        tableView.contentInset    = UIEdgeInsets(top: RecommendContant.headerViewHeight, left: 0, bottom: 64, right: 0)
        
        tableView.registerClass(SearchRecommendTableViewCell.self, forCellReuseIdentifier: StoryBoardIdentifier.SearchRecommendTableViewCellID)
        view.sendSubviewToBack(tableView)

        view.bringSubviewToFront(navContainerView)
        
        setupAutoLayout()
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
        
        refreshBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func refreshBar(){
        //更新导航背景
        navContainerView.backgroundColor = SceneColor.frontBlack.colorWithAlphaComponent(navBarAlpha)
        
        //更新导航高度
        navBarHeight = (MainViewContant.MaxNavbarHeight - MainViewContant.MinNavbarHeight)  * (1-navBarAlpha) + MainViewContant.MinNavbarHeight
        navContainerView.frame = CGRectMake(0, 0, view.bounds.width, MainViewContant.StatusBarHeight + navBarHeight)
        custNavView.frame      = CGRectMake(0, MainViewContant.StatusBarHeight, view.bounds.width, navBarHeight)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBarHidden = false
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //布局
    private func setupAutoLayout() {
        //导航布局
        slideButton.ff_AlignInner(ff_AlignType.CenterLeft, referView: custNavView, size: CGSize(width: 21, height: 14), offset: CGPointMake(9, 0))
        searchButton.ff_AlignInner(ff_AlignType.CenterRight, referView: custNavView, size: CGSize(width: view.bounds.width-(414-356), height: MainViewContant.SearchBarHeight), offset: CGPointMake(-9, 0))
        
        let cons = headerView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, RecommendContant.headerViewHeight), offset: CGPointMake(0, 0))
        headerViewTopConstraint = headerView.ff_Constraint(cons, attribute: NSLayoutAttribute.Top)
        
        
        //表格
        tableView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height + 64), offset: CGPointMake(0, 0))
        headerImageView.ff_Fill(headerView)
    }
    
    ///  添加搜索标签按钮
    private func addSearchLabelButton() {
        //参数
        let btnWidth:CGFloat  = 87
        let btnHeight:CGFloat = 17
        let totalCol:Int      = 2
        let totalRow:Int      = 3
        let marginX:CGFloat   = (headerView.bounds.size.width - btnWidth * CGFloat(totalCol)) / CGFloat(totalCol + 1)
        let yOffset:CGFloat   = 105
        let marginY:CGFloat   = 26

        for (var i = 0; i < recommendLabels.count; i++) {
            let btn = UIButton(title: recommendLabels[i].toString(), fontSize: 14, radius: 0)
            
            headerView.addSubview(btn)
            
            btn.addTarget(self, action: "clkSearchLabelMethod:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.setTitleColor(UIColor(hex: 0xFFFFFF, alpha: 0.6), forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
            btn.tag = Int(recommendLabels[i].id)!
            if i == 0 {
                btn.selected = true
                currentSearchLabelButton = btn
            }
            let row:Int = i / totalCol
            let col:Int = i % totalCol
            
            if row >= totalRow {
                break
            }
            
            let btnX:CGFloat = marginX + (marginX + btnWidth) * CGFloat(col)
            let btnY:CGFloat = yOffset + (marginY + btnHeight) * CGFloat(row)
            
            btn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight)
        }
    }

    
    // MASK: - tableView 数据源及代理方法
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recommendCells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.SearchRecommendTableViewCellID, forIndexPath: indexPath) as! SearchRecommendTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.data = self.recommendCells[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = self.recommendCells[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (!data.isTypeCity()) {
            let vc = SightViewController()
            vc.sightId   = data.id
            vc.sightName = data.name
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = CityViewController()
            vc.cityId   = data.id
            vc.cityName = data.name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: ScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //导航渐变
        let threshold:CGFloat = 198 - 64
        let offsetY = scrollView.contentOffset.y
        let gap = RecommendContant.headerViewHeight + offsetY
        if gap > 0 {
            navBarAlpha = gap / threshold;
            if navBarAlpha > 1 {
                navBarAlpha = 1
            } else if navBarAlpha < 0.1 {
                navBarAlpha = 0
            }
        }
        
        //headerView高度动态变化
        let initTop: CGFloat = 0.0
        let newTop = min(-gap, initTop)
        headerViewTopConstraint?.constant = newTop
    }
    
    //MARK: 自定义方法
    
    //触发搜索列表的方法
    func clkSearchLabelMethod(sender: UIButton) {
        sender.selected = true
        currentSearchLabelButton?.selected = false
        currentSearchLabelButton = sender
        
        lastSuccessRequest!.label = String(sender.tag)
        loadData()
    }
    
    /// 发送搜索信息
    private func loadData() {
        tableView.header.beginRefreshing()
        self.errorView.hidden = true
        
        //清空footer的“加载完成”
        tableView.footer.endRefreshing()
        if lastSuccessRequest == nil {
            lastSuccessRequest = SearchRecommendRequest()
            lastSuccessRequest?.label = "" //默认返回带所有搜索标签
        }
        
        lastSuccessRequest?.fetchFirstPageModels {[weak self] (data, status) -> Void in
            //处理异常状态
            if RetCode.SUCCESS != status {
                //TODO:断网时有一直闪的bug
                self?.tableView.header.endRefreshing()
                if self?.recommendCells.count == 0 {
                    self?.tableView.hidden = true
                    self?.errorView.hidden = false
                }
                return
            }
            
            //处理数据
            if let dataSource = data {
                let cells  = dataSource.objectForKey("cells") as! [RecommendCellData]
                //有数据才更新
                if cells.count > 0 {
                    self?.recommendCells = cells
                }
                let labels = dataSource.objectForKey("labels") as! [RecommendLabel]
                if labels.count > 0 {
                    self?.recommendLabels = labels
                }
                self?.headerImageView.sd_setImageWithURL(NSURL(string: dataSource.objectForKey("image") as! String), placeholderImage: UIImage(named: "search_header"))
                self?.tableView.reloadData()
            }
            self?.tableView.header.endRefreshing()
        }
    }
    
    //底部加载更多
    var isLoadingMore:Bool = false
    
    func loadMore(){
        if self.isLoadingMore {
            return
        }
        self.isLoadingMore = true
        //请求下一页
        self.lastSuccessRequest?.fetchNextPageModels { [weak self] (data, status) -> Void in

            if let dataSource = data {
                let newCells  = dataSource.objectForKey("cells") as! [RecommendCellData]
                if newCells.count > 0 {
                    if let cells = self?.recommendCells {
                        self?.recommendCells = cells + newCells
                        self?.tableView.reloadData()
                    }
                    self?.tableView.footer.endRefreshing()
                } else {
                    self?.tableView.footer.endRefreshingWithNoMoreData()
                }
                self?.isLoadingMore = false
            }
        }
    }
    
    /// 网络异常重现加载
    func refreshFromErrorView(sender: UIButton){
        self.errorView.hidden = true
        self.tableView.hidden = false
        loadData()
    }
}

