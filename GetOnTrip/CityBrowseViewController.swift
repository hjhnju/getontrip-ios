//
//  CityBrowseViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
/// 城市一览控制器
class CityBrowseViewController: MenuViewController, UITableViewDataSource, UITableViewDelegate {

    static let name = "城市一览"
    
    /// tableview
    lazy var tableView = UITableView()
    
    /// 网络请求加载数据(添加)
    var lastRequest: CityBrowseRequest = CityBrowseRequest()
    
    /// 总数据源
    var data: CityList = CityList() {
        didSet {
            dataSource = data.cityArray
        }
    }
    
    /// 底部各个城市
    var dataSource: [String : [CityContent]] = [String : [CityContent]]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.randomColor()
        initProperty()
        initTableView()
    }
    
    private func initProperty() {
        title = "消息"
        automaticallyAdjustsScrollViewInsets = false
        navBar.setTitle(CityBrowseViewController.name)
        
        view.backgroundColor = SceneColor.bgBlack
        view.addSubview(tableView)
        

        
    }
    
    private func initTableView() {
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = .randomColor()
        tableView.registerClass(CityBrowseTableViewCell.self, forCellReuseIdentifier: "CityBrowseTableViewCell")
        tableView.ff_AlignInner(.TopCenter, referView: view, size: CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64), offset: CGPointMake(0, 64))
        lastRequest.fetchNextPageModels { (_, _) -> Void in
            
        }
    }

    // MARK: - tableview delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CityBrowseTableViewCell", forIndexPath: indexPath) as! CityBrowseTableViewCell
        let data = dataSource["h"]
        cell.dataSource = data![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    // MARK: - 自定义方法
//    private func loadData() {
//        lastRequest.fetchNextPageModels { (result, <#Int#>) -> Void in
//            <#code#>
//        }
//    }
}
