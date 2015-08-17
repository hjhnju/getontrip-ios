//
//  NearbyTableViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/24.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import CoreLocation

class NearbyTableViewController: UITableViewController, CLLocationManagerDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    //MARK: Model and variables
    
    var nearSights = [Sight]()
    
    var lastSuccessRequest: NearbyRequest?
    
    //底部加载
    var activity: UIActivityIndicatorView!
    
    var activityLabel: UILabel!
    
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
    
    //Animations
    let customNavigationAnimationController = CustomNavigationAnimationController()
    let customInteractionController = CustomInteractionController()
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //移除底部空Cell
        tableView.tableFooterView     = UIView(frame: CGRectZero)
        tableView.sectionHeaderHeight = CGFloat(177) //图高+12
        tableView.sectionFooterHeight = CGFloat(12)
        tableView.rowHeight           = CGFloat(117)
        tableView.separatorColor      = UIColor.grayColor()
        tableView.backgroundColor     = SceneColor.lightBlack
        
        //创建footerView, 上拉加载
        var tableFooterView:UIView      = UIView()
        tableFooterView.frame           = CGRectMake(0, 0, tableView.bounds.size.width, 60)
        tableFooterView.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView  = tableFooterView
        activity       = UIActivityIndicatorView(activityIndicatorStyle: .White)
        activity.frame = CGRectMake(0, 0, tableView.bounds.size.width, 44)
        activityLabel = UILabel()
        activityLabel.frame = CGRectMake(0, 44, tableView.bounds.size.width, 10)
        activityLabel.font  = UIFont(name: SceneFont.heiti, size: 10)
        activityLabel.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        activityLabel.textAlignment = NSTextAlignment.Center
        activityLabel.textColor = SceneColor.lightGray
        tableFooterView.addSubview(activity)
        tableFooterView.addSubview(activityLabel)
        
        //初始化定位服务
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 1000.0 //设备至少移动1000米，才通知委托更新
        self.locationManager.requestWhenInUseAuthorization()
        
        refreshByControl(refreshControl!)
        
        //animation
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: Actions

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
            lastSuccessRequest = NearbyRequest(curLocation:self.curLocation)
        }
        lastSuccessRequest!.fetchFirstPageModels { (sights:[Sight]) -> Void in
            if sights.count > 0 {
                self.nearSights = sights
                self.tableView.reloadData()
                
                var formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                var dateString = formatter.stringFromDate(NSDate())
                let message = "最近更新时间:\(dateString)"
                
                self.refreshControl?.attributedTitle = NSAttributedString(string: message, attributes: [NSForegroundColorAttributeName:SceneColor.lightGray])
            } else {
                self.activityLabel.text = "无法获取附近内容，请检查您的网络"
            }
            
            
            self.refreshControl?.endRefreshing()
            //结束定位
            //println("结束定位")
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    //底部加载更多
    func loadMore(){
        if scrollLock == true {
            return
        }
        
        scrollLock = true
        
        self.activityLabel.text = "正在加载更多内容"
        activity.startAnimating()
        self.lastSuccessRequest?.fetchNextPageModels { (sights:[Sight]) -> Void in
            if sights.count > 0 {
                self.nearSights = self.nearSights + sights
                self.tableView.reloadData()
                self.activityLabel.text = ""
            } else {
                self.activityLabel.text = "附近没有更多内容啦"
            }
            self.activity.stopAnimating()
            self.scrollLock = false
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
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.NearbyTableViewCellID, forIndexPath: indexPath) as! NearbyTableViewCell
        
        // Configure the cell...
        let sight = nearSights[indexPath.section]
        cell.topicImageUrl = sight.topics[indexPath.row].imageUrl
        cell.subtitle = sight.topics[indexPath.row].subtitle
        cell.title = sight.topics[indexPath.row].title
        cell.favorites = sight.topics[indexPath.row].favorites
        cell.desc = sight.topics[indexPath.row].desc
        cell.visits = sight.topics[indexPath.row].visits
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerViewCell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.NearbyHeaderViewID) as! SightHeaderView
        headerViewCell.sightName = nearSights[section].name
        headerViewCell.sightImageUrl = nearSights[section].imageUrl
        headerViewCell.distanceValue = nearSights[section].distance
        headerViewCell.cityValue = nearSights[section].city
        headerViewCell.descValue = nearSights[section].desc
        headerViewCell.backgroundColor = UIColor.clearColor()

        return headerViewCell
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 8))
        footerView.backgroundColor = UIColor.clearColor()

        return footerView
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //解决：去掉UItableview headerview黏性(sticky)
        var offSet = scrollView.contentOffset
        if offSet.y <= tableView.sectionHeaderHeight && offSet.y >= 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-offSet.y, 0, 0, 0);
        } else if offSet.y >= tableView.sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsetsMake(-tableView.sectionHeaderHeight, 0, 0, 0);
        }
        
        //如果滚动到最底部，那么需要追加内容
        let yOffSet = scrollView.contentSize.height - scrollView.frame.size.height
        if yOffSet > 0 && offSet.y > yOffSet {
            loadMore()
        }
    }
    
    //处理列表项的选中事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        var topic = self.nearSights[indexPath.section].topics[indexPath.row]
        
        self.performSegueWithIdentifier(StoryBoardIdentifier.ShowTopicDetailSegue, sender: topic)
        
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
    
    
    @IBAction func showSightView(sender: UIButton) {
        performSegueWithIdentifier(StoryBoardIdentifier.ShowSightTopicsSegue, sender: sender)
    }
    
    // MARK: NavigationDelegate
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .Push {
            customInteractionController.attachToViewController(toVC)
        }
        customNavigationAnimationController.reverse = operation == .Pop
        return customNavigationAnimationController
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return customInteractionController.transitionInProgress ? customInteractionController : nil
    }
}
