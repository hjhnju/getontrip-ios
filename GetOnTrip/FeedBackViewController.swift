//
//  FeedBackViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh

class FeedBackViewController: MenuViewController, UITableViewDataSource, UITableViewDelegate { // UITextFieldDelegate
    
    lazy var tableView: UITableView = UITableView()
    
    /// 反馈情况(历史)
    var lastRequest: FeedbackRequest = FeedbackRequest()

    /// 发送按钮
    lazy var sendButton: UIButton = UIButton(title: "发送", fontSize: 12, radius: 34 * 0.5, titleColor: SceneColor.fontGray, fontName: Font.PingFangSCLight)
    
    /// 发送文字
    lazy var sendContentText: UITextField = UITextField()
    
    /// 底view
    lazy var commentBottomView: UIView = UIView()
    
    var dataSource: [Feedback] = [Feedback]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - 初始化相关
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        initView()
        initTableView()
        initCommentBottomView()
        initRefresh()
        loadData()
    }
    
    private func initView() {
        navBar.titleLabel.text = "反馈"
        view.backgroundColor = .whiteColor()
        tableView.backgroundColor = UIColor.randomColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    private func initCommentBottomView() {
        
        view.addSubview(commentBottomView)
        commentBottomView.addSubview(sendContentText)
        commentBottomView.addSubview(sendButton)
        commentBottomView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - 50, UIScreen.mainScreen().bounds.width, 50)
        commentBottomView.backgroundColor = SceneColor.greyThin
        
        sendContentText.frame = CGRectMake(8, 8, UIScreen.mainScreen().bounds.width - 119, 34)
        sendButton.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 100, 8, 91, 34)
        sendButton.backgroundColor = SceneColor.shallowYellows
        sendButton.addTarget(self, action: "sendFeedBackMessage", forControlEvents: .TouchUpInside)
        
        sendContentText.borderStyle = .None
        sendContentText.layer.borderWidth = 0.5
        sendContentText.layer.borderColor = UIColor(hex: 0x1C1C1C, alpha: 0.5).CGColor
        sendContentText.layer.cornerRadius = 2
        sendContentText.backgroundColor = UIColor(hex: 0xFFFFFF, alpha: 0.5)
        sendContentText.leftView = UIView(frame: CGRectMake(0, 0, 5, 1))
        sendContentText.leftViewMode = .Always
    }
    
    private func initTableView() {
        
        view.addSubview(tableView)
        tableView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.registerClass(FeedBackMyTableViewCell.self, forCellReuseIdentifier: "FeedBackMyTableViewCell")
        tableView.registerClass(FeedBackSytemTableViewCell.self, forCellReuseIdentifier: "FeedBackSytemTableViewCell")
    }
    
    private func initRefresh() {
        //上拉刷新
        let tbHeaderView = MJRefreshNormalHeader { [weak self] () -> Void in self?.loadData() }
        tbHeaderView.automaticallyChangeAlpha = true
        tbHeaderView.activityIndicatorViewStyle = .Gray
        tbHeaderView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbHeaderView.lastUpdatedTimeLabel?.font = UIFont.systemFontOfSize(11)
        tbHeaderView.stateLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.hidden = true
        tbHeaderView.stateLabel?.hidden = true
        tbHeaderView.arrowView?.image = UIImage()
        
        //下拉刷新
        let tbFooterView = MJRefreshAutoNormalFooter { [weak self] () -> Void in self?.loadMore() }
        tbFooterView.automaticallyRefresh = true
        tbFooterView.automaticallyChangeAlpha = true
        tbFooterView.activityIndicatorViewStyle = .White
        tbFooterView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbFooterView.stateLabel?.textColor = SceneColor.lightGray
        
        tableView.mj_header = tbHeaderView
        tableView.mj_footer = tbFooterView
    }
    

