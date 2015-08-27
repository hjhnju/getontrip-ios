//
//  TopicDetailListController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/19.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import SDWebImage

class TopicDetailListController: UITableViewController {
    
    // 网络请求，加载数据
    var lastSuccessRequest: TopicRequest?
    
    var sightId: Int?
    
    var nearTopics = [TopicDetails]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
        
        refresh()
    }
    
    // MARK: 加载更新数据
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        // 获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = TopicRequest(sightId: sightId!, order: nil, tags: nil)
        }
        
        lastSuccessRequest!.fetchTopicPageModels { (handler: [TopicDetails]) -> Void in
//            print(handler)
            if handler.count > 0 {
                self.nearTopics = handler
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: 话题列表页数据源方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearTopics.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("topicDetailListCell", forIndexPath: indexPath) as! TopicDetailsCell
        cell.topicModel = nearTopics[indexPath.row]
//        self.tableView.reloadData()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
//        navigationController?.pushViewController(TopicDetailController(sightId: sightId!), animated: true)
//        self.performSegueWithIdentifier("topicDetailWebView", sender: sightId)
    }
//   segue.destinationViewController 
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "topicDetailWebView" {
//            var sightTopicsVC = segue.destinationViewController as! TopicDetailController
//            sightTopicsVC.sightId = sightId!
//        }
//    }
    
}
