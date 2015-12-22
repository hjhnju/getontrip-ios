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
    
    /// 热门城市高度
    lazy var hotCityHeight: CGFloat = HotCityTableViewCell.hotCityTableViewCellHeightWith(self.hotCityDataSource.count)
    
    /// 国内按钮
    lazy var domesticButton: UIButton = UIButton(title: "国内", fontSize: 14, radius: 3, titleColor: .whiteColor(), fontName: Font.PingFangSCLight)
    
    /// 海外按钮
    lazy var abroadButton: UIButton = UIButton(title: "海外", fontSize: 14, radius: 3, titleColor: .whiteColor(), fontName: Font.PingFangSCLight)
    
    /// 选择国内外背景按钮
    lazy var domesticBackgroundView = UIView(color: UIColor.whiteColor())
    
    /// 数据源
    var dataSource: CityList = CityList() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var hotCityDataSource: [HotCity] = [HotCity]() {
        didSet {
//            tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 1)], withRowAnimation: .None)
            tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperty()
        initTableView()
        initDomesticBackgroundView()
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
        tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        tableView.sectionIndexColor = SceneColor.shallowGrey
        tableView.registerClass(CityBrowseTableViewCell.self, forCellReuseIdentifier: "CityBrowseTableViewCell")
        tableView.registerClass(HotCityTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: "HotCityTableViewHeaderView")
        tableView.registerClass(HotCityTableViewCell.self, forCellReuseIdentifier: "HotCityTableViewCell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    /// 初始化切换国外海外按钮
    private func initDomesticBackgroundView() {
        domesticBackgroundView.addSubview(domesticButton)
        domesticBackgroundView.addSubview(abroadButton)
        domesticBackgroundView.layer.cornerRadius = 5
        domesticBackgroundView.layer.borderWidth = 0.5
        domesticBackgroundView.layer.borderColor = SceneColor.shallowGrey.CGColor
        
        domesticButton.setTitleColor(.whiteColor(), forState: .Normal)
        abroadButton.setTitleColor(.whiteColor(), forState: .Normal)
        domesticButton.setTitleColor(SceneColor.shallowGrey, forState: .Selected)
        abroadButton.setTitleColor(SceneColor.shallowGrey, forState: .Selected)
        abroadButton.selected = true
        domesticButton.enabled = false
        domesticButton.layer.cornerRadius = 5
        abroadButton.layer.cornerRadius = 5
        
        domesticButton.ff_AlignInner(.CenterLeft, referView: domesticBackgroundView, size: CGSizeMake(86, 33))
        abroadButton.ff_AlignInner(.CenterRight, referView: domesticBackgroundView, size: CGSizeMake(86, 33))
        domesticButton.backgroundColor = SceneColor.bgBlack
        abroadButton.backgroundColor = UIColor.clearColor()
        
        domesticButton.addTarget(self, action: "domesticButtonAction:", forControlEvents: .TouchUpInside)
        abroadButton.addTarget(self, action: "domesticButtonAction:", forControlEvents: .TouchUpInside)
        domesticButton.tag = 1
        abroadButton.tag = 0
        
        domesticBackgroundView.bounds = CGRectMake(0, 0, 170, 33)
        domesticBackgroundView.center = CGPointMake(UIScreen.mainScreen().bounds.width * 0.5, 31.5)
    }

    // MARK: - tableview delegate
    /// 组数量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if dataSource.values.count == 0 { return 2 }
        return dataSource.values.count + 3
    }
    
    /// 每组cell数量
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        if section == 0 || section == 2 { return 0 }
        return dataSource.values[section - 3].count
    }
    
    /// 组标题
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let v = UIView(color: SceneColor.greyWhite)
            v.addSubview(domesticBackgroundView)
            return v
        }
        
        let v = tableView.dequeueReusableHeaderFooterViewWithIdentifier("HotCityTableViewHeaderView") as! HotCityTableViewHeaderView
        switch section {
        case 1:
            v.titleLabel.text = "热门城市"
            v.baseline.hidden = true
            return v
        case 2:
            v.titleLabel.text = "开通城市"
            v.baseline.hidden = false
            return v
        default:
            break
        }
        v.baseline.hidden = true
        v.titleLabel.text = dataSource.keys[section - 3] ?? ""
        return v
    }
    
    
    
    /// 每个cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 { return getCurrentCityGroupCell(indexPath) }
        if indexPath.section == 1 {
            if hotCityDataSource.count != 0 {
               return getHotCityGroupCell(indexPath)
            } else {
                return tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
            }
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("CityBrowseTableViewCell", forIndexPath: indexPath) as! CityBrowseTableViewCell
        cell.backgroundColor = UIColor.whiteColor()
        
        if indexPath.section > 2 {
            let data = dataSource.values[indexPath.section - 3]
            cell.dataSource = data[indexPath.row]
            
            if dataSource.values[indexPath.section - 3].count - 1 == indexPath.row {
                cell.baseLine.hidden = true
            } else {
                cell.baseLine.hidden = false
            }
            
        }
        cell.clipsToBounds = false
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
        cell.superController = self
        cell.dataSource = hotCityDataSource
        return cell
    }
    
    /// 行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return hotCityDataSource.count != 0 ? hotCityHeight : 0
        }
        return 43
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 43
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 63 - 15
        }
        return 43
    }
    
    /// 预估行高
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 63 - 15
        }
        return 43
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section > 2 {
            let data = dataSource.values[indexPath.section - 3]
            let vc = CityViewController()
            let city = City(id: data[indexPath.row].id)
            vc.cityDataSource = city
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return dataSource.keys
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index + 3
    }
    
    // MARK: - 自定义方法
    private func loadData() {
        lastRequest.fetchNextPageModels { [weak self] (result, status) -> Void in
            self?.refreshHotCityData()
            if status == RetCode.SUCCESS {
                if let data = result {
                    self?.dataSource = data
                }
            } else {
                ProgressHUD.showErrorHUD(nil, text: "您的网络无法连接")
            }
        }
    }
    
    func refreshHotCityData() {
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
    
    func domesticButtonAction(sender: UIButton) {
        lastRequest.type = "\(sender.tag)"
        if sender == abroadButton {
            abroadButton.selected = false
            abroadButton.enabled = false
            domesticButton.selected = true
            domesticButton.enabled = true
        } else {
            domesticButton.selected = false
            domesticButton.enabled = false
            abroadButton.selected = true
            abroadButton.enabled = true
        }
        abroadButton.backgroundColor = abroadButton.selected == false ? SceneColor.bgBlack : .clearColor()
        domesticButton.backgroundColor = abroadButton.selected == true ?  SceneColor.bgBlack : .clearColor()
        hotCityDataSource.removeAll()
        loadData()
    }
}
