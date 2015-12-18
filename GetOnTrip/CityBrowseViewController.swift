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
    
    /// 数据源
    var dataSource: CityList = CityList() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.randomColor()
        initProperty()
        initTableView()
        loadData()
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
        tableView.rowHeight = 43
//        tableView.ff_AlignInner(.TopCenter, referView: view, size: CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64), offset: CGPointMake(0, 64))
    }

    // MARK: - tableview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.values.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.values[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CityBrowseTableViewCell", forIndexPath: indexPath) as! CityBrowseTableViewCell
        let data = dataSource.values[indexPath.section]
        cell.dataSource = data[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: - 自定义方法
    private func loadData() {
        lastRequest.fetchNextPageModels { [weak self] (result, status) -> Void in
            if status == RetCode.SUCCESS {
                if let data = result {
                    self?.dataSource = data
                }
            } else {
                ProgressHUD.showErrorHUD(nil, text: "您的网络无法连接")
            }
        }
    }
}
