//
//  VideoController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/21.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class VideoController: UITableViewController {

    // 网络请求，加载数据
    var lastSuccessRequest: VideoRequest?
    
    var sightId: Int?
    
    var nearVideo = [Video]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 215
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
        refresh()
    }
    
    // MARK: 加载更新数据
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
//        //         获取数据更新tableview
//        if lastSuccessRequest == nil {
//            lastSuccessRequest = VideoRequest(sightId: sightId!)
//        }
//        
//        lastSuccessRequest!.fetchVideoModels { (handler: [Video]) -> Void in
//
//            if handler.count > 0 {
//                self.nearVideo = handler
//                self.tableView.reloadData()
//            }
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    // MARK: 书籍列表页数据源方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearVideo.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell", forIndexPath: indexPath) as! VideoCell
//        cell.videoModel = nearVideo[indexPath.row]

        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
}
