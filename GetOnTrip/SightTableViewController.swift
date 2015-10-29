//
//  HistoryTableViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/3/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

//public let HistoryTableViewControllerSightCell: String = "Landscape_Cell"
//public let HistoryTableViewControllerBookCell : String = "Book_Cell"
//public let HistoryTableViewControllerVideoCell: String = "Video_Cell"
//public let HistoryTableViewControllerElseCell : String = "History_Cell"
//public let HistoryTableViewControllerSightCell1:String = "History_Cell1"

protocol SightTableViewControllerDelegate: NSObjectProtocol {
    func collectionViewCellCache(data: NSArray, type: String)
}

class SightTableViewController: UITableViewController {
    
    weak var delegate: SightTableViewControllerDelegate?
    
    // 网络请求，加载数据
    var lastLandscapeRequest = LandscapeRequest()
    var lastBookRequest = BookRequest()
    var lastVideoRequest = VideoRequest()
    var lastOtherRequest = SightTopicRequest()
    var cellReuseIdentifier: String?
    
    /// 缓存cell
    var cache = [String : NSArray]()
    
    /// 是否正在加载中
//    var isLoading:Bool = false
    
    var type: Int = -1 {
        didSet {
            data.removeAllObjects()
            if type == -1 { return }
                switch type {
                case categoryLabel.sightLabel:
                    cellReuseIdentifier = HistoryTableViewControllerSightCell
                    refresh(categoryLabel.sightLabel)
                case categoryLabel.bookLabel:
                    cellReuseIdentifier = HistoryTableViewControllerBookCell
                    refresh(categoryLabel.bookLabel)
                case categoryLabel.videoLabel:
                    cellReuseIdentifier = HistoryTableViewControllerVideoCell
                    refresh(categoryLabel.videoLabel)
                case categoryLabel.otherLabel:
                    cellReuseIdentifier = HistoryTableViewControllerElseCell
                    refresh(categoryLabel.otherLabel)
                default:
                    cellReuseIdentifier = HistoryTableViewControllerElseCell
                    refresh(categoryLabel.otherLabel)
                    break
                }
//                tableView.header.beginRefreshing()
            }
    }
    
    /// 景点id
    var sightId: String = "" {
        didSet {
            lastLandscapeRequest.sightId = sightId
            lastBookRequest.sightId      = sightId
            lastVideoRequest.sightId     = sightId
            lastOtherRequest.sightId     = sightId
        }
    }
    
     /// tagsId
    var tagId: String = ""{
        didSet {
            lastOtherRequest.tag = tagId
        }
    }
    
    var data: NSMutableArray = NSMutableArray() {
        didSet {
            tableView.header.endRefreshing()
            tableView.reloadData()
        }
    }
    
