//
//  TopicDetailListController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/19.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class TopicDetailListController: UITableViewController {
    
    // 网络请求，加载数据
    var lastSuccessRequest: TopicRequest?
    
    var dataSource: NSArray?{
        didSet {
            
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        //获取数据更新tableview
        if lastSuccessRequest == nil {
//            lastSuccessRequest = TopicRequest(pageSize: <#Int#>, page: <#Int#>, sightId: <#Int#>, order: <#Int?#>, tags: <#String?#>)
        }
        
        
        
//        lastSuccessRequest!.fetchFirstPageModels { (sights:[Sight]) -> Void in
//            if sights.count > 0 {
//                self.nearSights = sights
//                self.tableView.reloadData()
//                
//                var formatter = NSDateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd HH:mm"
//                var dateString = formatter.stringFromDate(NSDate())
//                let message = "最近更新时间:\(dateString)"
//                
//                self.refreshControl?.attributedTitle = NSAttributedString(string: message, attributes: [NSForegroundColorAttributeName:SceneColor.lightGray])
//            } else {
//                self.activityLabel.text = "无法获取附近内容，请检查您的网络"
//            }
        
            
//            self.refreshControl?.endRefreshing()
//            //结束定位
//            //println("结束定位")
//            self.locationManager.stopUpdatingLocation()
//        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

}
