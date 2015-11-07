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

class SightTopicViewController: UITableViewController {

    var lastRequest:SightTopicsRequest?
    
    var cellId: Int = 0
    
    /// 是否正在加载中
    var isLoading:Bool = false
    
    var tagData:Tag = Tag(id: "")
    
    var topics = [TopicBrief]() {
        didSet {
            let vc = parentViewController as? SightViewController
            vc?.collectionViewCellCache[cellId] = topics
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(TopicCell.self, forCellReuseIdentifier : HistoryTableViewControllerElseCell)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let header = MJRefreshNormalHeader { () -> Void in self.refresh() }
        // TODO: - 如果要集成使用下面这段代码即可
//        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
//        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
//                self?.tableView.dg_stopLoading()
//            })
//            }, loadingView: loadingView)
//        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
//        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
//        header.hidden = true
        
        tableView.mj_header = header
        
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in self.loadMore() })
        
        footer.automaticallyHidden = false
        footer.automaticallyChangeAlpha = true
        footer.automaticallyRefresh = true
        tableView.mj_footer = footer
        tableView.mj_footer.automaticallyHidden = true
        if !tableView.mj_header.isRefreshing() {
            tableView.mj_header.beginRefreshing()
        }
    }
    
    deinit {
        //tableView.dg_removePullToRefresh()
    }
    
    // MARK: - 刷新方法
    func refresh() {
        if self.isLoading {
            return
        }
        if lastRequest == nil {
            lastRequest = SightTopicsRequest()
        }
        
        lastRequest?.sightId = tagData.sightId
        lastRequest?.tagId   = tagData.id
        
        self.isLoading = true
        lastRequest?.fetchFirstPageModels({ [weak self] (topics, status) -> Void in
            if status != RetCode.SUCCESS {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
            }
            if let topics = topics {
                self?.topics = topics
                self?.tableView.reloadData()
                self?.tableView.mj_footer.endRefreshing()
            }
            self?.isLoading = false
            self?.tableView.mj_header.endRefreshing()
        })
    }
    
    // MARK: - tableview 数据源及代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerElseCell, forIndexPath: indexPath) as! TopicCell
        cell.data = topics[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc: TopicViewController = TopicViewController()
        let topic = topics[indexPath.row]
        vc.topicDataSource = Topic.fromBrief(topic)
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
        lastRequest?.fetchNextPageModels({ (topics, status) -> Void in
            if status != RetCode.SUCCESS {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                self.tableView.mj_footer.endRefreshing()
                return
            }
            
            if let topics = topics {
                if topics.count > 0 {
                    self.topics += topics
                    self.tableView.reloadData()
                    self.tableView.mj_footer.endRefreshing()
                } else {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    UIView.animateWithDuration(2, animations: { () -> Void in
                        self.tableView.mj_footer.alpha = 0.0
                        }, completion: { (_) -> Void in
                            self.tableView.mj_footer.resetNoMoreData()
                    })
                }
            }
            self.isLoading = false
            
        })

    }

}
