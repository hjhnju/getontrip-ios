//
//  SightLandscapeController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

public let HistoryTableViewControllerSightCell: String = "Landscape_Cell"
public let HistoryTableViewControllerSightCell1:String = "History_Cell1"

class SightLandscapeController: UITableViewController {

    var lastLandscapeRequest = SightLandscapesRequest()
    
    /// 是否正在加载中
    var isLoading:Bool = false

    var sightId: String = "" {
        didSet {
            lastLandscapeRequest.sightId = sightId
        }
    }
    
    var dataSource = [Landscape]() {
        didSet {
            tableView.header.endRefreshing()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(LandscapeCell.self, forCellReuseIdentifier : HistoryTableViewControllerSightCell)
        tableView.registerClass(LandscapeCell1.self, forCellReuseIdentifier : HistoryTableViewControllerSightCell1)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let header = MJRefreshNormalHeader { () -> Void in self.refresh() }
        tableView.header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.tableView.footer.alpha = 1.0
            self.loadMore()
        })
        
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
        lastLandscapeRequest.fetchFirstPageModels({ (dataSource, status) -> Void in
            //处理异常状态
            if status != RetCode.SUCCESS {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
            }
            //处理数据
            if let data = dataSource {
                if data.count > 0 {
                    self.dataSource = data
                }
            }
            self.tableView.header.endRefreshing()
            self.isLoading = false
        })
    }
    
    
    
    // MARK: - tableview 数据源及代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerSightCell, forIndexPath: indexPath) as! LandscapeCell
            cell.landscape = dataSource[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerSightCell1, forIndexPath: indexPath) as! LandscapeCell1
            cell.landscape = dataSource[indexPath.row]
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sc = DetailWebViewController()
        let landscape = dataSource[indexPath.row]
        sc.url = landscape.url
        sc.title = landscape.name
        navigationController?.pushViewController(sc, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 115
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 115
    }
    
    /// 底部加载更多
    func loadMore(){
        lastLandscapeRequest.fetchNextPageModels({ (nextData, status) -> Void in
            if status == RetCode.SUCCESS {
                if let data = nextData {
                    if data.count > 0 {
                        self.dataSource = self.dataSource + data
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
