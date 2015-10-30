//
//  SightOtherViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

public let HistoryTableViewControllerElseCell : String = "History_Cell"

class SightOtherViewController: UITableViewController {

    var lastOtherRequest = SightTopicRequest()
    
    /// 是否正在加载中
    var isLoading:Bool = false

    var sightId: String = "" {
        didSet {
            lastOtherRequest.sightId = sightId
        }
    }
    
    var tagId: String = ""{
        didSet {
            lastOtherRequest.tag = tagId
        }
    }
    
    var dataSource: NSMutableArray = NSMutableArray() {
        didSet {
            tableView.header.endRefreshing()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(TopicCell.self, forCellReuseIdentifier : HistoryTableViewControllerElseCell)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let header = MJRefreshNormalHeader { () -> Void in self.refresh() }
        tableView.header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in self.loadMore() })
        
        footer.automaticallyHidden = false
        footer.automaticallyChangeAlpha = true
        footer.automaticallyRefresh = true
        tableView.footer = footer
        tableView.footer.automaticallyHidden = true
        if !tableView.header.isRefreshing() {
            tableView.header.beginRefreshing()
        }
    }
    
    // MARK: - 刷新方法
    func refresh() {
        if self.isLoading {
            return
        }
        
        self.isLoading = true
        lastOtherRequest.fetchFirstPageModels({ [weak self] (data, status) -> Void in
            if status == RetCode.SUCCESS {
                self!.tableView.header.endRefreshing()
            } else {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
            }
            self!.isLoading = false
            if let s = data {
                if s["sightDatas"]!.count > 0 {
                    self!.dataSource = NSMutableArray(array:s["sightDatas"]?.copy() as! [AnyObject])
                    self?.tableView.reloadData()
                }
            }
            })
    }
    
    // MARK: - tableview 数据源及代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerElseCell, forIndexPath: indexPath) as! TopicCell
        
        cell.topicCellData = dataSource[indexPath.row] as? TopicCellData
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc: TopicDetailController = TopicDetailController()
        let dataI = dataSource[indexPath.row] as! TopicCellData
        vc.topicId = dataI.id
        vc.sightName = dataI.title
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
            
            lastOtherRequest.fetchNextPageModels({ (nextData, status) -> Void in
                
                if status == RetCode.SUCCESS {
                    if nextData != nil {
                        let s = nextData! as [String : AnyObject]
                        if s["sightDatas"]!.count > 0 {
                            self.dataSource.addObjectsFromArray(NSMutableArray(array:s["sightDatas"] as! [AnyObject]) as [AnyObject])
                            self.tableView.reloadData()
                            self.tableView.footer.endRefreshing()
                        } else {
                            self.tableView.footer.endRefreshingWithNoMoreData()
                            UIView.animateWithDuration(2, animations: { () -> Void in
                                self.tableView.footer.alpha = 0.0
                                }, completion: { (_) -> Void in
                                    self.tableView.footer.resetNoMoreData()
                            })
                        }
                    } else {
                        self.isLoading = false
                    }
                    
                } else {
                    SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                    return
                }
            })

    }

}
