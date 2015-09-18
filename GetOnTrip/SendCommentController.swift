//
//  SendCommentController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SendCommentController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - 属性
    // 评论标题
    @IBOutlet weak var commentTitleView: UIView!
    // 确认发布view
    @IBOutlet weak var confirmSendView: UIView!
    // 确认发布按钮
    @IBOutlet weak var confirmIssue: UIButton!
    // 对话tableView
    @IBOutlet weak var tableView: UITableView!
    // 网络请求，加载数据
    var lastSuccessRequest: SendCommentRequest?
    
    var sightId: Int?
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var nearSendComment = [SendComment]()
    
    // 设置底线
    lazy var baseline: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(hex: 0x9C9C9C, alpha: 0.5)
        return baselineView
    }()
    
    @IBOutlet weak var bottomImageView: UIImageView!
    // MARK: - 初始化相关属性
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        commentTitleView.addSubview(baseline)
        commentTitleView.sendSubviewToBack(baseline)
        bottomImageView.image = UIImage(named: "triangle_fall")
        confirmIssue.backgroundColor = UIColor(hex: 0xF3FD54, alpha: 1.0)
        confirmIssue.layer.cornerRadius = confirmIssue.bounds.height * 0.5
        tableView.dataSource = self
        tableView.delegate = self
        refresh()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let x: CGFloat = 0
        let h: CGFloat = 0.5
        let y: CGFloat = CGRectGetMaxY(commentTitleView.frame) - 0.5
        let w: CGFloat = commentTitleView.bounds.width
        baseline.frame = CGRectMake(x, y, w, h)
    }
    
    func keyboardChanged(notification: NSNotification) {
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        let r = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        
        bottomConstraint.constant = UIScreen.mainScreen().bounds.size.height - r!.origin.y - 44
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                
        }
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
        let cell = reuseableCellWithIndexPath(indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = reuseableCellWithIndexPath(indexPath)
        return cell.rowHeight!
    }
    
    func reuseableCellWithIndexPath(indexPath: NSIndexPath) -> SendCommentCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SendComment_Cell") as! SendCommentCell
        cell.sendCommentModel = nearSendComment[indexPath.row]
        return cell
    }
}
