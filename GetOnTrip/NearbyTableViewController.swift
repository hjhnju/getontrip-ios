//
//  NearbyTableViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/24.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import CoreLocation
import MJRefresh

class NearbyTableViewController: UITableViewController, CLLocationManagerDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    //MARK: Model and variables
    var nearSights = [Sight]()
    
    var lastSuccessRequest: NearbyRequest?
    
    //底部加载
    var activity: UIActivityIndicatorView!
    
    var activityLabel: UILabel!
    
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
    

    
    //是否正在加载更多
    var isLoadingMore = false
    

    @IBOutlet weak var showCityCenterClick: UIButton!
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
        
        //下拉刷新样式
        refreshControl?.tintColor = SceneColor.lightGray
        
        //上拉刷新
        let footerView = MJRefreshAutoNormalFooter(refreshingBlock: loadMore)
        footerView.automaticallyRefresh                = true
//        footerView.appearencePercentTriggerAutoRefresh = -3
        // TODO: 未校正
        footerView.automaticallyChangeAlpha = true
        footerView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        footerView.stateLabel!.font            = UIFont(name: SceneFont.heiti, size: 12)
        footerView.stateLabel!.textColor       = SceneColor.lightGray
        
        self.tableView.footer = footerView
        
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
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateString = formatter.stringFromDate(NSDate())
                let message = "最后更新:\(dateString)"
                
                self.refreshControl?.attributedTitle = NSAttributedString(string: message, attributes: [NSForegroundColorAttributeName:SceneColor.lightGray])
                
                //设置左侧菜单背景
                if let smvc = self.navigationController?.parentViewController as? SlideMenuViewController {

                    smvc.sideViewController.bgImageUrl = self.nearSights[0].image
                }
            } else {
            }
            
            
            self.refreshControl?.endRefreshing()
            //结束定位
            //println("结束定位")
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    //底部加载更多
    func loadMore(){
        if self.isLoadingMore {
            return
        }
        self.isLoadingMore      = true
        //请求下一页
        self.lastSuccessRequest?.fetchNextPageModels { (sights:[Sight]) -> Void in
            if sights.count > 0 {
                self.nearSights = self.nearSights + sights
                self.tableView.reloadData()
                self.tableView.footer.endRefreshing()
            } else {
                self.tableView.footer.noticeNoMoreData()
            }
            self.isLoadingMore = false
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return nearSights.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearSights[section].topic!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.NearbyTableViewCellID, forIndexPath: indexPath) as! NearbyTableViewCell
        
        // Configure the cell...
        let sight = nearSights[indexPath.section]
        cell.updateCell(sight.topic![indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerViewCell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.NearbyHeaderViewID) as! SightHeaderViewCell
        
        headerViewCell.updateCell(nearSights[section])

        return headerViewCell
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 8))
        footerView.backgroundColor = UIColor.clearColor()

        return footerView
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //解决：去掉UItableview headerview黏性(sticky)
        let offSet = scrollView.contentOffset
        if offSet.y <= tableView.sectionHeaderHeight && offSet.y >= 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-offSet.y, 0, 0, 0);
        } else if offSet.y >= tableView.sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsetsMake(-tableView.sectionHeaderHeight, 0, 0, 0);
        }

    }
    
    //处理列表项的选中事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        let topic = self.nearSights[indexPath.section].topic![indexPath.row]
        
        //使用另一个storyboard
        if let topicDetailViewController = UIStoryboard(name: "TopicDetail", bundle: nil).instantiateViewControllerWithIdentifier(StoryBoardIdentifier.TopicDetailViewControllerID) as? TopicDetailViewController {
            topicDetailViewController.topic = topic 
            self.navigationController?.pushViewController(topicDetailViewController, animated: true)
        }
        
    }
    
    // MARK: CCLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last
        //NSLog("notice:location.latitude=%@", newLocation?.description ?? "nil")
        
        self.curLocation = newLocation
    }

    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        NSLog("error:%@", error.localizedDescription)
        
        self.curLocation = nil
    }
    
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == StoryBoardIdentifier.ShowSightTopicsSegue {
            let nav = segue.destinationViewController as! UINavigationController
            let sightTopicsVC: SightTopicsViewController = nav.visibleViewController as! SightTopicsViewController  // ShowSightTopicsSegue
            sightTopicsVC.sightId = sender as? UIButton
        } else if (segue.identifier == "CityCenterSegue") {
   
            let cityCenterVC = segue.destinationViewController as! CityCenterViewCollection
            cityCenterVC.sightId = sender as? UIButton
        }
        
        
        var destination = segue.destinationViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController!
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
    
    /// 显示城市中间页的方法
    @IBAction func showCityCenterClick(sender: UIButton) {

        performSegueWithIdentifier("CityCenterSegue", sender: sender)

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
