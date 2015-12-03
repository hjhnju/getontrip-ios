
//
//  CommentViewController+extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/26.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

// 将原文件的逻辑运算抽出
extension CommentViewController {
    
    // MARK: - tableview datasource and delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentTableViewCell", forIndexPath: indexPath) as! CommentTableViewCell
        cell.data = data
        cell.currentIndex = indexPath
        
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
        let delAction = UIAlertAction(title: "删除", style: .Default) { (_) -> Void in
            ProgressHUD.sharedProgressHUD.showOperationPrompt(nil, text: "正在删除中", style: nil, handler: { (handler) -> Void in
                CommentAddAndDelRequest.fetchDelCommentModel(comment.id, handler: { (result, status) -> Void in
                    handler()
                    if status == RetCode.SUCCESS {
                        ProgressHUD.showSuccessHUD(nil, text: "删除成功")
                        self.loadData()
                        if self.upId == "" {
                            let parentVC = self.parentViewController as? TopicViewController
                            let topic: Topic = parentVC?.topicDataSource ?? Topic()
                            topic.commentNum = String((Int(parentVC?.topicDataSource?.commentNum ?? "0") ?? 0) - 1)
                            parentVC?.topicDataSource = topic
                        }
                    } else {
                        ProgressHUD.showErrorHUD(nil, text: "删除失败")
                    }
                })
            })
        }
        
        let reportAction = UIAlertAction(title: "举报", style: .Default) { (sender) -> Void in
            LoginView.sharedLoginView.doAfterLogin() { (success, error) -> () in
                if success {
                    //不管网络是否返回
                    ProgressHUD.showSuccessHUD(self.view, text: "已举报")
                    let req = ReportRequest()
                    req.commentid = String(comment.id)
                    req.report()
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(replyAction)
        if globalUser?.nickname == comment.from_name {
            alertController.addAction(delAction)
        }
        alertController.addAction(reportAction)
        
        // for iPad
        alertController.modalPresentationStyle = UIModalPresentationStyle.Popover
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = self.view.frame
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}