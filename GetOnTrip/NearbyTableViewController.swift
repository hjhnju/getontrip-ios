//
//  NearbyTableViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/24.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import CoreLocation

class NearbyTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    //MARK: Model and variables
    
    var nearSights = [NearbySight]()
    
    var lastSuccessRequest: NearbyRequest?
    
    var activity:UIActivityIndicatorView!
    
    var scrollLock:Bool = false
    
    var locationManager: CLLocationManager!
    
    //存储属性，保存最近有效定位。作为默认请求数据的参数（//TODO:缓存）
    var lastEffectLocation: CLLocation?
    
    //当前定位
    var curLocation: CLLocation? {
        get {
            return self.lastEffectLocation
        }
        set {
            if let newLocation = newValue {
                self.lastEffectLocation = newLocation
            }
            //无论是否有位置信息，均更新数据
            refresh()
        }
    }

    private struct StoryBoard {
        static let CellReuseIdentifier = "NearbyTableViewCell"
        static let SectionHeaderReuseIdentifier = "SightHeaderView"
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("self=\(self)")
        //移除底部空Cell
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.separatorColor      = UIColor.grayColor()
        tableView.sectionHeaderHeight = CGFloat(165)
        
        //初始化定位服务
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 1000.0 //设备至少移动1000米，才通知委托更新
        self.locationManager.requestWhenInUseAuthorization()
        
        refreshByControl(refreshControl!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func refreshByControl(sender: UIRefreshControl) {
        
        self.refreshControl?.beginRefreshing()
        
        //开始定位
        //println("开始定位")
        self.locationManager.startUpdatingLocation()
    }
    
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        //获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = NearbyRequest(curLocation:self.curLocation, page:1)
        }
        lastSuccessRequest!.fetchModels { (sights:[NearbySight]) -> Void in
            if sights.count > 0 {
                self.nearSights = sights
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                
                //结束定位
                //println("结束定位")
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return nearSights.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Tells the data source to return the number of rows in a given section of a table view. (required)
        return nearSights[section].topics.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.CellReuseIdentifier, forIndexPath: indexPath) as! NearbyTableViewCell
        
        // Configure the cell...
        let sight = nearSights[indexPath.section]
        cell.topicImageUrl = sight.topics[indexPath.row].imageUrl
        cell.subtitle = sight.topics[indexPath.row].subtitle
        cell.title = sight.topics[indexPath.row].title
        cell.favoritesValue = sight.topics[indexPath.row].favorites
        cell.descValue = sight.topics[indexPath.row].desc
        cell.scanValue = sight.topics[indexPath.row].scan
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerViewCell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.SectionHeaderReuseIdentifier) as! SightHeaderView
        headerViewCell.sightName = nearSights[section].name
        headerViewCell.sightImageUrl = nearSights[section].imageUrl
        headerViewCell.distanceValue = nearSights[section].distance
        headerViewCell.cityValue = nearSights[section].city
        headerViewCell.descValue = nearSights[section].desc
        //判断当前section是否为最后一个，如果是那么为该section添加footer
        if section == self.nearSights.count - 1{
            loadMore()
        }
        
        return headerViewCell
    }
    
    //解决：去掉UItableview headerview黏性(sticky)
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= tableView.sectionHeaderHeight && scrollView.contentOffset.y >= 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if scrollView.contentOffset.y >= tableView.sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsetsMake(-tableView.sectionHeaderHeight, 0, 0, 0);
        }
        //如果滚动到最底部，那么需要追加内容
        //取出tableview得当前位置
        var offset = self.tableView.contentOffset
        //得到窗体的高度，固定不变，不同iphone会有变化
        var frame = self.tableView.frame
        //self.tableView.contentSize.height 该值是tableview的大小，会越来越大，翻一屏就会怎么一个屏幕的高度
        //如果tableview得当前位置 = tableview大小 - tableview的当前位置的高度，说明已经到达底部，开始触发加载事件
        if offset.y == self.tableView.contentSize.height - frame.size.height{
            if self.scrollLock == false{
                self.scrollLock = true
                loadMoreAction()
            }
        }
    }
    
    //处理列表项的选中事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        var topic = self.nearSights[indexPath.section].topics[indexPath.row]
        
        self.performSegueWithIdentifier(StoryBoardIdentifier.ShowTopicDetailSegue, sender: topic)
        
    }
    
    
    //MARK: Custom funcs
    
    //加载更多按钮，为tableFooterView创建加载元素
    func loadMore(){
        var tableFooterView:UIView = UIView()
        tableFooterView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 44)
        tableFooterView.backgroundColor = UIColor.whiteColor()
        self.tableView.tableFooterView = tableFooterView
        activity = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activity.frame = CGRectMake(0, 0, self.tableView.bounds.width, 44)
        tableFooterView.addSubview(activity)
    }
    
    //触发加载更多事件
    func loadMoreAction(){
        activity.startAnimating()
        var request = NearbyRequest(curLocation:self.curLocation, page:1)
        request.fetchModels { (sights:[NearbySight]) -> Void in
            if sights.count > 0 {
                sleep(1)
                self.nearSights = self.nearSights + sights
                self.activity.stopAnimating()
                self.tableView.tableFooterView = nil
                self.tableView.reloadData()
                self.scrollLock = false
            }
        }
    }
    
    // MARK: CCLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let newLocation = locations.last as? CLLocation
        //NSLog("notice:location.latitude=%@", newLocation?.description ?? "nil")
        
        self.curLocation = newLocation
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        NSLog("error:%@", error.localizedDescription)
        
        self.curLocation = nil
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController{
            destination = navCon.visibleViewController
        }
        if let identifier = segue.identifier {
            switch identifier{
            case StoryBoardIdentifier.ShowTopicDetailSegue:
                if let tdvc = destination as? TopicDetailViewController {
                    tdvc.topic = sender as? Topic
                }
            default:break
            }
        }
    }
}
