//
//  FeedBackViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class FeedBackViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: FeedBackSendRequest?
    /// 反馈情况(历史)
    var lastSuccessRequest: FeedBackRequest?
    /// 发送文字
    @IBOutlet weak var sendContentText: UITextField!
    /// 反馈列表
    var feedBackList: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.cornerRadius = sendButton.bounds.height * 0.5
        sendButton.clipsToBounds = true
        sendButton.addTarget(self, action: "sendMessageClick:", forControlEvents: UIControlEvents.TouchUpInside)
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "setting_black")!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        // 加载反馈列表
        loadFeedBackHistory()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardChanged(not: NSNotification) {
        let duration = not.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        let r = not.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        
        bottomConstraint.constant = UIScreen.mainScreen().bounds.size.height - r!.origin.y
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (_) -> Void in
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(feedBackList)
        return feedBackList?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        return cell
    }
    
    func sendMessageClick(btn: UIButton) {
        
        if sendContentText.text != "" {
            sendFeedBackMessage()
        }
        
        loadFeedBackHistory()
    }
    
    // MARK: - 加载更新数据
    /// 加载反馈历史消息(都是提问的问题)
    private func loadFeedBackHistory() {
        
        if lastSuccessRequest == nil {
            lastSuccessRequest = FeedBackRequest(deviceId: appUUID!)
        }
        
        lastSuccessRequest?.fetchFeedBackModels {(handler: [FeedBack]) -> Void in
            self.feedBackList = handler
            self.tableView.reloadData()
        }
    }
    
    
    
    /// 发送反馈消息
    private func sendFeedBackMessage() {
        
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = FeedBackSendRequest(deviceId: appUUID!, advise: sendContentText.text)
        }
        
        lastSuccessAddRequest?.fetchFeedBackModels {(handler: String) -> Void in
            
        }

        
//        lastSuccessRequest?.fetchCommentModels { (handler: [SendComment] ) -> Void in
//            self.nearSendComment = handler
//            self.tableView.reloadData()
//        }
        
    }

}

class FeedBackViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var msgButton: UIButton!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var timeLabelHeightConstraint: NSLayoutConstraint!
    

    
    var feedBack: FeedBack? {
        didSet {
            timeLabel.text = feedBack!.showTime ? feedBack!.create_time : ""
            timeLabelHeightConstraint.constant = feedBack!.showTime ? 15 : 0
            msgLabel.text = feedBack!.content
            msgButton.setTitle(feedBack!.content, forState: UIControlState.Normal)
        }
    }
    
    func rowHeight(feedBackMessage: FeedBack) -> CGFloat {
        self.layoutIfNeeded()
        return CGRectGetMaxY(msgButton.frame) + 8
    }
    
    func cellIdentifier(feedback: FeedBack) -> String {
        return (feedback.id.toInt()! % 2) == 0 ? "SendCell" : "RecvCell"
    }
    
    override func awakeFromNib() {
        self.msgButton.titleLabel?.numberOfLines = 0
        self.msgLabel.preferredMaxLayoutWidth = 200
    }
}
