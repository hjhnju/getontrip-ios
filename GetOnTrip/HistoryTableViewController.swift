//
//  HistoryTableViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/3/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit

public let HistoryTableViewControllerSightCell: String = "Landscape_Cell"
public let HistoryTableViewControllerBookCell : String = "Book_Cell"
public let HistoryTableViewControllerVideoCell: String = "Video_Cell"
public let HistoryTableViewControllerElseCell : String = "History_Cell"
public let HistoryTableViewControllerSightCell1:String = "History_Cell1"

class HistoryTableViewController: UITableViewController {
    
    // 网络请求，加载数据
    var lastLandscapeRequest = LandscapeRequest()
    
    var lastBookRequest = BookRequest()
    
    var lastVideoRequest = VideoRequest()
    
    var lastOtherRequest = SightListRequest()
    
    var cellReuseIdentifier: String?
    
    var type: Int? {
        didSet {
            data = nil
            
            switch type! {
            case categoryLabel.sightLabel:
                refresh(categoryLabel.sightLabel)
                cellReuseIdentifier = HistoryTableViewControllerSightCell
                
            case categoryLabel.bookLabel:
                refresh(categoryLabel.bookLabel)
                cellReuseIdentifier = HistoryTableViewControllerBookCell
                
            case categoryLabel.videoLabel:
                refresh(categoryLabel.videoLabel)
                cellReuseIdentifier = HistoryTableViewControllerVideoCell
                
            default:
                refresh(0)
                cellReuseIdentifier = HistoryTableViewControllerElseCell
                break
            }
            
        }
    }
    
    /// 景点id
    var sightId: String? {
        didSet {
            lastLandscapeRequest.sightId = sightId
            lastBookRequest.sightId      = sightId
            lastVideoRequest.sightId     = sightId
            lastOtherRequest.sightId     = sightId
        }
    }
    
     /// tagsId
    var tagId: String? {
        didSet {
            lastOtherRequest.tag = tagId!
        }
    }
    
    var data: NSArray? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    // MARK: 加载更新数据
    private func refresh(type: Int) {
        
        switch type {
        case categoryLabel.sightLabel:
            lastLandscapeRequest.fetchSightListModels { [weak self] (handler: NSArray) -> Void in self?.data = handler }
            
        case categoryLabel.bookLabel:
            lastBookRequest.fetchSightListModels      { [weak self] (handler: NSArray) -> Void in self?.data = handler }

            
        case categoryLabel.videoLabel:
            lastVideoRequest.fetchSightListModels     { [weak self] (handler: NSArray) -> Void in self?.data = handler }
            
        default:
            lastOtherRequest.fetchSightListModels     { [weak self] (handler: NSDictionary) -> Void in
            self?.data = handler.objectForKey("sightDatas") as? NSArray }
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(HistoryCell.self,    forCellReuseIdentifier : HistoryTableViewControllerElseCell)
        tableView.registerClass(LandscapeCell.self,  forCellReuseIdentifier : HistoryTableViewControllerSightCell)
        tableView.registerClass(LandscapeCell1.self, forCellReuseIdentifier : HistoryTableViewControllerSightCell1)
        tableView.registerClass(BookCell.self,       forCellReuseIdentifier : HistoryTableViewControllerBookCell)
        tableView.registerClass(VideoCell.self,      forCellReuseIdentifier : HistoryTableViewControllerVideoCell)
        
        tableView.rowHeight = 115
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data == nil ? 0 : data!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        switch cellReuseIdentifier! {

        case HistoryTableViewControllerSightCell:
            if indexPath.row == 0 {
                
                let c = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier!, forIndexPath: indexPath) as! LandscapeCell
                c.landscape = data![indexPath.row] as? SightLandscape
                cell = c
                
            } else {
                
                let c = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerSightCell1, forIndexPath: indexPath) as! LandscapeCell1
                c.landscape = data![indexPath.row] as? SightLandscape
                cell = c
            }

        case HistoryTableViewControllerBookCell:
            
            let c = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier!, forIndexPath: indexPath) as! BookCell
            c.book = data![indexPath.row] as? SightBook
            cell = c
            
        case HistoryTableViewControllerVideoCell:
            
            let c = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier!, forIndexPath: indexPath) as! VideoCell
            c.watchBtn.addTarget(self, action: "watchClick:", forControlEvents: UIControlEvents.TouchUpInside)
            c.watchBtn.tag = indexPath.row
            c.video = data![indexPath.row] as? SightVideo
            cell = c
            
        default:
            let c = tableView.dequeueReusableCellWithIdentifier(HistoryTableViewControllerElseCell, forIndexPath: indexPath) as! HistoryCell
            c.otherData = data![indexPath.row] as? SightListData
            cell = c
            
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
        default:
            h = 115
            break
        }

        return h!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc: TopicDetailController = TopicDetailController()
        
        switch cellReuseIdentifier! {
        case HistoryTableViewControllerSightCell:
            
            let sc = SightDetailController()
            let dataI = data![indexPath.row] as! SightLandscape
            sc.url = dataI.url
            navigationController?.pushViewController(sc, animated: true)
            
        case HistoryTableViewControllerBookCell:
            
            let bc = SightBookDetailController()
            let dataI = data![indexPath.row] as! SightBook
            bc.bookId = dataI.id!
            navigationController?.pushViewController(bc, animated: true)
            
        case HistoryTableViewControllerVideoCell:
            
            print("神马都不做")
            
        default:
            
            let dataI = data![indexPath.row] as! SightListData
            vc.topicId = dataI.id!
            navigationController?.pushViewController(vc, animated: true)
            
            break
        }
        
    }
    
    
    func watchClick(btn: UIButton) {
        
        let sc = SightDetailController()
        let dataI = data![btn.tag] as! SightVideo
        sc.url = dataI.url
        navigationController?.pushViewController(sc, animated: true)
    }
    
    
}
