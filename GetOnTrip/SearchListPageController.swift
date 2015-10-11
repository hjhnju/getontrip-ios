//
//  SearchListPageController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class SearchListPageController: MainViewController, UITableViewDataSource, UITableViewDelegate {
    
    /// 数据源
    var dataSource: NSDictionary?
    
    // 搜索标签文本列表
    var searchLabels: NSMutableArray    = NSMutableArray()
    
    // 搜索标签id列表
    var searchLabelIds: NSMutableArray = NSMutableArray()
    
    /// 底部的tableView
    lazy var tableView = UITableView()
    
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: HomeSearchCityRequest?
    
    /// 搜索顶部
    var headerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 244))
    
    /// 搜索顶部图片
    var iconView = UIImageView(image: UIImage(named: "recommend_header"))

    /// 记录状态按钮
    var currentSearchLabelButton: UIButton?
    
    // MARK: - 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SceneColor.homeGrey
        
        headerView.addSubview(iconView)
        headerView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 244)
        
        addTableViewProperty()
        loadSearchData()
        setupAutoLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    ///  添加tableview相关属性
    private func addTableViewProperty() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.tableHeaderView = headerView
        tableView.registerClass(SearchListTableViewCell.self, forCellReuseIdentifier: "SearchListTableView_Cell")
        tableView.rowHeight = 190
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    /// 发送搜索信息
    private func loadSearchData() {
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = HomeSearchCityRequest()
        }
        
        lastSuccessAddRequest?.fetchFeedBackModels {[unowned self] (handler: NSDictionary) -> Void in
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
            self.iconView.sd_setImageWithURL(NSURL(string: handler.objectForKey("image") as! String), placeholderImage: UIImage(named: "recommend_header"))
            self.tableView.reloadData()
        }
    }
    
    ///  添加搜索标签按钮
    private func addSearchLabelButton() {
        //参数
        let btnWidth:CGFloat  = 87
        let btnHeight:CGFloat = 19
        let totalCol:Int      = 2
        
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
            
            let marginX:CGFloat = (headerView.bounds.size.width - btnWidth * CGFloat(totalCol)) / CGFloat(totalCol + 1)
            let marginY:CGFloat = -45
            let btnX:CGFloat    = marginX + (marginX + btnWidth) * CGFloat(col)
            let btnY:CGFloat    = 84 + (marginY + btnWidth) * CGFloat(row)
            
            btn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight)
        }
    }
    
    /// 布局
    private func setupAutoLayout() {
        tableView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height + 64), offset: CGPointMake(0, -64))
        iconView.ff_Fill(headerView)
    }
    
    ///  触发搜索列表的方法
    func clkSearchLabelMethod(btn: UIButton) {
        btn.selected = true
        currentSearchLabelButton?.selected = false
        currentSearchLabelButton = btn
        
        lastSuccessAddRequest!.label = String(btn.tag)
        loadSearchData()
    }
    
    // MASK: - tableView 数据源及代理方法
    
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let array = dataSource!.objectForKey("datas") as! NSArray
        let data = array[indexPath.row] as? SearchData
        
        if (data!.type == "1") {
            let vc = SightListController()
            vc.sightId = data!.id
            addChildViewController(vc)
            view.addSubview(vc.view)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = CityCenterPageController()
            vc.cityName.text = data?.name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

