//
//  BookController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/20.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class BookController: UITableViewController {

    // 网络请求，加载数据
    var lastSuccessRequest: BookRequest?
    
    var sightId: Int?
    
    var nearBook = [Book]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 172
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "topicBottom")!)
        refresh()
    }
    
    // MARK: 加载更新数据
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
//         获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = BookRequest(sightId: sightId!)
        }
        
        lastSuccessRequest!.fetchBookModels { (handler: [Book]) -> Void in
            
            if handler.count > 0 {
                self.nearBook = handler
                self.tableView.reloadData()
            }
        }
    }

    
    
    // MARK: 书籍列表页数据源方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearBook.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookCell", forIndexPath: indexPath) as! BookCell
        cell.bookModel = nearBook[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


}
