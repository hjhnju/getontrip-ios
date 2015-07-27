//
//  NearbyTableViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/24.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class NearbyTableViewController: UITableViewController {
    
    //MARK: Model and variables
     
    var nearSights = [NearbySight]()
    
    var lastSuccessRequest: NearbyRequest?
    
    private struct StoryBoard {
        static let CellReuseIdentifier = "NearbyTableViewCell"
        static let SectionHeaderReuseIdentifier = "SightHeaderView"
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        
        //移除底部空Cell
        tableView.tableFooterView = UIView(frame:CGRectZero)
        //tableView.backgroundColor = UIColor.lightGrayColor()
        tableView.separatorColor      = UIColor.grayColor()
        tableView.sectionHeaderHeight = CGFloat(165)
    }
    
    private func refresh(){
        if let refresh = refreshControl {
            refreshByControl(refresh)
        }
    }

    @IBAction func refreshByControl(sender: UIRefreshControl) {
        sender.beginRefreshing()
        
        //获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = NearbyRequest(gps:10, count:3)
        }
        lastSuccessRequest!.fetchModels { (sights:[NearbySight]) -> Void in
            //调用的是异步API，需回到主线程执行
            dispatch_sync(dispatch_get_main_queue()) { () -> Void in
                if sights.count > 0 {
                    self.nearSights = sights
                    self.tableView.reloadData()
                    sender.endRefreshing()
                }
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
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerViewCell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.SectionHeaderReuseIdentifier) as! SightHeaderView
        headerViewCell.sightName = nearSights[section].name
        headerViewCell.sightImageUrl = nearSights[section].imageUrl
        
        return headerViewCell
    }
    
    //解决：去掉UItableview headerview黏性(sticky)
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= tableView.sectionHeaderHeight && scrollView.contentOffset.y >= 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if scrollView.contentOffset.y >= tableView.sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsetsMake(-tableView.sectionHeaderHeight, 0, 0, 0);
        }
    }
    
    //处理列表项的选中事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        var topic = self.nearSights[indexPath.section].topics[indexPath.row]
    
        self.performSegueWithIdentifier("TopicDetailViewSegue", sender: topic)
    
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController{
            destination = navCon.visibleViewController
        }
        if let identifier = segue.identifier {
            switch identifier{
            case "TopicDetailViewSegue":
                if let tdvc = destination as? TopicDetailViewController {
                    tdvc.topic = sender as? Topic
                }
            default:break
            }
        }
    }
}
