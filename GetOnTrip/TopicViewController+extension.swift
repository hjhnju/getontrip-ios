//
//  TopicViewController+extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/2.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

extension TopicViewController {
    
    // MARK: - 自定义方法
    /// 加载景点数据
    func doFavorite(sender: UIButton) {
        sender.selected = !sender.selected
        if let topic = topicDataSource {
            let type  = FavoriteContant.TypeTopic
            let objid = topic.id
            Favorite.doFavorite(type, objid: objid, isFavorite: sender.selected) {
                (result, status) -> Void in
                if status == RetCode.SUCCESS {
                    if result == nil {
                        sender.selected = !sender.selected
                    } else {
                        ProgressHUD.showSuccessHUD(self.view, text: sender.selected ? "已收藏" : "已取消")
                    }
                } else {
                    ProgressHUD.showErrorHUD(self.view, text: "操作未成功，请稍候再试!")
                    sender.selected = !sender.selected
                }
            }
        }
    }
    
    func doSharing(sender: UIButton) {
        if let topicDetail = topicDataSource {
            let url = topicDetail.shareurl
            shareView.showShareAction(nil, url: url, images: headerImageView.image, title: topicDetail.title, subtitle: topicDetail.subtitle)
        }
    }
    
    /// 评论
    func doComment(sender: UIButton) {
        let w = view.bounds.width
        let h = view.bounds.height
        commentVC.view.hidden = false
        commentVC.topicId = topicDataSource?.id ?? ""
        commentVC.view.frame = CGRectMake(w - 28, h - 44, 0, 0)
        coverButton.frame = UIScreen.mainScreen().bounds
        commentVC.view.clipsToBounds = true
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.commentVC.view.frame = CGRectMake(0, TopicViewContant.commentViewHeight, w, UIScreen.mainScreen().bounds.height * 0.72)
            self.coverButton.alpha = 0.7
            }) { (_) -> Void in
                self.commentVC.view.clipsToBounds = false
        }
    }
    
    
    /// 评论时遮罩层的点击方法
    func coverClick(serder: UIButton) {
        self.commentVC.issueTextfield.resignFirstResponder()
        self.commentVC.view.clipsToBounds = true
        UIView.animateWithDuration(0.3, animations: { [weak self] () -> Void in
            self?.coverButton.alpha = 0.0
            self?.commentVC.view.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 22, UIScreen.mainScreen().bounds.height - 34, 0, 0)
            }) { [weak self]  (_) -> Void in
                self?.commentVC.issueTextfield.placeholder = ""
                self?.commentVC.toUser = ""
                self?.commentVC.upId   = ""
                self?.commentVC.view.hidden = true
        }
    }
    
    /// 当键盘弹出的时候，执行相关操作
    func keyboardChanged(not: NSNotification) {
        
        let keyBoardFrame = not.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        let keyBoardY = keyBoardFrame?.origin.y
        let transFromValue = keyBoardY! - view.bounds.height
        
        let bound = UIScreen.mainScreen().bounds
        if transFromValue == 0{
            self.commentVC.view.frame = CGRectMake(0, bound.height - (bound.height * 0.72) - 44, view.bounds.width, bound.height * 0.72)
            self.commentVC.tableViewConH?.constant = bound.height * 0.72 - 88
            self.commentVC.tableView.layoutIfNeeded()
        } else {
            self.commentVC.view.frame = CGRectMake(0, 44, view.bounds.width, bound.height - keyBoardFrame!.height - 44)
            self.commentVC.tableViewConH?.constant = bound.height - keyBoardFrame!.height - 44 - 88
            if self.commentVC.reloadIndexPath.row != 0 {
                self.commentVC.tableView.scrollToRowAtIndexPath(self.commentVC.reloadIndexPath, atScrollPosition: .Middle, animated: true)
            }
            self.commentVC.tableView.layoutIfNeeded()
        }
    }
    
    /// 点赞方法
    func praisedAction(sender: UIButton) {
        sender.selected = !sender.selected
        praiseNum = topicDataSource?.praiseNum ?? "0"
        refreshPraisedButton(String(Int(topicDataSource?.praiseNum ?? "0")! + (sender.selected ? 1 : -1)))
        if let topic = topicDataSource {
            let type  = PraisedContant.TypeTopic
            let objid = topic.id
            Praised.praised(type, objid: objid, isFavorite: sender.selected, handler: { (result, status) -> Void in
                if status == RetCode.SUCCESS {
                    if result == "-1" {
                        sender.selected = !sender.selected
                        self.refreshPraisedButton(self.praiseNum)
                    } else {
                        ProgressHUD.showSuccessHUD(self.view, text: sender.selected ? "已点赞" : "已取消")
                    }
                } else {
                    if status == RetCode.praised {
                        ProgressHUD.showErrorHUD(nil, text: "您已点赞")
                        sender.selected = true
                        self.refreshPraisedButton(self.praiseNum)
                    } else {
                        sender.selected = !sender.selected
                        ProgressHUD.showErrorHUD(self.view, text: "操作未成功，请稍候再试!")
                        self.refreshPraisedButton(self.praiseNum)
                    }
                }
            })
        }
    }
    
    private func refreshPraisedButton(praiseNum: String) {
        self.topicDataSource?.praiseNum = praiseNum
        self.praisedButton.setTitle(" " + "\(self.topicDataSource?.praiseNum ?? "0")", forState: .Normal)
        self.praisedButton.setTitle(" " + "\(self.topicDataSource?.praiseNum ?? "0")", forState: .Selected)
    }
    
    /// 跳至景点页
    func sightAction(sender: UIButton) {
        
        // 如果只有一个景点,那这个景点肯定是由上一个景点跳进来了，所以跳回去，而不是重新创建
        if topicDataSource?.arrsight.count == 1 && isEntranceSight == true {
            navigationController?.popViewControllerAnimated(true)
            return
        }
        
        if topicDataSource?.arrsight.count == 1 {
            let sightViewController = SightViewController()
            let sight: Sight = Sight(id: topicDataSource?.sightid ?? "")
            sight.name = topicDataSource?.sight ?? ""
            sightViewController.sightDataSource = sight
            navigationController?.pushViewController(sightViewController, animated: true)
            return
        }
        
        // 其他情况如果有多个景点可去的情况
        let vc = TopicEnterSightController()
        vc.upSightId = topicDataSource?.sightid ?? ""
        vc.nav = navigationController
        vc.dataSource = topicDataSource?.arrsight
        // 1. 设置`转场 transitioning`代理
        vc.transitioningDelegate = sendPopoverAnimator
        // 2. 设置视图的展现大小
        let screen = UIScreen.mainScreen().bounds
        var h: CGFloat = 5 * 53 + 120 + 26.5
        if topicDataSource?.arrsight.count < 5 && topicDataSource?.arrsight.count >= 2 {
            h = CGFloat(Int(topicDataSource?.arrsight.count ?? 0) + 1) * 53 + 46 + 34
        }
        
        let w: CGFloat = screen.width * 0.63
        let x: CGFloat = (screen.width - w) * 0.5
        let y: CGFloat = (screen.height - h) * 0.5 // screen.height * 0.27
        sendPopoverAnimator.presentFrame = CGRectMake(x, y, w, h)
        vc.view.clipsToBounds = true
        // 3. 设置专场的模式 - 自定义转场动画
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc, animated: true, completion: nil)
    }

}