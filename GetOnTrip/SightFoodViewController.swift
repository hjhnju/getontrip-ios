//
//  SightFoodViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/18.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh

public let HistoryTableViewControllerFoodCell : String = "SightFoodViewController"

class SightFoodViewController: BaseTableViewController {

    var lastRequest:SightFoodRequest = SightFoodRequest()
    
    /// 是否正在加载中
    var isLoading:Bool = false
    
    var tagData:Tag = Tag(id: "")
    
    var data = [Food]()
    
    var sightId = "" {
        didSet {
            lastRequest.sightId = sightId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(FoodCell.self, forCellReuseIdentifier : HistoryTableViewControllerFoodCell)
        tableView.separatorStyle = .None
        
        let tbHeaderView = MJRefreshNormalHeader { [weak self]  () -> Void in self?.refresh() }
        tableView.mj_header = tbHeaderView
        
        tbHeaderView.automaticallyChangeAlpha = true
        tbHeaderView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        tbHeaderView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbHeaderView.lastUpdatedTimeLabel?.font = UIFont.systemFontOfSize(11)
        tbHeaderView.stateLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.hidden = true
        tbHeaderView.stateLabel?.hidden = true
        tbHeaderView.arrowView?.image = UIImage()
        
        let tbFooterView = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] () -> Void in self?.loadMore() })
        tableView.mj_footer = tbFooterView
        tbFooterView.automaticallyHidden = false
        tbFooterView.automaticallyRefresh = true
        tbFooterView.automaticallyChangeAlpha = true
        tbFooterView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        tbFooterView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbFooterView.stateLabel?.textColor = SceneColor.lightGray
        
        if data.count == 0 {
            refresh()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - 刷新方法
    func refresh() {
        if self.isLoading {
            return
        }
                
        self.isLoading = true
        lastRequest.fetchFirstPageModels({ [weak self] (topics, status) -> Void in
            if status != RetCode.SUCCESS {
                ProgressHUD.showErrorHUD(self?.view, text: MessageInfo.NetworkError)
            }
            if let topics = topics {
                self?.data = topics
                self?.tableView.reloadData()
                self?.tableView.mj_footer.endRefreshing()
            }
            self?.isLoading = false
            self?.tableView.mj_header.endRefreshing()
            })
    }
    
    // MARK: - tableview 数据源及代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerFoodCell, forIndexPath: indexPath) as! FoodCell
        cell.data = data[indexPath.row]
        cell.baseLine.hidden = indexPath.row == data.count - 1 ? true : false
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc: FoodDetailViewController = FoodDetailViewController()
        vc.foodId = data[indexPath.row].id
//        vc.isEntranceSight = true
//        let topic = data[indexPath.row]
//        vc.topicDataSource = Topic.fromBrief(topic)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    /// 底部加载更多
    func loadMore(){
        lastRequest.fetchNextPageModels({ (topics, status) -> Void in
            if status != RetCode.SUCCESS {
                ProgressHUD.showErrorHUD(self.view, text: "您的网络不给力！")
                self.tableView.mj_footer.endRefreshing()
                return
            }
            
            if let topics = topics {
                if topics.count > 0 {
                    self.data += topics
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
