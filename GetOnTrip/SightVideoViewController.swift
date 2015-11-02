//
//  SightVideoViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

public let HistoryTableViewControllerVideoCell: String = "Video_Cell"

class SightVideoViewController: UITableViewController {

    var lastVideoRequest = SightVideosRequest()
    
    /// 是否正在加载中
    var isLoading:Bool = false

    var sightId: String = "" {
        didSet {
            lastVideoRequest.sightId = sightId
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
        
        tableView.registerClass(VideoCell.self, forCellReuseIdentifier : HistoryTableViewControllerVideoCell)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let header = MJRefreshNormalHeader { () -> Void in self.refresh() }
        tableView.header = header
        
        let vc = parentViewController as! SightViewController
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "途知", style: .Plain, target: "", action: "")
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
        self.tableView.footer.resetNoMoreData()
        lastVideoRequest.fetchFirstPageModels({ [weak self] (dataSource, status) -> Void in
            if status == RetCode.SUCCESS {
                self!.tableView.header.endRefreshing()
            } else {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
            }
            self!.isLoading = false
            if let data = dataSource {
                self?.dataSource = NSMutableArray(array: data)
            }
            })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if dataSource.count != 0 {
            tableView.header.endRefreshing()
        }
    }
    
    // MARK: - tableview 数据源及代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerVideoCell, forIndexPath: indexPath) as! VideoCell
        cell.watchBtn.addTarget(self, action: "watchClick:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.watchBtn.tag = indexPath.row
        cell.video = dataSource[indexPath.row] as? Video
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = parentViewController //as? UINavigationController
//        let nav = vc?.visibleViewController as? SightViewController
        vc!.navigationItem.backBarButtonItem = UIBarButtonItem(title: "途知", style: .Plain, target: "", action: "")
        
        let sc = DetailWebViewController()
        let dataI = dataSource[indexPath.row] as! Video
        sc.url = dataI.url
        navigationController?.pushViewController(sc, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    /// 底部加载更多
    func loadMore(){
            
            lastVideoRequest.fetchNextPageModels({ (nextData, status) -> Void in
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

    ///  观看视频跳转方法
    ///
    ///  - parameter btn: 观看视频的按钮
    func watchClick(btn: UIButton) {
        
        let sc = DetailWebViewController()
        let dataI = dataSource[btn.tag] as! Video
        sc.url = dataI.url
        navigationController?.pushViewController(sc, animated: true)
    }

}
