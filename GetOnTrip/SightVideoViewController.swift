//
//  SightVideoViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh

public let HistoryTableViewControllerVideoCell: String = "Video_Cell"

class SightVideoViewController: BaseTableViewController {

    var lastVideoRequest = SightVideosRequest()
    
    /// 是否正在加载中
    var isLoading:Bool = false

    var sightId: String = "" {
        didSet {
            lastVideoRequest.sightId = sightId
        }
    }
    
    var dataSource = [Video]() {
        didSet {
            tableView.mj_header.endRefreshing()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(VideoCell.self, forCellReuseIdentifier : HistoryTableViewControllerVideoCell)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let tbHeaderView = MJRefreshNormalHeader { () -> Void in self.refresh() }
        
        print(presentationController)
        print(parentViewController)
        print(presentedViewController)
        print(presentingViewController)
        let vc = parentViewController as? SightViewController
        
        vc?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "途知", style: .Plain, target: "", action: "")
        let tbFooterView = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] () -> Void in self?.loadMore() })

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
        
        tableView.mj_footer = tbFooterView
        tbFooterView.automaticallyHidden = false
        tbFooterView.automaticallyRefresh = true
        tbFooterView.automaticallyChangeAlpha = true
        tbFooterView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        tbFooterView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbFooterView.stateLabel?.textColor = SceneColor.lightGray
        
        if dataSource.count == 0 {
            refresh()
        }
    }

    // MARK: - 刷新方法
    func refresh() {
        if self.isLoading {
            return
        }
        
        self.isLoading = true
        self.tableView.mj_footer.resetNoMoreData()
        lastVideoRequest.fetchFirstPageModels({ [weak self] (dataSource, status) -> Void in
            if status == RetCode.SUCCESS {
                self!.tableView.mj_header.endRefreshing()
            } else {
                ProgressHUD.showErrorHUD(self!.view, text: MessageInfo.NetworkError)
            }
            self!.isLoading = false
            if let data = dataSource {
                self?.dataSource = data
            }
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
        let cell = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerVideoCell, forIndexPath: indexPath) as! VideoCell
        cell.watchBtn.addTarget(self, action: "watchClick:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.watchBtn.tag = indexPath.row
        cell.video = dataSource[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sc = DetailWebViewController()
        let dataI = dataSource[indexPath.row]
        sc.video = dataI
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
            if status != RetCode.SUCCESS {
                ProgressHUD.showErrorHUD(self.view, text: MessageInfo.NetworkError)
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

    ///  观看视频跳转方法
    ///
    ///  - parameter btn: 观看视频的按钮
    func watchClick(btn: UIButton) {
        let sc = DetailWebViewController()
        let dataI = dataSource[btn.tag]
        sc.video = dataI
        sc.url = dataI.url
        navigationController?.pushViewController(sc, animated: true)
    }
}


