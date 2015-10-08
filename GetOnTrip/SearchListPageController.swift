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
    
    /// 搜索顶部图片
    var iconView = UIImageView(image: UIImage(named: "fvclhwpdlenpbjqd_original.jpg"))
    
    /// 排序数据源
    var searchLabel: NSMutableArray = NSMutableArray()
    var searchLabelTags: NSMutableArray = NSMutableArray()
    
    /// 当前定位所在地
    lazy var currentLocus: UILabel = UILabel(color: UIColor.whiteColor(), title: "当前定位在", fontSize: 16, mutiLines: false)
    
    lazy var currentCity: String = "北京"
    
    /// 立即进入按钮
    lazy var enterButton: UIButton = UIButton(title: "立即进入", fontSize: 16, radius: 0, titleColor: UIColor.yellowColor())

    /// 记录状态按钮
    var tempButton: UIButton?
    
    // MARK: - 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableViewProperty()
        view.backgroundColor = SceneColor.homeGrey
        
        headerView.addSubview(iconView)
        headerView.addSubview(currentLocus)
        headerView.addSubview(enterButton)
        currentLocus.text = currentLocus.text! + currentCity

        headerView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 244)
        enterButton.addTarget(self, action: "enterButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        loadSearchData()
        setupAutoLayout()
    }
    
    func enterButtonClick() {
        
        navigationController?.pushViewController(CityCenterPageController(), animated: true)
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
            
            let btn = UIButton(title: searchLabel[i] as! String, fontSize: 14, radius: 0)
            btn.addTarget(self, action: "searchTitleMethod:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.setTitleColor(UIColor(hex: 0xFFFFFF, alpha: 0.6), forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
            headerView.addSubview(btn)
            btn.tag = searchLabelTags[i].integerValue
            if i == 0 {
                btn.selected = true
                tempButton = btn
            }
            
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
        //let btn = headerView.subviews[0]
    }
    
    ///  布局
    private func setupAutoLayout() {
        tableView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height + 64), offset: CGPointMake(0, -64))
        iconView.ff_AlignInner(ff_AlignType.TopLeft, referView: headerView, size: CGSizeMake(view.bounds.width, 244), offset: CGPointMake(0, 0))
        currentLocus.ff_AlignInner(ff_AlignType.BottomCenter, referView: headerView, size: nil, offset: CGPointMake(-30, -5))
        enterButton.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: currentLocus, size: nil, offset: CGPointMake(0, 0))
    }
    
    
    /// 发送搜索信息
    private func loadSearchData() {
        
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = HomeSearchCityRequest()
        }
        
        lastSuccessAddRequest?.fetchFeedBackModels {[unowned self] (handler: NSDictionary) -> Void in
            self.dataSource = handler
            
            if self.searchLabel.count == 0 {
                for lab in handler.objectForKey("labels") as! NSArray {
                    let labM = lab as! SearchLabel
                    
                    var label: String = ""
                    label = lab.name + "    " + labM.num!
                    self.searchLabel.addObject(label)
                    self.searchLabelTags.addObject(labM.id!)
                }
                self.addSearchTitleButton()
            }
            
            self.iconView.sd_setImageWithURL(NSURL(string: handler.objectForKey("image") as! String))
            self.tableView.reloadData()
        }
    }
    
    ///  触发搜索列表的方法
    func searchTitleMethod(btn: UIButton) {
        
        btn.selected = true
        tempButton?.selected = false
        tempButton = btn
        
        lastSuccessAddRequest!.label = String(btn.tag)
        loadSearchData()
    }
    
    // MARK: - tableView 数据源及代理方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource != nil {
            return dataSource!.objectForKey("datas")!.count!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchListTableView_Cell", forIndexPath: indexPath) as! SearchListTableViewCell
        
        let array = dataSource!.objectForKey("datas") as! NSArray
        cell.backgroundColor = UIColor.clearColor()
        cell.data = array[indexPath.row] as? SearchData
        
        return cell
    }
}

