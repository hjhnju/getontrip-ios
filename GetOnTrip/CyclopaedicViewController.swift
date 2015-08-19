//
//  CyclopaedicViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/18.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import Foundation

class CyclopaedicViewController: UITableViewController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    //MARK: Model and variables
    
    var nearSights = [Sight]()
    
    var lastSuccessRequest: NearbyRequest?
    
    var sightId: Int?
    
    //底部加载
    var activity: UIActivityIndicatorView!
    
    var activityLabel: UILabel!
    
    var scrollLock:Bool = false
    
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
        
//        refreshByControl(refreshControl!)
        
        //animation
        navigationController?.delegate = self
//        lastSuccessRequest?.fetchCyclopaedicPageModels()
        
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
    }
    
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        //获取数据更新tableview

//        lastSuccessRequest!.fetchCyclopaedicPageModels(<#sightId: Int#>)
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
        }
    }
    
    //底部加载更多
    func loadMore(){
        if scrollLock == true {
            return
        }
        
        scrollLock = true
        
        //        self.activityLabel.text = "正在加载更多内容"
        //        activity.startAnimating()
        
        
        self.lastSuccessRequest?.fetchNextPageModels { (sights:[Sight]) -> Void in
            if sights.count > 0 {
                self.nearSights = self.nearSights + sights
                self.tableView.reloadData()
                self.activityLabel.text = ""
            } else {
                self.activityLabel.text = "附近没有更多内容啦"
            }
            //            self.activity.stopAnimating()
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
        
//        sight.topics[indexPath.row].topicid
        
        // 遍历正在显示的cell如果是最后一行，自行加载数据
        for tmpcell in tableView.visibleCells()
        {
            if (tmpcell as! NearbyTableViewCell != cell) {
                loadMore()
            }
        }
        
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

    
    /*
    * 更改追加内容位置
    */
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //解决：去掉UItableview headerview黏性(sticky)
        var offSet = scrollView.contentOffset
        if offSet.y <= tableView.sectionHeaderHeight && offSet.y >= 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-offSet.y, 0, 0, 0);
        } else if offSet.y >= tableView.sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsetsMake(-tableView.sectionHeaderHeight, 0, 0, 0);
        }
        
        //        如果滚动到最底部，那么需要追加内容
        //        let yOffSet = scrollView.contentSize.height - scrollView.frame.size.height
        //        if yOffSet > 0 && offSet.y > yOffSet {
        //            loadMore()
        //        }
    }
    
    //处理列表项的选中事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        var topic = self.nearSights[indexPath.section].topics[indexPath.row]
        
//        var post     = [String:String]()
//        post["topicId"] = String(stringInterpolationSegment: topic.topicid.value)
//        post["deviceId"] = String("27")
//        HttpRequest.ajax(AppIni.BaseUri, path: "/api/topic/detail",
//            post: post,
//            handler: {(respData: JSON) -> Void in
//            print("\(respData)")
//            print("=================")
//        })
        
        
        
        
        
        
        self.performSegueWithIdentifier(StoryBoardIdentifier.ShowTopicDetailSegue, sender: topic)
        
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
