//
//  SightBookViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

public let HistoryTableViewControllerBookCell : String = "Book_Cell"


class SightBookViewController: UITableViewController {

    var lastRequest = SightBooksRequest()
    
    /// 是否正在加载中
    var isLoading:Bool = false

    var sightId: String = "" {
        didSet {
            lastRequest.sightId = sightId
        }
    }
    
    var dataSource = [Book]() {
        didSet {
            tableView.mj_header.endRefreshing()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(BookCell.self, forCellReuseIdentifier : HistoryTableViewControllerBookCell)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let header = MJRefreshNormalHeader { () -> Void in self.refresh() }
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
    
    // MARK: - 刷新方法
    func refresh() {
        if self.isLoading {
            return
        }
        
        self.isLoading = true
        lastRequest.fetchFirstPageModels({ (dataSource, status) -> Void in
            if status != RetCode.SUCCESS {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
            }
            //处理数据
            if let data = dataSource {
                self.dataSource = data
            }
            self.isLoading = false
            self.tableView.mj_header.endRefreshing()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if dataSource.count != 0 {
            tableView.mj_header.endRefreshing()
        }
    }
    
    // MARK: - tableview 数据源及代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerBookCell, forIndexPath: indexPath) as! BookCell
        cell.book = dataSource[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bc = BookViewController()
        let dataI = dataSource[indexPath.row]
        bc.bookId = dataI.id!
        navigationController?.pushViewController(bc, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 172
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 172
    }
    
    /// 底部加载更多
    func loadMore(){
        lastRequest.fetchNextPageModels({ (nextData, status) -> Void in
            if status != RetCode.SUCCESS {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                self.tableView.mj_footer.endRefreshing()
                return 
            }
            if let data = nextData {
                if data.count > 0 {
                    self.dataSource = self.dataSource + data
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
            } else {
                self.isLoading = false
            }
        })
    }

}
