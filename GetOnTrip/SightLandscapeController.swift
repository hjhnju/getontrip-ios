//
//  SightLandscapeController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh

public let HistoryTableViewControllerSightCell: String = "Landscape_Cell"
public let HistoryTableViewControllerSightCell1:String = "History_Cell1"

class SightLandscapeController: BaseTableViewController {

    /// 请求
    var lastRequest = SightLandscapesRequest()
    /// 是否正在加载中
    var isLoading:Bool = false
    /// 景点id
    var sightId: String = "" {
        didSet {
            lastRequest.sightId = sightId
        }
    }
    /// 数据源
    var dataSource = [Landscape]() {
        didSet {
            tableView.mj_header.endRefreshing()
            tableView.reloadData()
            
            var audios = [String]()
            for item in dataSource { audios.append(item.audio) }
            PlayFrequency.sharePlayFrequency.dataSource = audios
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(LandscapeCell.self, forCellReuseIdentifier : HistoryTableViewControllerSightCell)
        tableView.registerClass(LandscapeCellHead.self, forCellReuseIdentifier : HistoryTableViewControllerSightCell1)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let tbHeaderView = MJRefreshNormalHeader { () -> Void in self.refresh() }
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
        
        let tbFooterView = MJRefreshAutoNormalFooter(refreshingBlock: { self.loadMore() })
        tableView.mj_footer = tbFooterView
        tbFooterView.automaticallyHidden = false
        tbFooterView.automaticallyRefresh = true
        tbFooterView.automaticallyChangeAlpha = true
        tbFooterView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        tbFooterView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbFooterView.stateLabel?.textColor = SceneColor.lightGray
        
        refresh()
    }
    
    // MARK: - 刷新方法
    func refresh() {
        if self.isLoading {
            return
        }
        
        self.isLoading = true
        lastRequest.fetchFirstPageModels({ (dataSource, status) -> Void in
            //处理异常状态
            if status != RetCode.SUCCESS {
                ProgressHUD.showErrorHUD(self.view, text: MessageInfo.NetworkError)
            }
            //处理数据
            if let data = dataSource {
                if data.count > 0 {
                    self.dataSource = data
                }
            }
            self.tableView.mj_header.endRefreshing()
            self.isLoading = false
        })
    }
    
    // MARK: - tableview 数据源及代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: LandscapeCell = indexPath.row == 0 ? tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerSightCell1,
            forIndexPath: indexPath) as! LandscapeCellHead : tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerSightCell,
                forIndexPath: indexPath) as! LandscapeCell
//        cell.playAreaButton.tag = indexPath.row
//        cell.superNavigation = navigationController
        cell.landscape = dataSource[indexPath.row]
        cell.baseLine.hidden = indexPath.row == dataSource.count - 1 ? true : false
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let sc = DetailWebViewController()
//        let landscape = dataSource[indexPath.row]
//        sc.url = landscape.url
//        sc.title = landscape.name
        
        let vc = SightDetailViewController()
        vc.dataSource = dataSource[indexPath.row]
        vc.index = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? 169 : 115
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 115
    }
    
    /// 底部加载更多
    func loadMore(){
        lastRequest.fetchNextPageModels({ (nextData, status) -> Void in
            if status == RetCode.SUCCESS {
                
                if let data = nextData {
                    if data.count > 0 {
                        self.dataSource = self.dataSource + data
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
            } else {
                ProgressHUD.showErrorHUD(self.view, text: MessageInfo.NetworkError)
                return
            }
        })
    }
}
