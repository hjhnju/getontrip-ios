//
//  SearchListPageController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class SearchListPageController: BaseHomeController, UITableViewDataSource, UITableViewDelegate {
    
    /// 底部的tableView
    lazy var tableView = UITableView()
    
    var dataSource: NSDictionary?
    
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: HomeSearchCityRequest?
    
    /// 搜索顶部
    var headerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 244))
    
    /// 遮罩
//    lazy var shade: UIView = UIView(color: UIColor(hex: 0x2A2D2E, alpha: 0.55))
    
    /// 搜索顶部图片
    var iconView = UIImageView(image: UIImage(named: "fvclhwpdlenpbjqd_original.jpg"))
    
    /// 排序数据源
    var searchLabel = ["历史名城   8", "地理奇观   8", "名胜古迹  30", "艺术殿堂  30", "室外古镇  14", "丝绸之路  14"]
    
    /// 当前定位所在地
    lazy var currentLocus: UILabel = UILabel(color: UIColor.whiteColor(), title: "当前定位在北京，", fontSize: 16, mutiLines: false)
    
    /// 立即进入按钮
    lazy var enterButton: UIButton = UIButton(title: "立即进入", fontSize: 16, radius: 0, titleColor: UIColor.yellowColor())

    
    // MARK: - 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableViewProperty()
        view.backgroundColor = SceneColor.homeGrey
        
        headerView.addSubview(iconView)
        headerView.addSubview(currentLocus)
        headerView.addSubview(enterButton)
//        headerView.addSubview(shade)

        headerView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 244)
        
        loadSearchData()
        setupAutoLayout()
        addSearchTitleButton()
    }
    
    ///  添加tableview相关属性
    private func addTableViewProperty() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.tableHeaderView = headerView
        tableView.registerClass(SearchListTableViewCell.self, forCellReuseIdentifier: "SearchListTableView_Cell")
        tableView.rowHeight = 192
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    ///  添加搜索标题按钮
    private func addSearchTitleButton() {
        for (var i = 0; i < searchLabel.count; i++) {
            
            let btn = UIButton(title: searchLabel[i], fontSize: 14, radius: 0)
            btn.addTarget(self, action: "searchTitleMethod:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.setTitleColor(UIColor(hex: 0xFFFFFF, alpha: 0.6), forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
            headerView.addSubview(btn)
            
            let btnW = 87
            let btnH = 19
            
            let totalCol = 2
            let row = i / totalCol
            let col = i % totalCol
            
            let marginX = (Int(headerView.bounds.size.width) - Int(btnW * totalCol)) / Int(totalCol + 1)
            let marginY = -45
            
            let btnX = marginX + (marginX + btnW) * col
            let btnY = 84 + (marginY + btnW) * row
            
            btn.frame = CGRectMake(CGFloat(btnX), CGFloat(btnY), CGFloat(btnW), CGFloat(btnH))
        }
    }
    
    ///  布局
    private func setupAutoLayout() {
        tableView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height + 64), offset: CGPointMake(0, -64))
        iconView.ff_AlignInner(ff_AlignType.TopLeft, referView: headerView, size: CGSizeMake(view.bounds.width, 244), offset: CGPointMake(0, 0))
        currentLocus.ff_AlignInner(ff_AlignType.BottomCenter, referView: headerView, size: nil, offset: CGPointMake(-30, -5))
        enterButton.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: currentLocus, size: nil, offset: CGPointMake(0, 0))

//        shade.ff_Fill(shade)
    }
    
    
    /// 发送反馈消息
    private func loadSearchData() {
        
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = HomeSearchCityRequest()
        }
        
        lastSuccessAddRequest?.fetchFeedBackModels {[unowned self] (handler: NSDictionary) -> Void in
            self.dataSource = handler
            self.tableView.reloadData()
        }
    }
    
    ///  触发搜索列表的方法
    ///
    ///  - parameter btn: 排序的按钮
    func searchTitleMethod(btn: UIButton) {
        
        btn.selected = true
        
        print("点击了这个搜索方法")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - tableView 数据源及代理方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100//(dataSource?.objectForKey("datas")?.count)! + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchListTableView_Cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256) / 255), green: CGFloat(CGFloat(arc4random_uniform(256) / 255)), blue: CGFloat(CGFloat(arc4random_uniform(256) / 255)), alpha: 1.0)
//        cell.backgroundColor = UIColor.orangeColor()
        cell.textLabel?.text = "1"
        return cell
    }
    
    
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let v = UIView(color: UIColor.greenColor(), alphaF: 1.0)
//        v.backgroundColor = UIColor.greenColor()
//        
//        return v
//    }
//    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "asdfasda"
//    }
}

