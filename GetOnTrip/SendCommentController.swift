//
//  SendCommentController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SendCommentController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var commentTitleView: UIView!
    
    @IBOutlet weak var confirmIssue: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    // 网络请求，加载数据
    var lastSuccessRequest: SendCommentRequest?
    
    
    
    var sightId: Int?
    
    var nearSendComment = [SendComment]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        refresh()
    }
    
    // MARK: 加载更新数据
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        //         获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = SendCommentRequest(topicId: 1)
        }
        
//        lastSuccessRequest?.fetchCommentModels(handler: SendComment -> Void)
        lastSuccessRequest?.fetchCommentModels { (handler: [SendComment] ) -> Void in
            self.nearSendComment = handler
            self.tableView.reloadData()
        }

    }
    
    // MARK: tableView dataSource and delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearSendComment.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("SendComment_Cell", forIndexPath: indexPath) as! SendCommentCell
        cell.sendCommentModel = nearSendComment[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cell = reuseableCellWithIndexPath(indexPath)
        return cell.rowHeight("asdfkhalsdkjflasjdfhlashdlajsd;lkajshdluhifaw")
    }
    
    func reuseableCellWithIndexPath(indexPath: NSIndexPath) -> SendCommentCell {
        
        return tableView.dequeueReusableCellWithIdentifier("SendComment_Cell") as! SendCommentCell
    }
}
