//
//  CityLandscapeController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/29.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh
import AVFoundation
import CoreLocation

class CityLandscapeController: BaseTableViewController {

    /// 请求
    var lastRequest = CityLandscapeRequest()
    /// 是否正在加载中
    var isLoading:Bool = false
    /// 景点id
    var cityId: String = "" {
        didSet {
            lastRequest.cityId = cityId
            refresh()
        }
    }
    
    var headerCell: LandscapeCellHead?
    var headerButton = UIButton()
    /// 组标题数据源
    var sectionData: Landscape = Landscape()

    /// 数据源
    var dataSource = CityLandscape() {
        didSet {
            data = dataSource.sights
            addTableViewHeaderView()
        }
    }
    
    var data: [Landscape] = [Landscape]() {
        didSet {
            tableView.mj_header.endRefreshing()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
    }

    
    private func initTableView() {
        tableView.registerClass(LandscapeCell.self, forCellReuseIdentifier : HistoryTableViewControllerSightCell)
        tableView.registerClass(LandscapeCellHead.self, forCellReuseIdentifier : HistoryTableViewControllerSightCell1)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let tbHeaderView = MJRefreshNormalHeader { () -> Void in self.refresh() }
        tableView.mj_header = tbHeaderView
        tbHeaderView.automaticallyChangeAlpha = true
        tbHeaderView.activityIndicatorViewStyle = .Gray
        tbHeaderView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbHeaderView.lastUpdatedTimeLabel?.font = UIFont.systemFontOfSize(11)
        tbHeaderView.stateLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.hidden = true
        tbHeaderView.stateLabel?.hidden = true
        tbHeaderView.arrowView?.image = UIImage()
        
        let tbFooterView = MJRefreshAutoNormalFooter(refreshingBlock: { self.loadMore() })
        tableView.mj_footer = tbFooterView
        tbFooterView.automaticallyHidden = false
        tbFooterView.automaticallyRefresh = true
        tbFooterView.automaticallyChangeAlpha = true
        tbFooterView.activityIndicatorViewStyle = .Gray
        tbFooterView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbFooterView.stateLabel?.textColor = SceneColor.lightGray
    }
    
    /// 添加组标题方法
    func addTableViewHeaderView() {
        headerCell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerSightCell1) as? LandscapeCellHead
        let landsc = Landscape()
        landsc.id = dataSource.id
        landsc.name = dataSource.name
        landsc.image = dataSource.image
        landsc.content = dataSource.des
        landsc.dis = dataSource.dis
        landsc.audio = dataSource.audio
        landsc.audio_len = dataSource.audio_len
        landsc.landscape_id = dataSource.landscape_id
        landsc.url = dataSource.url
        headerCell!.superCityViewController = self
        headerCell!.landscape = landsc
        let h: CGFloat = Device.isIPad() ? Frame.screen.width * 0.2296195 : 169
        headerCell!.bounds = CGRectMake(0, 0, Frame.screen.width, h)
        headerCell!.baseLine.hidden = data.count != 0 ? true : false
        headerCell?.addSubview(headerButton)
        let w: CGFloat = dataSource.audio == "" ? Frame.screen.width : 95
        headerButton.frame = CGRectMake(0, 0, w, h)
        headerButton.addTarget(self, action: "cityDetailAction", forControlEvents: .TouchUpInside)
        sectionData = landsc
        tableView.tableHeaderView = headerCell!
        
        var audios = [String]()
        for item in dataSource.sights { audios.append(item.audio) }
        var tempsight = [Landscape]()
        tempsight.append(landsc)
        tempsight.appendContentsOf(dataSource.sights)
        (parentViewController as? CityViewController)?.playController.dataLandscape = tempsight
    }
    
    /// 进入城市详情页方法
    func cityDetailAction() {
        let vc = SightDetailViewController()
        vc.dataSource = sectionData
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /**
     离线刷新地再位置排序
     */
    func refreshLocationAndList() {
        // 景观坐标点
        for item in data {
            item.apartLocation = (LocateToCity.sharedLocateToCity.location ?? CLLocation()).distanceFromLocation(item.location ?? CLLocation())
            if item.apartLocation/1000 > 1 {
                item.dis = "\(Int(item.apartLocation/1000))"
                item.dis_unit = "km"
            } else {
                item.dis = "\(Int(item.apartLocation/100))"
                item.dis_unit = "m"
            }
        }
        data.sortInPlace { (obj1, obj2) -> Bool in
            obj1.apartLocation < obj2.apartLocation
        }
        tableView.reloadData()
    }
    
    
    // MARK: - 刷新方法
    func refresh() {
        if self.isLoading {
            return
        }
        
        self.isLoading = true
        lastRequest.fetchFirstPageModels({ (dataSource, status) -> Void in
            //处理异常状态
            if status != RetCode.SUCCESS {
                ProgressHUD.showErrorHUD(self.view, text: MessageInfo.NetworkError)
            }
            //处理数据
            if let data = dataSource {
                self.dataSource = data
            }
            self.tableView.mj_header.endRefreshing()
            self.isLoading = false
        })
    }
    
    // MARK: - tableview 数据源及代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: LandscapeCell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerSightCell, forIndexPath: indexPath) as! LandscapeCell
        cell.superCityViewController = self
        cell.playAreaButton.tag = indexPath.row + 1
        cell.landscape = data[indexPath.row]
        cell.baseLine.hidden = indexPath.row == data.count - 1 ? true : false
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = SightViewController()
        let da = data[indexPath.row]
        let sight = Sight(id: da.id)
        sight.name = da.name
        sight.image = da.image
        sight.bgColor = da.bgColor
        vc.sightDataSource = sight
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 115
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 115
    }
    
    /// 底部加载更多
    func loadMore(){
        lastRequest.fetchNextPageModels({ (nextData, status) -> Void in
            if status == RetCode.SUCCESS {
                
                if let data = nextData {
                    if data.sights.count > 0 {
                        self.data = self.data + data.sights
                        self.tableView.mj_footer.endRefreshing()
                    } else {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        UIView.animateWithDuration(2, animations: { () -> Void in
                            self.tableView.mj_footer.alpha = 0.0
                            }, completion: { (_) -> Void in
                                self.tableView.mj_footer.resetNoMoreData()
                        })
                    }
                } else {
                    self.isLoading = false
                }
            } else {
                ProgressHUD.showErrorHUD(self.view, text: MessageInfo.NetworkError)
                return
            }
        })
    }
}
