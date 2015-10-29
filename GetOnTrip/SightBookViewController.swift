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

    var lastBookRequest = BookRequest()
    
    /// 是否正在加载中
    var isLoading:Bool = false

    var sightId: String = "" {
        didSet {
            lastBookRequest.sightId = sightId
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
        tableView.registerClass(BookCell.self, forCellReuseIdentifier : HistoryTableViewControllerBookCell)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let header = MJRefreshNormalHeader { () -> Void in self.refresh() }
        tableView.header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in self.loadMore() })
        
        footer.automaticallyHidden = false
        footer.automaticallyChangeAlpha = true
        footer.automaticallyRefresh = true
        tableView.footer = footer
        tableView.footer.automaticallyHidden = true
        refresh()
    }
    
    // MARK: - 刷新方法
    func refresh() {
        if isLoading == false {
            if tableView.header.isRefreshing() {
                return
            }
        }
        
        self.isLoading = true
        lastBookRequest.fetchFirstPageModels({ (dataSource, status) -> Void in
            //处理异常状态
            if RetCode.SUCCESS != status {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                self.isLoading = false
                return
            }
            
            //处理数据
            if dataSource!.count > 0 {
                self.dataSource = NSMutableArray(array: dataSource!)
            }
        })
    }
    
    
    // MARK: - tableview 数据源及代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerBookCell, forIndexPath: indexPath) as! BookCell
        cell.book = dataSource[indexPath.row] as? SightBook
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bc = BookViewController()
        let dataI = dataSource[indexPath.row] as! SightBook
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
            
            lastBookRequest.fetchNextPageModels({ (nextData, status) -> Void in
                if status == RetCode.SUCCESS {
                    if nextData != nil {
                        if nextData!.count > 0 {
                            self.dataSource.addObjectsFromArray(nextData! as [AnyObject])
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
