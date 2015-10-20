//
//  SearchListPageController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

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

    /// 数据源
    var dataSource: NSDictionary?
    
    // 搜索标签文本列表
    var searchLabels: NSMutableArray    = NSMutableArray()
    
    // 搜索标签id列表
    var searchLabelIds: NSMutableArray = NSMutableArray()
    
    /// 底部的tableView
    lazy var tableView = UITableView()
    
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: SearchRecommendRequest?
    
    /// 搜索顶部
    var headerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 244))
    
    /// 搜索顶部图片
    var headerImageView = UIImageView(image: UIImage(named: "search_header"))

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
        self.automaticallyAdjustsScrollViewInsets = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        view.addSubview(navContainerView)
        navContainerView.addSubview(custNavView)
        
        //header
        headerView.addSubview(headerImageView)
        headerView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 244)
        //为header添加黑色蒙板
        let maskView = UIView(color: SceneColor.bgBlack, alphaF: 0.55)
        headerView.addSubview(maskView)
        maskView.ff_Fill(headerView)
        
        //添加tableview相关属性
        view.addSubview(tableView)
        tableView.dataSource      = self
        tableView.delegate        = self
        tableView.tableHeaderView = headerView
        tableView.rowHeight       = SearchRecommendTableViewCell.RowHeight
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle  = UITableViewCellSeparatorStyle.None
        tableView.registerClass(SearchRecommendTableViewCell.self, forCellReuseIdentifier: StoryBoardIdentifier.SearchRecommendTableViewCellID)
        
        view.bringSubviewToFront(navContainerView)
        
        setupAutoLayout()
        loadSearchData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
        
        navigationController?.navigationBar.hidden = true
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
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBarHidden = false
    }
    
    //布局
    private func setupAutoLayout() {
        //导航布局
        slideButton.ff_AlignInner(ff_AlignType.CenterLeft, referView: custNavView, size: CGSize(width: 21, height: 14), offset: CGPointMake(9, 0))
        searchButton.ff_AlignInner(ff_AlignType.CenterRight, referView: custNavView, size: CGSize(width: view.bounds.width-(414-356), height: MainViewContant.SearchBarHeight), offset: CGPointMake(-9, 0))
        
        //表格
        tableView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height + 64), offset: CGPointMake(0, -20))
        headerImageView.ff_Fill(headerView)
    }
    
    /// 发送搜索信息
    private func loadSearchData() {
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = SearchRecommendRequest()
        }
        
        lastSuccessAddRequest?.fetchModels {[unowned self] (handler: NSDictionary) -> Void in
            
            self.dataSource = handler
            if self.searchLabels.count == 0 {
                for lab in handler.objectForKey("labels") as! NSArray {
                    let labM = lab as! SearchLabel
                    let label = labM.name! + "    " + labM.num!
                    self.searchLabels.addObject(label)
                    self.searchLabelIds.addObject(labM.id!)
                }
                self.addSearchLabelButton()
            }
            self.headerImageView.sd_setImageWithURL(NSURL(string: handler.objectForKey("image") as! String), placeholderImage: UIImage(named: "search_header"))
            self.tableView.reloadData()
        }
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
        
        for (var i = 0; i < searchLabels.count; i++) {
            let btn = UIButton(title: searchLabels[i] as! String, fontSize: 14, radius: 0)
            
            headerView.addSubview(btn)
            
            btn.addTarget(self, action: "clkSearchLabelMethod:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.setTitleColor(UIColor(hex: 0xFFFFFF, alpha: 0.6), forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
            btn.tag = searchLabelIds[i].integerValue
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
        if dataSource != nil {
            return dataSource!.objectForKey("datas")!.count!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.SearchRecommendTableViewCellID, forIndexPath: indexPath) as! SearchRecommendTableViewCell
        
        let array = dataSource!.objectForKey("datas") as! NSArray
        cell.backgroundColor = UIColor.clearColor()
        cell.data = array[indexPath.row] as? RecommendCellData
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let array = dataSource!.objectForKey("datas") as! NSArray
        if let data = array[indexPath.row] as? RecommendCellData {
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
    }
    
    //MARK: ScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //导航渐变
        let threshold:CGFloat = 198 - 64
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0 {
            navBarAlpha = offsetY / threshold;
            if navBarAlpha > 1 {
                navBarAlpha = 1
            } else if navBarAlpha < 0.1 {
                navBarAlpha = 0
            }
        }
    }
    
    //MARK: 自定义方法
    
    //触发搜索列表的方法
    func clkSearchLabelMethod(sender: UIButton) {
        sender.selected = true
        currentSearchLabelButton?.selected = false
        currentSearchLabelButton = sender
        
        lastSuccessAddRequest!.label = String(sender.tag)
        loadSearchData()
    }
}

