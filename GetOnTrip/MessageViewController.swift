//
//  MessageViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import MJRefresh

class MessageViewController: MenuViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    static let name = "消息"

    /// 请求
    var lastRequest: MessageListRequest = MessageListRequest()
    /// tableView
    lazy var tableView: MessageTableView = MessageTableView()
    /// 左侧滑动view
    lazy var slideView: UIView = UIView()
    /// 未收到消息提示
    let collectPrompt = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.3), title: "您暂时还未收到任何消息\n(∩_∩)", fontSize: 13, mutiLines: true)
    /// 消息列表
    var messageLists: [MessageList] = [MessageList]() {
        didSet {
            if messageLists.count == 0 {
                collectPrompt.hidden = true
            } else {
                collectPrompt.hidden = false
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperty()
        if globalUser != nil {
            initRefresh()
        }
    }
    
    private func initProperty() {
        
        title = "消息"
        automaticallyAdjustsScrollViewInsets = false
        navBar.setTitle(MessageViewController.name)
        
        view.backgroundColor = SceneColor.bgBlack
        view.addSubview(tableView)
        view.addSubview(collectPrompt)
        
    
        tableView.addSubview(collectPrompt)
        view.addSubview(slideView)
        slideView.frame = CGRectMake(0, 0, 50, UIScreen.mainScreen().bounds.height)
        collectPrompt.ff_AlignInner(.TopCenter, referView: tableView, size: nil, offset: CGPointMake(0, 135))
        collectPrompt.textAlignment = NSTextAlignment.Center
        collectPrompt.hidden = true
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: "Message_Cell")
        tableView.registerClass(SystemTableViewCell.self, forCellReuseIdentifier: "SystemTableView_Cell")
    }
    

    private func initRefresh() {
        //上拉刷新
        let tbHeaderView = MJRefreshNormalHeader(refreshingBlock: loadData)
        tbHeaderView.automaticallyChangeAlpha = true
        tbHeaderView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        tbHeaderView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbHeaderView.lastUpdatedTimeLabel?.font = UIFont.systemFontOfSize(11)
        tbHeaderView.stateLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.hidden = true
        tbHeaderView.stateLabel?.hidden = true
        tbHeaderView.arrowView?.image = UIImage()
        
        //下拉刷新
        let tbFooterView = MJRefreshAutoNormalFooter(refreshingBlock: loadMore)
        tbFooterView.automaticallyRefresh = true
        tbFooterView.automaticallyChangeAlpha = true
        tbFooterView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        tbFooterView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbFooterView.stateLabel?.textColor = SceneColor.lightGray
        
        self.tableView.mj_header = tbHeaderView
        self.tableView.mj_footer = tbFooterView
        
        if !tableView.mj_header.isRefreshing() {
            tableView.mj_header.beginRefreshing()
        }
    }
    
    var isGestureRecognizer: Bool = true
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        isGestureRecognizer = true
        slideView.tag = 1
        self.gestureRecognizer(UIGestureRecognizer(), shouldRecognizeSimultaneouslyWithGestureRecognizer: UIGestureRecognizer())
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let touch = UITouch()
        touch.setValue(slideView, forKey: "view")
        slideView.tag = 2
        self.gestureRecognizer(UIGestureRecognizer(), shouldReceiveTouch: touch)
        
        isGestureRecognizer = false
        self.gestureRecognizer(UIGestureRecognizer(), shouldRecognizeSimultaneouslyWithGestureRecognizer: UIGestureRecognizer())
    }

    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messageLists.count == 0 { collectPrompt.hidden = false } else { collectPrompt.hidden = true }
        return messageLists.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mes = messageLists[indexPath.row] as MessageList
        
        if mes.type == "1" {
            let cell = tableView.dequeueReusableCellWithIdentifier("SystemTableView_Cell", forIndexPath: indexPath) as! SystemTableViewCell
            cell.message = mes
            if messageLists.count - 1 == indexPath.row {
                cell.baseline.removeFromSuperview()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Message_Cell", forIndexPath: indexPath) as! MessageTableViewCell
            cell.message = mes
            
            if messageLists.count - 1 == indexPath.row {
                cell.baseline.removeFromSuperview()
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let mes = messageLists[indexPath.row] as MessageList
        if mes.type == "1" {
            return SystemTableViewCell.messageWithHeight(mes)
        }
        return 75
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let data = messageLists[indexPath.row] as MessageList
        
        if data.type != "1" {
            let vc = TopicViewController()
            let topic = Topic(id: data.topicId)
            vc.topicDataSource = topic
            navigationController?.pushViewController(vc, animated: true)
            vc.doComment(UIButton())
        }
    }
    
    // 删除方法
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle != UITableViewCellEditingStyle.Delete { return }
        
        let msg = messageLists[indexPath.row]
        MessageListRequest.deleteMessage(msg.mid) { (result, status) -> Void in
            if status == RetCode.SUCCESS {
                self.messageLists.removeAtIndex(indexPath.row)
                tableView.reloadData()
                ProgressHUD.showErrorHUD(self.view, text: "删除成功")

            } else {
                ProgressHUD.showErrorHUD(self.view, text: "删除失败，请重新删除")
            }
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
        
        lastRequest.fetchFirstPageModels {[weak self] (data, status) -> Void in
            //处理异常状态
            if RetCode.SUCCESS != status {
                ProgressHUD.showErrorHUD(self?.view, text: "您的网络不给力！")
                self?.tableView.mj_header.endRefreshing()
                self?.isLoading = false
                return
            }
            
            if let dataSource = data {
                self?.tableView.mj_header.endRefreshing()
                self?.messageLists = dataSource
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
        self.lastRequest.fetchNextPageModels { [weak self] (data, status) -> Void in
            
            if let dataSource = data {
                if dataSource.count > 0 {
                    if let cells = self?.messageLists {
                        self?.messageLists = cells + dataSource
                    }
                    self?.tableView.mj_footer.endRefreshing()
                } else {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            self?.isLoading = false
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return isGestureRecognizer
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if touch.view!.isKindOfClass(NSClassFromString("GetOnTrip.MessageTableView")!) {
            return false
        }
        if (touch.view!.isKindOfClass(NSClassFromString("UITableViewCellContentView")!) && slideView.tag == 1) {
            return false
        }
        return true
    }
}

