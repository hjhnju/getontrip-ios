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
    var lastLandscapeRequest: LandscapeRequest?
    
    /// 景点id
    var sightId: String?
    
    var data: NSArray? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var cellReuseIdentifier: String?
    
    var urlString: String? {
        didSet {
            
            if urlString == "landscape" { // 景观
                
                refresh("landscape")
                cellReuseIdentifier = "Landscape_Cell"
                
            } else if urlString == "book" {
                
                cellReuseIdentifier = "Book_Cell"
                
            } else if urlString == "video" {
                
                cellReuseIdentifier = "Video_Cell"
                
            } else {
                
                cellReuseIdentifier = "History_Cell"
                
            }
            
            
        }
    }
    
    // MARK: 加载更新数据
    private func refresh(type: String) {
        NSLog("notice:refreshing nearby data.")
        
        // 获取数据更新tableview
        if lastLandscapeRequest == nil {
            lastLandscapeRequest = LandscapeRequest()
            lastLandscapeRequest?.sightId = sightId
        }
        
        lastLandscapeRequest!.fetchSightListModels { [unowned self] (handler: NSArray) -> Void in
            self.data = handler
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(HistoryCell.self, forCellReuseIdentifier: "History_Cell")
        tableView.registerClass(LandscapeCell.self, forCellReuseIdentifier: "Landscape_Cell")
        tableView.registerClass(LandscapeCell1.self, forCellReuseIdentifier: "Landscape_Cell1")
        tableView.registerClass(BookCell.self, forCellReuseIdentifier: "Book_Cell")
        tableView.registerClass(VideoCell.self, forCellReuseIdentifier: "Video_Cell")
        tableView.registerClass(BackgroundCell.self, forCellReuseIdentifier: "Background_Cell")
        
        tableView.rowHeight = 115
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data == nil ? 0 : data!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        if cellReuseIdentifier == "HistoryCell" {
            let c = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier!, forIndexPath: indexPath) as! HistoryCell
            cell = c
        } else if cellReuseIdentifier == "Landscape_Cell" {
            
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
            cell = c
        } else if cellReuseIdentifier == "Video_Cell" {
            let c = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier!, forIndexPath: indexPath) as! VideoCell
            c.backgroundColor = UIColor.randomColor()
            cell = c
        } else { // backgroundCell
            
            let c = tableView.dequeueReusableCellWithIdentifier("History_Cell", forIndexPath: indexPath) as! HistoryCell
            c.backgroundColor = UIColor.randomColor()
            cell = c
        }
        
        return cell!
        
    }
    
    
    
    
}