//    
//    /*
//    - (void)scrollToBottom {
//    // 滚动到最后一行
//    NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//*/
    
    // MARK: - tableView dataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data = dataSource[indexPath.row]
        if data.type == "1" {
            let cell = tableView.dequeueReusableCellWithIdentifier("FeedBackMyTableViewCell", forIndexPath: indexPath) as! FeedBackMyTableViewCell
            cell.data = data
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FeedBackSytemTableViewCell", forIndexPath: indexPath) as! FeedBackSytemTableViewCell
            cell.data = data
            return cell
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
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
    
    /// 当键盘弹出的时候，执行相关操作
    func keyboardChanged(not: NSNotification) {
        
        let keyBoardFrame = not.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        let time = not.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue ?? 0.0
        let keyBoardY = keyBoardFrame?.origin.y
        let transFromValue = keyBoardY! - view.bounds.height
        
        print(transFromValue)
        if transFromValue == 0 { // 落下
            UIView.animateWithDuration(time, animations: { [weak self] () -> Void in
                self?.commentBottomView.frame.origin.y = UIScreen.mainScreen().bounds.height - 50
            })
        } else { // 弹出
            UIView.animateWithDuration(time, animations: { [weak self] () -> Void in
                self?.commentBottomView.frame.origin.y = keyBoardY! - 50
            })
        }
    }
    
    /// 是否正在加载中
    var isLoading:Bool = false
    
    /// 注意：不能在loadData中进行beginRefreshing, beginRefreshing会自动调用loadData
    private func loadData() {
        if self.isLoading {
            return
        }
        self.isLoading = true
        
        //清空footer的“加载完成”
        self.tableView.mj_footer.resetNoMoreData()
        
        lastRequest.fetchListFirstPageModels {[weak self] (data, status) -> Void in
            //处理异常状态
            if RetCode.SUCCESS != status {
                ProgressHUD.showErrorHUD(self?.view, text: MessageInfo.NetworkError)
                self?.tableView.mj_header.endRefreshing()
                self?.isLoading = false
                return
            }
            
            if let dataSource = data {
                self?.tableView.mj_header.endRefreshing()
                self?.dataSource = dataSource
            }
            self?.isLoading = false
        }
    }
    
    /// 底部加载更多
    func loadMore(){
        if self.isLoading {
            return
        }
        self.isLoading = true
        //请求下一页
        self.lastRequest.fetchListNextPageModels { [weak self] (data, status) -> Void in
            
            if let dataSource = data {
                if dataSource.count > 0 {
                    if let cells = self?.dataSource {
//                        self?.dataSource = cells + dataSource
                    }
                    self?.tableView.mj_footer.endRefreshing()
                } else {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            self?.isLoading = false
        }
    }
    
    /// 发送反馈消息
    func sendFeedBackMessage() {
        if sendContentText.text == "" {
            ProgressHUD.showErrorHUD(nil, text: "请先输入需要反馈的消息")
            return
        }
        lastRequest.fetchSendModels(sendContentText.text ?? "") { (result, status) -> Void in
            if status == RetCode.SUCCESS {
//                if result
            }
        }
    }
    
    /// 注销通知
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

class FeedBackMyTableViewCell: UITableViewCell {
    
    /// 时间
    lazy var timeLabel = UILabel(color: SceneColor.frontBlack, title: "1970-1-1", fontSize: 10, mutiLines: true, fontName: Font.PingFangSCLight)
    
    /// 头像
    lazy var iconImageView = UIImageView(image: UIImage(named: "icon_app")!)
    
    /// 内容
    lazy var contentLabel = UILabel(color: .randomColor(), title: "在吗？", fontSize: 14, mutiLines: true, fontName: Font.PingFangSCLight)
    
    /// 内容底部图
    lazy var contentImageView = UIImageView(image: UIImage(named: "content_feedback"))
    
    var data: Feedback? {
        didSet {
            if let data = data {
                timeLabel.text = data.create_time
//                iconImageView.sd_setImageWithURL(NSURL(string: data.image), placeholderImage: PlaceholderImage.defaultSmall)
                contentLabel.text = data.content
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(contentImageView)
        initAutoLayout()
    }
    
    private func initAutoLayout() {
        timeLabel.ff_AlignInner(.TopCenter, referView: contentView, size: nil, offset: CGPointMake(0, 18))
        iconImageView.ff_AlignInner(.TopRight, referView: contentView, size: CGSizeMake(35, 35), offset: CGPointMake(-9, 53))
        contentLabel.ff_AlignHorizontal(.TopLeft, referView: iconImageView, size: nil, offset: CGPointMake(-12, 0))
        contentImageView.ff_AlignHorizontal(.CenterCenter, referView: contentLabel, size: nil, offset: CGPointMake(-12, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FeedBackSytemTableViewCell: FeedBackMyTableViewCell {
    
    private override func initAutoLayout() {
        timeLabel.ff_AlignInner(.TopCenter, referView: contentView, size: nil, offset: CGPointMake(0, 18))
        iconImageView.ff_AlignInner(.TopLeft, referView: contentView, size: CGSizeMake(35, 35), offset: CGPointMake(9, 53))
        contentLabel.ff_AlignHorizontal(.TopRight, referView: iconImageView, size: nil, offset: CGPointMake(12, 0))
        contentImageView.ff_AlignHorizontal(.TopRight, referView: iconImageView, size: nil, offset: CGPointMake(12, 0))
    }
}
