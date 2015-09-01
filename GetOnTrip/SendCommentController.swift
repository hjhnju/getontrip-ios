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
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var nearSendComment = [SendComment]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        refresh()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    func keyboardChanged(notification: NSNotification) {
        
        var duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        
        var rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        
//        bottomConstraint.constant = UIScreen.mainScreen().bounds.height - rect.origin.y
        
//        bottomConstraint.constant = UIScreen.mainScreen().bounds.height - rect.origin.y
        
//        self.bottomConstraint.constant = [UIScreen mainScreen].bounds.size.height - r.origin.y;
//        
//        [UIView animateWithDuration:duration animations:^{
//        [self.view layoutIfNeeded];
//        } completion:^(BOOL finished) {
//        [self scrollToBottom];
//        }];
        
//        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
//        // 键盘动画时长
//        var duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
//        
//        duration = localKeyboardFlag ? 0 : duration
//        localKeyboardFlag = false
//        
//        // 2. 设置键盘高度
//        toolBarBottomCons?.constant = -(view.bounds.height - rect.origin.y)
//        
//        // 3. 动画
//        UIView.animateWithDuration(duration) {
//            self.view.layoutIfNeeded()
//        }

        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        var cell = reuseableCellWithIndexPath(indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cell = reuseableCellWithIndexPath(indexPath)
        return cell.rowHeight!
    }
    
    func reuseableCellWithIndexPath(indexPath: NSIndexPath) -> SendCommentCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("SendComment_Cell") as! SendCommentCell
        cell.sendCommentModel = nearSendComment[indexPath.row]
        return cell
    }
}
