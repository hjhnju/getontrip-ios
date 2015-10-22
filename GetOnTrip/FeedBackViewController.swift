//
//  FeedBackViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class FeedBackViewController: MainViewController /*,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate */{
    
    static let name = "反馈"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.slideButton)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButtonClicked:")
    }
    
    
    // MARK: 自定义
    
    func searchButtonClicked(button: UIBarButtonItem) {
        super.showSearch()
    }

//    lazy var tableView: UITableView = UITableView()
//    
//    lazy var sendButton: UIButton = UIButton(title: "发送", fontSize: 12, radius: 34 * 0.5)
//    
////    lazy var bottomConstraint: NSLayoutConstraint!
//    /// 网络请求加载数据(添加)
////    var lastSuccessAddRequest: FeedBackSendRequest?
//    /// 反馈情况(历史)
////    var lastSuccessRequest: FeedBackRequest?
//    /// 发送文字
//    lazy var sendContentText: UITextField = UITextField()
//    /// 反馈列表
//    var feedBackList: NSArray?
//    
//    /// 缓存行高
//    lazy var rowHeightCache: NSCache = {
//        var cache = NSCache()
//        return cache
//    }()
//    
//    // MARK: - 初始化相关
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
//        settingSendButton()
//        tableView.dataSource = self
//        tableView.delegate = self
//        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "feedBack_background")!)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
//        // 加载反馈列表
//        loadFeedBackHistory()
//    }
//    
//    /// 加载发送按钮相关设置
//    func settingSendButton() {
//        sendButton.layer.cornerRadius = sendButton.bounds.height * 0.5
//        sendButton.clipsToBounds = true
//        sendButton.addTarget(self, action: "sendMessageClick:", forControlEvents: UIControlEvents.TouchUpInside)
//    }
//    /// 注销通知
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
//    /// 当键盘弹出的时候，执行相关操作
//    func keyboardChanged(not: NSNotification) {
//        let duration = not.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
//        let r = not.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
//        
////        bottomConstraint.constant = UIScreen.mainScreen().bounds.size.height - r!.origin.y
//        UIView.animateWithDuration(duration, animations: { () -> Void in
//            self.view.layoutIfNeeded()
//        }) { (_) -> Void in
//            
//        }
//    }
//    
//
//    
//    /*
//    - (void)scrollToBottom {
//    // 滚动到最后一行
//    NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//*/
//    // MARK: - tableView dataSource
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return feedBackList?.count ?? 0
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
////        var cell = reuseableCellWithIndexPath(indexPath)
////        cell.feedBack = feedBackList![indexPath.row] as? FeedBack
////        let feedBack = feedBackList![indexPath.row] as? FeedBack
////        let cell = tableView.dequeueReusableCellWithIdentifier(feedBack?.type == 1 ? "SendCell" : "RecvCell", forIndexPath: indexPath) as? FeedBackViewCell
////        cell?.feedBack = feedBack
//        return UITableViewCell()
//    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if rowHeightCache.objectForKey(indexPath) != nil {
//            return CGFloat(rowHeightCache.objectForKey(indexPath)!.floatValue)
//        }
//        
//        let cell = self.reuseableCellWithIndexPath(indexPath)
////        let h = cell.rowHeight(feedBackList![indexPath.row] as! FeedBack)
//        rowHeightCache.setObject(h, forKey: indexPath)
//        
//        return h
//    }
//    
//    func reuseableCellWithIndexPath(indexPath: NSIndexPath) -> FeedBackViewCell {
//        let msg: FeedBack = feedBackList![indexPath.row] as! FeedBack
//       
//        return tableView.dequeueReusableCellWithIdentifier(msg.type == 1 ? "SendCell" : "RecvCell") as! FeedBackViewCell
//    }
//    
//    func sendMessageClick(btn: UIButton) {
//        
//        if sendContentText.text != "" {
//            sendFeedBackMessage()
//        }
//        
//        loadFeedBackHistory()
//    }
//    
//    // MARK: - 加载更新数据
//    /// 加载反馈历史消息(都是提问的问题)
//    private func loadFeedBackHistory() {
//        
//        if lastSuccessRequest == nil {
//            lastSuccessRequest = FeedBackRequest(deviceId: appUUID!)
//        }
//        
//        lastSuccessRequest?.fetchFeedBackModels {(handler: [FeedBack]) -> Void in
//            self.feedBackList = handler
//            self.tableView.reloadData()
//        }
//    }
//    
//    
//    
//    /// 发送反馈消息
//    private func sendFeedBackMessage() {
//        
//        if lastSuccessAddRequest == nil {
//            lastSuccessAddRequest = FeedBackSendRequest(deviceId: appUUID!, advise: sendContentText.text!)
//        }
//        
//        lastSuccessAddRequest?.fetchFeedBackModels {(handler: String) -> Void in
//            
//        }
//
//        
////        lastSuccessRequest?.fetchCommentModels { (handler: [SendComment] ) -> Void in
////            self.nearSendComment = handler
////            self.tableView.reloadData()
////        }
//        
//    }

}

class FeedBackViewCell: UITableViewCell {
    
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var msgLabel: UILabel!
//    @IBOutlet weak var iconView: UIImageView!
//    @IBOutlet weak var msgBtn: UIButton!
//    @IBOutlet weak var timeHeightCons: NSLayoutConstraint!
//
//    var feedBack: FeedBack? {
//        didSet {
////            iconView.sd_setImageWithURL(NSURL(string: feedBack!.image))
//            timeLabel.text = feedBack!.showTime ? feedBack!.create_time : ""
//            timeHeightCons.constant = feedBack!.showTime ? 15 : 0
//            msgLabel.text = feedBack?.content
//            msgBtn.setTitle(feedBack!.content, forState: UIControlState.Normal)
//        }
//    }
//    
//    
//    func rowHeight(feedBackMessage: FeedBack) -> CGFloat {
//        self.layoutIfNeeded()
//        
//        // 设置文本换行宽度
//        msgLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 126
//        
//        // 更新自动布局
//        layoutIfNeeded()
//        
//        return CGRectGetMaxY(msgBtn.frame) + 12
//    }
//
//    
//    override func awakeFromNib() {
//        msgBtn.titleLabel!.numberOfLines = 0
////        msgLabel.preferredMaxLayoutWidth = 100
//        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
//        iconView.clipsToBounds = true
//
//    }
}
