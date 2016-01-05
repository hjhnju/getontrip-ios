//
//  FeedBackViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh

class FeedBackViewController: MenuViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let name = "反馈"
    
    lazy var tableView: UITableView = UITableView()
    
    /// 反馈情况(历史)
    var lastRequest: FeedbackRequest = FeedbackRequest()

    /// 发送按钮
    lazy var sendButton: UIButton = UIButton(title: "发送", fontSize: 12, radius: 34 * 0.5, titleColor: SceneColor.fontGray, fontName: Font.PingFangSCLight)
    
    /// 发送文字
    lazy var sendContentText: UITextField = UITextField()
    
    /// 底view
    lazy var commentBottomView: UIView = UIView()
    
    var dataSource: [Feedback] = [Feedback]()
    
    var tableViewConH: NSLayoutConstraint?
    
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
        automaticallyAdjustsScrollViewInsets = true
        view.backgroundColor = .whiteColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    /// 初始化底部
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
    
    /// 实始化tableview
    private func initTableView() {
        
        view.addSubview(tableView)
        let cons = tableView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(Frame.screen.width, Frame.screen.height - 64 - 50), offset: CGPointMake(0, 64))
        tableViewConH = tableView.ff_Constraint(cons, attribute: .Height)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.registerClass(FeedBackMyTableViewCell.self, forCellReuseIdentifier: "FeedBackMyTableViewCell")
        tableView.registerClass(FeedBackSytemTableViewCell.self, forCellReuseIdentifier: "FeedBackSytemTableViewCell")
    }
    
    /// 初始化刷新方法
    private func initRefresh() {
        //上拉刷新
        let tbHeaderView = MJRefreshNormalHeader { [weak self] () -> Void in self?.loadMore() }
        tbHeaderView.automaticallyChangeAlpha = true
        tbHeaderView.activityIndicatorViewStyle = .Gray
        tbHeaderView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbHeaderView.lastUpdatedTimeLabel?.font = UIFont.systemFontOfSize(11)
        tbHeaderView.stateLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.hidden = true
        tbHeaderView.stateLabel?.hidden = true
        tbHeaderView.arrowView?.image = UIImage()
        tableView.mj_header = tbHeaderView
    }
    
    // MARK: - tableView dataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    var lastIndexPath: NSIndexPath?
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        lastIndexPath = indexPath
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
        return FeedBackMyTableViewCell.heightWithFeedBack(dataSource[indexPath.row])
    }
    
    /// 当键盘弹出的时候，执行相关操作
    func keyboardChanged(not: NSNotification) {
        
        let keyBoardFrame = not.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        let keyBoardY = keyBoardFrame?.origin.y
        let transFromValue = keyBoardY! - view.bounds.height
        commentBottomView.transform = CGAffineTransformMakeTranslation(0, transFromValue)
        tableView.transform = CGAffineTransformMakeTranslation(0, transFromValue)
        if dataSource.count != 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: dataSource.count - 1, inSection: 0), atScrollPosition: .None, animated: true)
        }
    }
    
    /// 是否正在加载中
    var isLoading:Bool = false
    
    /// 注意：不能在loadData中进行beginRefreshing, beginRefreshing会自动调用loadData
    private func loadData() {

        if self.isLoading { return }
        self.isLoading = true
        
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
                self?.dataSource.sortInPlace({ (fb1, fb2) -> Bool in
                    fb1.create_time < fb2.create_time
                })
                self?.tableView.reloadData()
            }
            self?.isLoading = false
        }
    }
    
    /// 底部加载更多
    func loadMore(){
        if self.isLoading { return }
        self.isLoading = true
        //请求下一页
        self.lastRequest.fetchListNextPageModels { [weak self] (result, status) -> Void in
            
            if let data = result {
                if data.count > 0 {
                    self?.dataSource.insertContentsOf(data, at: 0)
                    self?.dataSource.sortInPlace({ (fb1, fb2) -> Bool in
                        fb1.create_time < fb2.create_time
                    })
                    self?.tableView.reloadData()
                    //                        self?.dataSource = cells + dataSource
                    self?.tableView.mj_header.endRefreshing()
                } else {
                    self?.tableView.mj_header.endRefreshing()
                }
            }
            self?.isLoading = false
        }
    }
    
    /// 发送反馈消息
    func sendFeedBackMessage() {
        
        let content = sendContentText.text ?? ""
        if content == "" {
            ProgressHUD.showErrorHUD(nil, text: "请先输入需要反馈的消息")
            return
        }
        isLoginAction(content)
    }
    
    private func isLoginAction(content: String) {
        
        lastRequest.fetchSendModels(content) { [weak self] (result, status) -> Void in
            if status == RetCode.SUCCESS {
                // TODO: - 需要将反馈的信息在这里显示
                self?.sendContentText.text = ""
                self?.addReceivedInfo(content)
                return
            }
        }
    }
    
    /// 添加回复信息
    private func addReceivedInfo(content: String) {
        
        let format = NSDateFormatter()
        format.locale = NSLocale(localeIdentifier: "en")
        format.dateFormat = "yyyy-MM-dd HH:mm"
        let dest = format.stringFromDate(NSDate())
        
        let fb = Feedback()
        fb.content = content
        fb.type = "1"
        fb.create_time = dest
        fb.isShowTime = dataSource.last?.create_time == fb.create_time ? true : false
        dataSource.append(fb)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: dataSource.count - 1, inSection: 0)], withRowAnimation: .Bottom)
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: dataSource.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: false)
    }
    
    // scrollerview delegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if sendContentText.isFirstResponder() {
            sendContentText.resignFirstResponder()
        }
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
    }
    
    private func scrollToBottom() {
        var yOffset: CGFloat = 0
        if tableView.contentSize.height > tableView.bounds.size.height {
            yOffset = tableView.contentSize.height - tableView.bounds.size.height
        }
        tableView.setContentOffset(CGPointMake(0, yOffset), animated: false)
    }
    
    /// 注销通知
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}