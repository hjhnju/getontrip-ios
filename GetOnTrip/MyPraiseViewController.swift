//
//  MyPraiseViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh

class MyPraiseViewController: MenuViewController, UITableViewDelegate, UITableViewDataSource {
    /// 网络请求加载数据
    lazy var lastRequest: MyPraiseRequest = MyPraiseRequest()
    
    lazy var tableView: UITableView = UITableView()
    
    let collectPrompt = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.3), title: "还木有点赞过...\n为你喜欢的内容点个赞吧(∩_∩)", fontSize: 13, mutiLines: true)
    
    var collectContent = [CollectContent]() {
        didSet {
            if collectContent.count == 0 {
                collectPrompt.hidden = false
            } else {
                collectPrompt.hidden = true
            }
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperty()
        if globalUser != nil {
            initRefresh()
        } else {
            collectPrompt.hidden = false
        }
    }
    
    private func initProperty() {
        
        view.backgroundColor = .whiteColor()
        navBar.titleLabel.text = "我赞过的"
        view.addSubview(tableView)
        tableView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64)
        tableView.addSubview(collectPrompt)
        collectPrompt.ff_AlignInner(.TopCenter, referView: tableView, size: nil, offset: CGPointMake(0, 135))
        collectPrompt.textAlignment = .Center
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")
        
        tableView.separatorStyle = .None
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(CollectContentVideoCell.self, forCellReuseIdentifier: CollectContentVideoCellIdentifier)
        tableView.registerClass(CollectContentBookCell.self, forCellReuseIdentifier: CollectContentBookCellIdentifier)
        tableView.registerClass(CollectContentCell.self, forCellReuseIdentifier: CollectContentCellIdentifier)
    }
    
    private func initRefresh() {
        //上拉刷新
        let tbHeaderView = MJRefreshNormalHeader(refreshingBlock: loadData)
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
        let tbFooterView = MJRefreshAutoNormalFooter(refreshingBlock: loadMore)
        tbFooterView.automaticallyRefresh = true
        tbFooterView.automaticallyChangeAlpha = true
        tbFooterView.activityIndicatorViewStyle = .White
        tbFooterView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbFooterView.stateLabel?.textColor = SceneColor.lightGray
        
        tableView.mj_header = tbHeaderView
        tableView.mj_footer = tbFooterView
        
        loadData()
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collectContent.count == 0 { collectPrompt.hidden = false } else { collectPrompt.hidden = true }
        return collectContent.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: BaseTableViewCell?
        let data = collectContent[indexPath.row] as CollectContent
        
        
        if data.type == "1" {
            cell = tableView.dequeueReusableCellWithIdentifier(CollectContentCellIdentifier, forIndexPath: indexPath) as! CollectContentCell
            cell?.data = data
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(CollectContentBookCellIdentifier, forIndexPath: indexPath) as! CollectContentBookCell
            cell?.data = data
        }
        
        if indexPath.row == collectContent.count - 1 {
            cell?.baseline.hidden = true
        } else {
            cell?.baseline.hidden = false
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let col = collectContent[indexPath.row] as CollectContent
        switch Int(col.type ?? "0") {
        case FavoriteContant.TypeTopic?:
            let vc = TopicViewController()
            let topic = Topic()
            topic.id       = col.id
            topic.image    = col.image
            topic.title    = col.title
            topic.subtitle = col.subtitle
            vc.topicDataSource = topic
            navigationController?.pushViewController(vc, animated: true)
        case FavoriteContant.TypeBook?:
            let vc = BookViewController()
            let book = Book(id: col.id)
            book.image = col.image
            book.title = col.title
            vc.bookDataSource = book
            navigationController?.pushViewController(vc, animated: true)
        case FavoriteContant.TypeVideo?:
            let vc = DetailWebViewController()
            let video = Video()
            video.url = col.url
            video.id  = col.id
            video.collected = "1"
            vc.video  = video
            vc.url    = col.url
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let collect = collectContent[indexPath.row] as CollectContent
        return collect.type == "4" ? 107 : 125
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
        
        lastRequest.fetchFirstPageModels {[weak self] (result, status) -> Void in
            //处理异常状态
            if RetCode.SUCCESS != status {
                ProgressHUD.showErrorHUD(self?.view, text: MessageInfo.NetworkError)
                self?.tableView.mj_header.endRefreshing()
                self?.isLoading = false
                return
            }
            
            if let data = result {
                self?.tableView.mj_header.endRefreshing()
                self?.collectContent = data
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
        self.lastRequest.fetchNextPageModels { [weak self] (result, status) -> Void in
            
            if let data = result {
                if data.count > 0 {
                    if let cells = self?.collectContent {
                        self?.collectContent = cells + data
                    }
                    self?.tableView.mj_footer.endRefreshing()
                } else {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            self?.isLoading = false
        }
    }
}