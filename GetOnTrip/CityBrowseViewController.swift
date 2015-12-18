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
    
    var tableView = UITableView()
    
    /// 网络请求加载数据(添加)
    var lastRequest: CityBrowseRequest = CityBrowseRequest()
    
    var dataSource: [AnyObject]? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = UIColor.randomColor()
        initProperty()
    }
    
    private func initProperty() {
        title = "消息"
        automaticallyAdjustsScrollViewInsets = false
        navBar.setTitle(CityBrowseViewController.name)
        
        view.backgroundColor = SceneColor.bgBlack
        view.addSubview(tableView)
        

        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = .randomColor()
        lastRequest.fetchNextPageModels { (_, _) -> Void in
            
        }
    }

    // MARK: - tableview delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataSource.count
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
//        cell.data = dataSource[indexPath.row]
        
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