    // MARK: 加载更新数据
    private func refresh(type: Int) {
        if !tableView.header.isRefreshing() {
            if cache[tagId] != nil {
                data = NSMutableArray(array: cache[tagId]!)
                return
            }
        }
        
        switch type {
        case categoryLabel.sightLabel:
            lastLandscapeRequest.fetchFirstPageModels({ (dataSource, status) -> Void in
                //处理异常状态
                if status != RetCode.SUCCESS {
                    self.tableView.header.endRefreshing()
//                    self.isLoading = false
                } else {
                    SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                }
                
                //处理数据
                if dataSource!.count > 0 {
                    if ((self.delegate?.respondsToSelector("collectionViewCellCache::")) != nil) {
                        self.delegate?.collectionViewCellCache(dataSource!.copy() as! NSArray, type: self.tagId)
                    }
                    self.data = NSMutableArray(array: dataSource!)
                }
                self.tableView.header.endRefreshing()
//                self.isLoading = false
            })
            
        case categoryLabel.bookLabel:
            
            lastBookRequest.fetchFirstPageModels({ (dataSource, status) -> Void in
                //处理异常状态
                if RetCode.SUCCESS != status {
                    SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                    //                    self.isLoading = false
                    return
                }
                
//                self.tableView.header.endRefreshing()
                //处理数据
                if dataSource!.count > 0 {
                    if ((self.delegate?.respondsToSelector("collectionViewCellCache::")) != nil) {
                        self.delegate?.collectionViewCellCache(dataSource!.copy() as! NSArray, type: self.tagId)
                    }
                    self.data = NSMutableArray(array: dataSource!)
                }
//                self.tableView.header.endRefreshing()
//                self.isLoading = false
            })

        case categoryLabel.videoLabel:
            lastVideoRequest.fetchFirstPageModels({ [weak self] (dataSource, status) -> Void in
                if status == RetCode.SUCCESS {
                    if dataSource!.count > 0 {
                        if ((self?.delegate?.respondsToSelector("collectionViewCellCache::")) != nil) {
                            self!.delegate?.collectionViewCellCache(dataSource!.copy() as! NSArray, type: self!.tagId)
                        }
                        self?.data = NSMutableArray(array: dataSource!)
                    }
                }
            })
        case categoryLabel.otherLabel:
            lastOtherRequest.fetchFirstPageModels({ [weak self] (dataS, status) -> Void in
                if status == RetCode.SUCCESS {
                    let s = dataS! as [String : AnyObject]
                    if s["sightDatas"]!.count > 0 {
                        if ((self!.delegate?.respondsToSelector("collectionViewCellCache::")) != nil) {
                            self!.delegate?.collectionViewCellCache(dataS!["sightDatas"] as! NSArray, type: self!.tagId)
                        }
                        self!.data = NSMutableArray(array:s["sightDatas"]?.copy() as! [AnyObject])
                    }
                }
                })
        default:
            lastOtherRequest.fetchFirstPageModels({ [weak self] (dataS, status) -> Void in
                if status == RetCode.SUCCESS {
                    let s = dataS! as [String : AnyObject]
                    if s["sightDatas"]!.count > 0 {
                        if ((self!.delegate?.respondsToSelector("collectionViewCellCache::")) != nil) {
                            self!.delegate?.collectionViewCellCache(dataS!["sightDatas"] as! NSArray, type: self!.tagId)
                        }
                        self!.data = NSMutableArray(array:s["sightDatas"]?.copy() as! [AnyObject])
                    }
                }
                })
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(TopicCell.self,      forCellReuseIdentifier : HistoryTableViewControllerElseCell)
        tableView.registerClass(LandscapeCell.self,  forCellReuseIdentifier : HistoryTableViewControllerSightCell)
        tableView.registerClass(LandscapeCell1.self, forCellReuseIdentifier : HistoryTableViewControllerSightCell1)
        tableView.registerClass(BookCell.self,       forCellReuseIdentifier : HistoryTableViewControllerBookCell)
        tableView.registerClass(VideoCell.self,      forCellReuseIdentifier : HistoryTableViewControllerVideoCell)
        tableView.rowHeight = 115
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        setupRefreshDataAction()
    }
    
    private func setupRefreshDataAction() {
        let header = MJRefreshNormalHeader { () -> Void in self.refresh(self.type) }
        tableView.header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in self.loadMore() })
        
