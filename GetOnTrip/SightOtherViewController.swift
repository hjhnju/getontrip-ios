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
        refresh()
    }
    
    
    
    // MARK: - 刷新方法
    func refresh() {
//        if !tableView.header.isRefreshing() {
//            return
//        }
        
        self.isLoading = true
        lastOtherRequest.fetchFirstPageModels({ [weak self] (dataS, status) -> Void in
            if status == RetCode.SUCCESS {
                let s = dataS! as [String : AnyObject]
                if s["sightDatas"]!.count > 0 {
                    self!.dataSource = NSMutableArray(array:s["sightDatas"]?.copy() as! [AnyObject])
                    self?.tableView.reloadData()
                }
            } else {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                self?.tableView.header.endRefreshing()
                self?.isLoading = false
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
//                            if ((self.delegate?.respondsToSelector("collectionViewCellCache::")) != nil) {
//                                self.delegate?.collectionViewCellCache(self.data, type: self.tagId)
//                            }
                            self.tableView.reloadData()
                            self.tableView.footer.endRefreshing()
                        } else {
                            self.tableView.footer.endRefreshingWithNoMoreData()
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
