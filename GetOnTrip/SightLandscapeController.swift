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

    var lastLandscapeRequest = LandscapeRequest()
    
    /// 是否正在加载中
    var isLoading:Bool = false

    var sightId: String = "" {
        didSet {
            lastLandscapeRequest.sightId = sightId
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
        
        tableView.registerClass(LandscapeCell.self, forCellReuseIdentifier : HistoryTableViewControllerSightCell)
        tableView.registerClass(LandscapeCell1.self, forCellReuseIdentifier : HistoryTableViewControllerSightCell1)
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
        if isLoading == false {
            if tableView.header.isRefreshing() {
                return
            }
        }
        
        self.isLoading = true
        lastLandscapeRequest.fetchFirstPageModels({ (dataSource, status) -> Void in
            //处理异常状态
            if status == RetCode.SUCCESS {
                self.tableView.header.endRefreshing()
                //                    self.isLoading = false
            } else {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                self.isLoading = false
            }
            
            //处理数据
            if dataSource!.count > 0 {
                self.dataSource = NSMutableArray(array: dataSource!)
            }
            self.tableView.header.endRefreshing()
        })
    }
    
    
    // MARK: - tableview 数据源及代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerSightCell, forIndexPath: indexPath) as! LandscapeCell
            cell.landscape = dataSource[indexPath.row] as? SightLandscape
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerSightCell1, forIndexPath: indexPath) as! LandscapeCell1
            cell.landscape = dataSource[indexPath.row] as? SightLandscape
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sc = DetailWebViewController()
        let landscape = dataSource[indexPath.row] as! SightLandscape
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
                    if nextData != nil {
                        if nextData!.count > 0 {
                            self.dataSource.addObjectsFromArray(nextData! as [AnyObject])
//                            if ((self.delegate?.respondsToSelector("collectionViewCellCache::")) != nil || self.data.count != 0) {
//                                self.delegate?.collectionViewCellCache(self.data, type: self.tagId)
//                                self.tableView.reloadData()
//                            }
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
                
                
                
                //                self.isLoading = false
            })
    }

}
