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
    lazy var lastRequest: CityBrowseRequest = CityBrowseRequest()
    
    /// 定位城市
    lazy var locationButton: UIButton = UIButton(image: "location_city", title: " 即刻定位当前城市", fontSize: 12, titleColor: SceneColor.frontBlack, fontName: Font.PingFangSCLight)
    
    /// 数据源
    var dataSource: CityList = CityList() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var hotCityDataSource: HotCityAndCurrentCity = HotCityAndCurrentCity() {
        didSet {
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 1)], withRowAnimation: .None)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        tableView.registerClass(HotCityTableViewCell.self, forCellReuseIdentifier: "HotCityTableViewCell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }

    // MARK: - tableview delegate
    /// 组数量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.values.count + 3
    }
    
    /// 每组cell数量
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 { return 1 }
        else if section == 2 { return 0 }
        return dataSource.values[section - 3].count
    }
    
    /// 组标题
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "当前城市" }
        else if section == 1 { return "热门城市" }
        else if section == 2 { return "开通城市" }
        return dataSource.keys[section - 3] ?? ""
    }
    
    /// 每个cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 { return getCurrentCityGroupCell(indexPath) }
        if indexPath.section == 1 {
            if hotCityDataSource.hotCity.count != 0 {
               return getHotCityGroupCell(indexPath)
            }
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("CityBrowseTableViewCell", forIndexPath: indexPath) as! CityBrowseTableViewCell
        cell.backgroundColor = UIColor.randomColor()
        if indexPath.section > 2 {
            let data = dataSource.values[indexPath.section - 3]
            cell.dataSource = data[indexPath.row]
        }
        return cell
    }
    
    /// 第零组cell内容
    private func getCurrentCityGroupCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        cell.addSubview(locationButton)
        locationButton.ff_AlignInner(.CenterCenter, referView: cell, size: nil)
        cell.getShadowWithView()
        return cell
    }
    
    /// 第一组cell内容
    private func getHotCityGroupCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HotCityTableViewCell") as! HotCityTableViewCell
        cell.dataSource
        return UITableViewCell()
    }
    
    /// 行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 0 { return 247 }
        return 43
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 43
    }
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 2 { return 200 }
//        return 43
//    }
//    
//    /// 预估行高
//    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return 43
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        var keys = ["", "", ""]
        keys.appendContentsOf(dataSource.keys)
        return keys
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
        
        lastRequest.fetchHotCityModels { [weak self] (result, status) -> Void in
            if RetCode.SUCCESS == status {
                if let data = result {
                    self?.hotCityDataSource = data
                }
            } else {
                ProgressHUD.showErrorHUD(nil, text: "您的网络无法连接")
            }
        }
    }
}
