//
//  TopicViewController+extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/2.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import SwiftyJSON

extension TopicViewController {
    
    // MARK: - 自定义方法
    /// 加载景点数据
    func doFavorite(sender: UIButton) {
        Statistics.shareStatistics.event(Event.collect_eventid, labelStr: "topic")
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
            ShareView.sharedShareView.showShareAction(nil, url: topicDetail.shareurl, images: headerImageView.image, title: topicDetail.title, subtitle: topicDetail.subtitle)
        }
    }
    
    /// 评论
    func doComment(sender: UIButton) {
        
        Statistics.shareStatistics.event(Event.comment_eventid, labelStr: "topic")
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
            self.commentVC.view.frame = CGRectMake(0, 64, view.bounds.width, bound.height - keyBoardFrame!.height - 64)
            self.commentVC.tableViewConH?.constant = bound.height - keyBoardFrame!.height - 64 - 88
            if self.commentVC.reloadIndexPath.row != 0 {
                self.commentVC.tableView.scrollToRowAtIndexPath(self.commentVC.reloadIndexPath, atScrollPosition: .Middle, animated: true)
            }
            self.commentVC.tableView.layoutIfNeeded()
        }
    }
    
    /// 点赞方法
    func praisedAction(sender: UIButton) {
        Statistics.shareStatistics.event(Event.praise_eventid, labelStr: "topic")
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
                        
                        if self.topicDataSource?.praiseNum == "1" && sender.selected {
                            ProgressHUD.showSuccessHUD(self.view, text: "恭喜您获得首赞")
                            return
                        }
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
        vc.isEntranceSight = isEntranceSight
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
    
    // MARK: - webview相关
    func tapWebView(gesture: UITapGestureRecognizer) {
        
        let point = gesture.locationInView(webView)
        let js = "imageSourceFromPoint(\(point.x), \(point.y - TopicViewContant.headerViewHeight))"
        webView.evaluateJavaScript(js, completionHandler: { (result, error) -> Void in
            if let url = result as? String {
                if (url.rangeOfString(".jpg") != nil) {
                    let range = Range(start: url.startIndex, end: url.rangeOfString(".jpg")!.endIndex)
                    let s1 = url.substringWithRange(range) + "@e\(Frame.screen.width)w_e\(Frame.screen.height)h"
                    self.currentImageIndex = self.jsImageStr.indexOf(s1) ?? 0
                    self.openDetailPhoto()
                }
            }
        })
    }


    func getImageDataSource(completion:(Void)->Void) {
        let js = "getImageSource();"
        webView.evaluateJavaScript(js) { (result, error) -> Void in
            if let imageData = result?.componentsSeparatedByString("|") {
                for item in imageData {
                    if item != "" {
                        let item = item + "@e\(Frame.screen.width)w_e\(Frame.screen.height)h"
                        self.jsImageStr.append(item)
//                        if let url = NSURL(string: item) {
////                            if url.absoluteString != "" {
//////                                self.JSimageData.append(url)
////                            }
//                        }
                    }
                }
            }
            
            if error != nil {
                print(error)
                return;
            }
            completion();
        }
    }
    
    
    func getImageData(completion:(Void)->Void) {
        let js = "getImgList();"
        webView.evaluateJavaScript(js) { (result, error) -> Void in
            print(result)
           let array = JSON(arrayLiteral: result!)
            for item in array.arrayValue ?? [] {
                for item in item.arrayValue {
                    print(item)
                    if let item = item.dictionaryObject {
                        self.jsImages.append(JSImageData(dict: item))
                        self.descs.append((item["desc"] ?? "") as! String)
                    }
                }
            }
            if error != nil {
                print(error)
                return;
            }
        }
    }
    
    
    func openDetailPhoto() {
        // 传递数据！- 图像的数组 & 用户选中的照片索引
        for item in jsImageStr {
            print(item)
        }
        let vc = PhotoBrowserViewController(urls: jsImageStr, descs: descs, index: currentImageIndex)
        // 0. 准备转场的素材
        let str = jsImageStr[currentImageIndex]
        presentedImageView.frame = currentSelectFrame
        presentedImageView.contentMode = .ScaleAspectFill
        presentedImageView.clipsToBounds = true

        presentedImageView.sd_setImageWithURL(NSURL(string: str)!, completed: { (image, error, cache, url) -> Void in
            self.presentedFrame = self.fullScreenFrame(0)
            // 记录当前行
            //        selectedStatusCell = cell
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = UIModalPresentationStyle.Custom
            self.presentViewController(vc, animated: true, completion: nil)
        })
    }
    
    
    func fullScreenFrame(photoIndex: Int) -> CGRect {
        
        let image = presentedImageView.image
        
        let scale = image!.size.height / image!.size.width
        let screenSize = UIScreen.mainScreen().bounds.size
        
        let w = screenSize.width
        let h = w * scale
        var y: CGFloat = 0
        if h < screenSize.height {
            y = (screenSize.height - h) * 0.5
        }
        return CGRect(x: 0, y: y, width: w, height: h)
    }
}


extension TopicViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    // 返回提供转场 Modal 动画的对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        return self
    }
    
    // 返回提供转场 Dismiss 动画的对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // 一旦实现，需要程序员提供动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // 1. 获取目标视图
        let viewKey = isPresented ? UITransitionContextToViewKey : UITransitionContextFromViewKey
        let targetView = transitionContext.viewForKey(viewKey)
        
        if targetView == nil {
            return
        }
        
        if isPresented {
            // 2. 添加 toView
            transitionContext.containerView()?.addSubview(targetView!)
            targetView!.alpha = 0
            // 2.1 添加临时的图片视图
            transitionContext.containerView()?.addSubview(presentedImageView)
            
            // 3. 动画
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                
                self.presentedImageView.frame = self.presentedFrame
                
                }, completion: { (_) -> Void in
                    
                    // 删除临时图片视图
                    self.presentedImageView.removeFromSuperview()
                    
                    targetView!.alpha = 1
                    // *** 告诉动画完成
                    transitionContext.completeTransition(true)
            })
        } else {
            
            // 0. 获取要缩放的图片
            let targetVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! PhotoBrowserViewController
            let iv = targetVC.currentImageView()
            iv.contentMode = UIViewContentMode.ScaleAspectFill
            
            // 叠加形变
            iv.transform = CGAffineTransformScale(iv.transform, targetView!.transform.a, targetView!.transform.a)
            // 设置图像视图的中心点
            iv.center = targetView!.center
            
            // 1. 添加到容器视图
            transitionContext.containerView()?.addSubview(iv)
            // 2. 将目标视图直接删除
            targetView?.removeFromSuperview()
            
            // 3. 恢复的位置
//            let targetFrame = selectedStatusCell!.screenFrame(targetVC.currentImageIndex())
            let targetFrame = currentSelectFrame
            
            // 4. 动画
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                
                iv.frame = targetFrame
                
                }, completion: { (_) -> Void in
                    iv.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }
}
