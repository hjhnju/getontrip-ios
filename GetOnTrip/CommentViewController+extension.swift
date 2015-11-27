
//
//  CommentViewController+extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/26.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import SVProgressHUD
import UIKit

// 将原文件的逻辑运算抽出
extension CommentViewController {
    
    // MARK: - tableview datasource and delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        let cell = CommentTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        let data = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentTableViewCell", forIndexPath: indexPath) as! CommentTableViewCell
        cell.data = data

        for item in cell.commentTableView.visibleCells {
            if let it = item as? CommentPersonCell {
                it.replayButton.addTarget(self, action: "touchReplyCommentAction:", forControlEvents: UIControlEvents.TouchUpInside)
                it.replayButton.indexPath = indexPath
            }
        }
        
        // 滚动到最后一行的时候加载
        if indexPath.row == dataSource.count - 1 { loadMore() }
        
        return cell
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CommentTableViewCell.dataWithCellHeight(dataSource[indexPath.row])
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        reloadIndexPath = indexPath
        let comment  = self.dataSource[indexPath.row]
        selectRowForComment(comment)
    }
    
    /// 选中每行评论
    func selectRowForComment(comment: Comment) {
        let alertController = UIAlertController(title: "对 \(comment.from_name) 的评论内容", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let replyAction  = UIAlertAction(title: "回复", style: .Default) { [weak self] (sender) -> Void in
            LoginView.sharedLoginView.doAfterLogin() {(success, error) -> () in
                if success {
                    self?.upId     = String(comment.upid)
                    self?.toUser   = comment.from_user_id
                    let placeholder = "回复 \(comment.from_name):"
                    self?.issueTextfield.placeholder = placeholder
                    self?.issueTextfield.becomeFirstResponder()
                }
            }
        }
        
        let reportAction = UIAlertAction(title: "举报", style: .Default) { (sender) -> Void in
            LoginView.sharedLoginView.doAfterLogin() { (success, error) -> () in
                if success {
                    //不管网络是否返回
                    SVProgressHUD.showInfoWithStatus("已举报")
                    let req = ReportRequest()
                    req.commentid = String(comment.id)
                    req.report()
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(replyAction)
        alertController.addAction(reportAction)
        
        // for iPad
        alertController.modalPresentationStyle = UIModalPresentationStyle.Popover
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = self.view.frame
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}