        footer.automaticallyHidden = false
        footer.automaticallyChangeAlpha = true
        footer.automaticallyRefresh = true
        tableView.footer = footer
    }
    
    //  MARK: - tableView 数据源及代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count == 0 ? 0 : data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        switch cellReuseIdentifier! {

        case HistoryTableViewControllerSightCell:
            if indexPath.row == 0 {
                
                let c = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier!, forIndexPath: indexPath) as! LandscapeCell
                c.landscape = data[indexPath.row] as? SightLandscape
                cell = c
                
            } else {
                
                let c = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerSightCell1, forIndexPath: indexPath) as! LandscapeCell1
                c.landscape = data[indexPath.row] as? SightLandscape
                cell = c
            }

        case HistoryTableViewControllerBookCell:
            
            let c = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier!, forIndexPath: indexPath) as! BookCell
            if data != 0 {
                c.book = data[indexPath.row] as? SightBook
            }
            cell = c
        case HistoryTableViewControllerVideoCell:
            let c = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier!, forIndexPath: indexPath) as! VideoCell
            c.watchBtn.addTarget(self, action: "watchClick:", forControlEvents: UIControlEvents.TouchUpInside)
            c.watchBtn.tag = indexPath.row
            c.video = data[indexPath.row] as? SightVideo
            cell = c
            
        case HistoryTableViewControllerElseCell:
            let c = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerElseCell, forIndexPath: indexPath) as! TopicCell
            c.topicCellData = data[indexPath.row] as? TopicCellData
            cell = c
            
        default:
            
            cell = UITableViewCell()
        break
    }
        
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var h: CGFloat?
        switch cellReuseIdentifier! {
        case HistoryTableViewControllerSightCell:
            h = 115
        case HistoryTableViewControllerBookCell:
            h = 172
        case HistoryTableViewControllerVideoCell:
            h = 200
        case HistoryTableViewControllerElseCell:
            h = 115
        default:
            h = 0
            break
        }

        return h!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch cellReuseIdentifier! {
        case HistoryTableViewControllerSightCell:
            
            let sc = DetailWebViewController()
            let landscape = data[indexPath.row] as! SightLandscape
            sc.url = landscape.url
            sc.title = landscape.name
            navigationController?.pushViewController(sc, animated: true)
        case HistoryTableViewControllerBookCell:
            let bc = BookViewController()
            let dataI = data[indexPath.row] as! SightBook
            bc.bookId = dataI.id!
            navigationController?.pushViewController(bc, animated: true)
        case HistoryTableViewControllerVideoCell:
            let sc = DetailWebViewController()
            let dataI = data[indexPath.row] as! SightVideo
            sc.url = dataI.url
            navigationController?.pushViewController(sc, animated: true)
        case HistoryTableViewControllerElseCell:
            let vc: TopicDetailController = TopicDetailController()
            let dataI = data[indexPath.row] as! TopicCellData
            vc.topicId = dataI.id
            vc.sightName = dataI.title
            vc.headerImageUrl = dataI.image
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
    
    func watchClick(btn: UIButton) {
        
        let sc = DetailWebViewController()
        let dataI = data[btn.tag] as! SightVideo
        sc.url = dataI.url
        navigationController?.pushViewController(sc, animated: true)
    }
    
    /// 底部加载更多
    func loadMore(){
        if !tableView.footer.isRefreshing() {
            return
        }
//        self.isLoading = true
        //请求下一页
        switch cellReuseIdentifier! {
        case HistoryTableViewControllerSightCell:
            
            lastLandscapeRequest.fetchNextPageModels({ (nextData, status) -> Void in
                
                if status == RetCode.SUCCESS {
                    if nextData != nil {
                        if nextData!.count > 0 {
                            self.data.addObjectsFromArray(nextData! as [AnyObject])
                            self.tableView.reloadData()
                            if ((self.delegate?.respondsToSelector("collectionViewCellCache::")) != nil) {
                                self.delegate?.collectionViewCellCache(self.data, type: self.tagId)
                            }
                            self.tableView.footer.endRefreshing()
                        } else {
                            self.tableView.footer.endRefreshingWithNoMoreData()
                        }
                    }
                    
                } else {
                    SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                    return
                }
                
                
                
//                self.isLoading = false
            })
            
        case HistoryTableViewControllerBookCell:
            
            lastBookRequest.fetchNextPageModels({ (nextData, status) -> Void in
                if status == RetCode.SUCCESS {
                    if nextData != nil {
                        if nextData!.count > 0 {
                            self.data.addObjectsFromArray(nextData! as [AnyObject])
                            if ((self.delegate?.respondsToSelector("collectionViewCellCache::")) != nil || self.data.count != 0) {
                                self.delegate?.collectionViewCellCache(self.data, type: self.tagId)
                            }
                            self.tableView.reloadData()
                            self.tableView.footer.endRefreshing()
                        } else {
                            self.tableView.footer.endRefreshingWithNoMoreData()
                        }
                    }
                    
                } else {
                    SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                    return
                }
//                self.isLoading = false
            })
            
        case HistoryTableViewControllerVideoCell:
            
            lastVideoRequest.fetchNextPageModels({ (nextData, status) -> Void in
                if status == RetCode.SUCCESS {
                    if nextData != nil {
                        if nextData!.count > 0 {
                            self.data.addObjectsFromArray(nextData! as [AnyObject])
                            if ((self.delegate?.respondsToSelector("collectionViewCellCache::")) != nil || self.data.count != 0) {
                                self.delegate?.collectionViewCellCache(self.data, type: self.tagId)
                            }
                            self.tableView.reloadData()
                            self.tableView.footer.endRefreshing()
                        } else {
                            self.tableView.footer.endRefreshingWithNoMoreData()
                        }
                    }
                    
                } else {
                    SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                    return
                }
//                self.isLoading = false
            })
            
        case HistoryTableViewControllerElseCell, HistoryTableViewControllerSightCell1:
            lastOtherRequest.fetchNextPageModels({ (nextData, status) -> Void in
                
                if status == RetCode.SUCCESS {
                    if nextData != nil {
                        let s = nextData! as [String : AnyObject]
                        if s["sightDatas"]!.count > 0 {
                            self.data.addObjectsFromArray(NSMutableArray(array:s["sightDatas"] as! [AnyObject]) as [AnyObject])
                            if ((self.delegate?.respondsToSelector("collectionViewCellCache::")) != nil) {
                                self.delegate?.collectionViewCellCache(self.data, type: self.tagId)
                            }
                            self.tableView.reloadData()
                            self.tableView.footer.endRefreshing()
                        } else {
                            self.tableView.footer.endRefreshingWithNoMoreData()
                        }
                    }
                    
                } else {
                    SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                    return
                }
                //                self.isLoading = false
            })
            
        default:
            break
        }
    }
    
    /// 网络异常重现加载
    func refreshFromErrorView(sender: UIButton){
        self.tableView.hidden = false
        //重新加载
        if !self.tableView.header.isRefreshing() {
            self.tableView.header.beginRefreshing()
        }
    }
    
}
