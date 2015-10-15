//
//  HistoryTableViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/3/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    // 网络请求，加载数据
    var lastLandscapeRequest = LandscapeRequest()
    var lastBookRequest = BookRequest()
    var lastVideoRequest = VideoRequest()
    var lastOtherRequest = SightListRequest()
    
    /// 景点id
    var sightId: String = ""
    
     /// tagsId
    var tagId: String = ""
    
    var data: NSArray? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var cellReuseIdentifier: String?
    
    var urlString: String? {
        didSet {
            data = nil
            if urlString == "landscape" { // 景观
                
                refresh("landscape")
                cellReuseIdentifier = "Landscape_Cell"
                
            } else if urlString == "book" {
                
                refresh("book")
                cellReuseIdentifier = "Book_Cell"
                
            } else if urlString == "video" {
                
                refresh("video")
                cellReuseIdentifier = "Video_Cell"
                
            } else {
                
                refresh("其他")
                cellReuseIdentifier = "History_Cell"
                
            }
            
            
        }
    }
    
    // MARK: 加载更新数据
    private func refresh(type: String) {
        
        if type == "landscape" { // 加载景观
            lastLandscapeRequest.sightId = sightId
            lastLandscapeRequest.fetchSightListModels { [unowned self] (handler: NSArray) -> Void in
                self.data = handler
            }
            
        } else if type == "book" {
            lastBookRequest.sightId = sightId
            lastBookRequest.fetchSightListModels { [unowned self] (handler: NSArray) -> Void in
                self.data = handler
            }
        } else if type == "video" {
            lastVideoRequest.sightId = sightId
            lastVideoRequest.fetchSightListModels({ [unowned self] (handler: NSArray) -> Void in
                self.data = handler
            })
        } else {
            lastOtherRequest.sightId = sightId
            lastOtherRequest.tag = tagId
            lastOtherRequest.fetchSightListModels({ [unowned self] (handler: NSDictionary) -> Void in
                
                self.data = handler.objectForKey("sightDatas") as? NSArray
            })
        }
        
        
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(HistoryCell.self, forCellReuseIdentifier: "History_Cell")
        tableView.registerClass(LandscapeCell.self, forCellReuseIdentifier: "Landscape_Cell")
        tableView.registerClass(LandscapeCell1.self, forCellReuseIdentifier: "Landscape_Cell1")
        tableView.registerClass(BookCell.self, forCellReuseIdentifier: "Book_Cell")
        tableView.registerClass(VideoCell.self, forCellReuseIdentifier: "Video_Cell")
        
        tableView.rowHeight = 115
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data == nil ? 0 : data!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        if cellReuseIdentifier == "Landscape_Cell" {
            
            if indexPath.row == 0 {
                let c = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier!, forIndexPath: indexPath) as! LandscapeCell
                
                c.landscape = data![indexPath.row] as? SightLandscape
                cell = c
            } else {
                let c = tableView.dequeueReusableCellWithIdentifier("Landscape_Cell1", forIndexPath: indexPath) as! LandscapeCell1
                c.landscape = data![indexPath.row] as? SightLandscape
                cell = c
            }
            
        } else if cellReuseIdentifier == "Book_Cell" {
            let c = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier!, forIndexPath: indexPath) as! BookCell
            c.book = data![indexPath.row] as? SightBook
            cell = c
        } else if cellReuseIdentifier == "Video_Cell" {
            let c = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier!, forIndexPath: indexPath) as! VideoCell
            c.watchBtn.addTarget(self, action: "watchClick:", forControlEvents: UIControlEvents.TouchUpInside)
            c.watchBtn.tag = indexPath.row
            c.video = data![indexPath.row] as? SightVideo
            cell = c
        } else { // backgroundCell
            
            let c = tableView.dequeueReusableCellWithIdentifier("History_Cell", forIndexPath: indexPath) as! HistoryCell
            c.otherData = data![indexPath.row] as? SightListData
            cell = c
        }
        
        return cell!
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if cellReuseIdentifier == "Landscape_Cell" {
            return 115
        } else if cellReuseIdentifier == "Book_Cell" {
            return 172
        } else if cellReuseIdentifier == "Video_Cell" {
            return 200
        } else {
            return 115
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc: TopicDetailController = TopicDetailController()
        if cellReuseIdentifier == "Landscape_Cell" {
            
            let sc = SightDetailController()
            let dataI = data![indexPath.row] as! SightLandscape
            sc.url = dataI.url
            navigationController?.pushViewController(sc, animated: true)
            
        } else if cellReuseIdentifier == "Book_Cell" {
            
            let bc = SightBookDetailController()
            let dataI = data![indexPath.row] as! SightBook
            bc.bookId = dataI.id!
            navigationController?.pushViewController(bc, animated: true)

        } else if cellReuseIdentifier == "Video_Cell" {
            
            print("神马都不做")
            
        } else {
            
            let dataI = data![indexPath.row] as! SightListData
            vc.topicId = dataI.id!
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func watchClick(btn: UIButton) {
        
        let sc = SightDetailController()
        let dataI = data![btn.tag] as! SightVideo
        sc.url = dataI.url
        navigationController?.pushViewController(sc, animated: true)
    }
    
    
}
