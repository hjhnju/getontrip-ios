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
    lazy var navContainerView:UIView = {
        let view = UIView()
        view.addSubview(self.custNavView)
        return view
        }()
    
    let slideNavButton = RecommendSlideButton(image: "icon_hamburger", title: "", fontSize: 0, titleColor: UIColor.whiteColor())
    
    //自定义导航栏
    lazy var custNavView:UIView = {
        let view = UIView()
        self.slideButton.removeFromSuperview()
        self.slideNavButton.addTarget(self, action: "toggleMenu", forControlEvents: .TouchUpInside)
        view.addSubview(self.slideNavButton)
        view.addSubview(self.searchButton)
        return view
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.setBackgroundImage(UIImage(named: "search_box"), forState: UIControlState.Normal)
        button.addTarget(self, action: "showSearch", forControlEvents: UIControlEvents.TouchUpInside)
        button.adjustsImageWhenDisabled = false
        button.adjustsImageWhenHighlighted = false
        let descLabel = UILabel(color: UIColor.whiteColor(), title: "搜索城市、景点等内容", fontSize: 12)
        let iconView = UIImageView(image: UIImage(named: "search_icon"))
        button.addSubview(descLabel)
        button.addSubview(iconView)
        iconView.ff_AlignInner(.CenterLeft, referView: button, size: CGSize(width: 15, height: 16.5), offset: CGPoint(x:8, y:0))
        descLabel.ff_AlignInner(.CenterLeft, referView: button, size: CGSize(width: 120, height: 12), offset: CGPoint(x: 26, y: 0))
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
    var lastRequest: RecommendRequest?
    
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
    var headerImageView = UIImageView()
    
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
        refreshButton.ff_AlignInner(.TopCenter, referView: view, size: CGSize(width: 26, height: 26), offset: CGPointMake(0, 30))
        refreshHint1.ff_AlignVertical(.BottomCenter, referView: refreshButton, size: nil, offset: CGPointMake(0, 12))
        refreshHint2.ff_AlignVertical(.BottomCenter, referView: refreshHint1, size: nil, offset: CGPointMake(0, 0))
        
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
        
        initViewSetting()
        initRefresh()
        initTableView()
        setupAutoLayout()
        initData()
    }
    
    /// 初始化设置
    private func initViewSetting() {
        view.backgroundColor = SceneColor.bgBlack
        
        //nav bar
        self.automaticallyAdjustsScrollViewInsets = false
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
        let tbHeaderView = MJRefreshNormalHeader(refreshingBlock: loadData)
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
        let tbFooterView = MJRefreshAutoNormalFooter(refreshingBlock: loadMore)
        tbFooterView.automaticallyRefresh = true
        tbFooterView.automaticallyChangeAlpha = true
        tbFooterView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        tbFooterView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbFooterView.stateLabel?.textColor = SceneColor.lightGray
        
        self.tableView.mj_header = tbHeaderView
        self.tableView.mj_footer = tbFooterView
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
        view.sendSubviewToBack(tableView)
    }
    
    func initData() {
        if !tableView.mj_header.isRefreshing() {
            tableView.mj_header.beginRefreshing()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        slideNavButton.frame   = CGRectMake(0, 0, 50, navBarHeight)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //布局
    private func setupAutoLayout() {
        //导航布局
        slideButton.ff_AlignInner(.CenterLeft, referView: custNavView, size: CGSize(width: 21, height: 14), offset: CGPointMake(9, 0))
        searchButton.ff_AlignInner(.CenterRight, referView: custNavView, size: CGSize(width: view.bounds.width-(414-356), height: MainViewContant.SearchBarHeight), offset: CGPointMake(-9, 0))
        
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
            let btn: RecommendButton = RecommendButton(title: recommendLabels[i].name, fontSize: 14, radius: 0)
            btn.numLabel.text = recommendLabels[i].num
            headerView.addSubview(btn)
            btn.titleLabel?.textAlignment = NSTextAlignment.Center
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            btn.addTarget(self, action: "clkSearchLabelMethod:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.setTitleColor(UIColor(hex: 0xFFFFFF, alpha: 0.6), forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
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
                btn.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
                btn.numLabel.ff_AlignInner(.BottomRight, referView: btn, size: nil)
            } else if i == 4 || i == 5 {
                btn.contentVerticalAlignment = UIControlContentVerticalAlignment.Top
                btn.numLabel.ff_AlignInner(.TopRight, referView: btn, size: nil)
            } else if i == 2 || i == 3 {
                btn.numLabel.ff_AlignInner(.CenterRight, referView: btn, size: nil)
            }
            
            btn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight)
        }
    }

    
    // MASKS: - tableView 数据源及代理方法
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recommendCells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = self.recommendCells[indexPath.row]
        if data.isTypeTopic() {
            let cell = tableView.dequeueReusableCellWithIdentifier(RecommendContant.recommendTopicViewCellID, forIndexPath: indexPath) as! RecommendTopicViewCell
            cell.backgroundColor = UIColor.clearColor()
            cell.data = self.recommendCells[indexPath.row]
            
            let factor = calcFactor(cell.frame.origin.y + RecommendContant.rowHeight, yOffset: 0)
            cell.cellImageView.updateFactor(factor)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(RecommendContant.recommendTableViewCellID, forIndexPath: indexPath) as! RecommendTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.data = self.recommendCells[indexPath.row]
        
        let factor = calcFactor(cell.frame.origin.y + RecommendContant.rowHeight, yOffset: 0)
        cell.cellImageView.updateFactor(factor)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = self.recommendCells[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if ( data.isTypeSight()) {
            let vc = SightViewController()
            let sight = Sight(id: data.id)
            sight.name = data.name
            sight.image = data.image
            vc.sightDataSource = sight
            navigationController?.pushViewController(vc, animated: true)
        } else if( data.isTypeCity()) {
            let vc = CityViewController()
            let city = City(id: data.id)
            city.name = data.name
            city.image = data.image
            vc.cityDataSource = city
            navigationController?.pushViewController(vc, animated: true)
        } else if( data.isTypeTopic()) {
            let vc = TopicViewController()
            let topic = Topic(id: data.id)
            topic.title = data.name
            topic.image = data.image
            topic.sightid = data.param4
            vc.topicDataSource = topic
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: ScrollViewDelegate
    var yOffset: CGFloat = 0.0
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        yOffset = scrollView.contentOffset.y
    }
    
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
        
        for vcell in self.tableView.visibleCells {
            if let cell = vcell as? RecommendTableViewCell {
                let factor = calcFactor(cell.frame.origin.y + RecommendContant.rowHeight, yOffset: gap)
                cell.cellImageView.updateFactor(factor)
            } else if let cell = vcell as? RecommendTopicViewCell {
                let factor = calcFactor(cell.frame.origin.y + RecommendContant.rowHeight, yOffset: gap)
                cell.cellImageView.updateFactor(factor)
            }
        }
    }
    
    private func calcFactor(frameY:CGFloat, yOffset: CGFloat) -> CGFloat {
        //以屏幕左上为原点的坐标
        let realY = frameY - yOffset
        let centerY = UIScreen.mainScreen().bounds.height / 2 - RecommendContant.rowHeight / 2
        //距离cell中间的距离
        let gapToCenter = -(realY - centerY)
        var divider = UIScreen.mainScreen().bounds.height / 2 - RecommendContant.rowHeight / 2
        if gapToCenter < 0 {
            divider = UIScreen.mainScreen().bounds.height / 2 - RecommendContant.rowHeight / 2
        }
        let factor: CGFloat = fmin(1.0, fmax(gapToCenter / divider, -1.0))
        //print("gap=\(gapToCenter), offsetY=\(yOffset), frame.y=\(frameY), realY=\(realY), centerY=\(centerY), factor=\(factor)")
        return factor
    }
    
    //MARK: 自定义方法
    
    //触发搜索列表的方法
    func clkSearchLabelMethod(sender: UIButton) {
        if sender.tag == currentSearchLabelButton?.tag { return }
        sender.selected = true
        currentSearchLabelButton?.selected = false
        currentSearchLabelButton = sender
        
        
        lastRequest?.order = String(sender.tag)
        tableView.mj_header.beginRefreshing()
    }
    
    /// 是否正在加载中
    var isLoading:Bool = false
    
    /// 发送搜索信息
    /// 注意：不能在loadData中进行beginRefreshing, beginRefreshing会自动调用loadData
    func loadData() {
        if self.isLoading {
            return
        }
        
        self.isLoading = true
        self.errorView.hidden = true
        
        //清空footer的“加载完成”
        self.tableView.mj_footer.resetNoMoreData()
        if lastRequest == nil {
            lastRequest = RecommendRequest()
            lastRequest?.order = "1" //默认返回带所有搜索标签
        }
        
        lastRequest?.fetchFirstPageModels {[weak self] (data, status) -> Void in
            //处理异常状态
            if RetCode.SUCCESS != status {
                if self?.recommendCells.count == 0 {
                    //当前无内容时显示出错页
                    self?.tableView.hidden = true
                    self?.errorView.hidden = false
                } else {
                    //当前有内容显示出错浮层
                    ProgressHUD.showErrorHUD(self?.view, text: "您的网络无法连接")
                }
                self?.tableView.mj_header.endRefreshing()
                self?.isLoading = false
                return
            }
            
            //处理返回数据
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
                self?.loadHeaderImage(dataSource.objectForKey("image") as? String)
                self?.tableView.reloadData()
            }
            self?.tableView.mj_header.endRefreshing()
            self?.isLoading = false
        }
    }
    
    /// 底部加载更多
    func loadMore(){
        if self.isLoading {
            return
        }
        self.isLoading = true
        //请求下一页
        self.lastRequest?.fetchNextPageModels { [weak self] (data, status) -> Void in

            if let dataSource = data {
                let newCells  = dataSource.objectForKey("cells") as! [RecommendCellData]
                if newCells.count > 0 {
                    if let cells = self?.recommendCells {
                        self?.recommendCells = cells + newCells
                        self?.tableView.reloadData()
                    }
                    self?.tableView.mj_footer.endRefreshing()
                } else {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            self?.isLoading = false
        }
    }
    
    /// 网络异常重现加载
    func refreshFromErrorView(sender: UIButton){
        self.errorView.hidden = true
        self.tableView.hidden = false
        //重新加载
        if !self.tableView.mj_header.isRefreshing() {
            self.tableView.mj_header.beginRefreshing()
        }
    }
    
    func loadHeaderImage(url: String?) {
        if let url = url {
            //从网络获取
            self.headerImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: PlaceholderImage.defaultLarge)
        }
    }
}

