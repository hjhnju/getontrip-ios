//
//  MyCommentViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh

class MyCommentViewController: MenuViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var tableView = UITableView()
    
    /// 网络请求加载数据
    var lastRequest: MyCommentRequest = MyCommentRequest()
    
    /// 提示
    let promptLabel = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.3), title: "还木有评论...\n开始发表评论吧(∩_∩)", fontSize: 13, mutiLines: true)
    
    var dataSource: [MyComment] = [MyComment]() {
        didSet {
            promptLabel.hidden = dataSource.count == 0 ? false : true
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initTableView()
        view.addSubview(promptLabel)
        promptLabel.ff_AlignInner(.CenterCenter, referView: view, size: nil)
        promptLabel.textAlignment = .Center
        initRefresh()
        loadData()
    }
    
    private func initView() {
        navBar.titleLabel.text = "我的评论"
        view.backgroundColor = .whiteColor()
        automaticallyAdjustsScrollViewInsets = false
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")
    }
    
    private func initTableView() {
        view.addSubview(tableView)
        tableView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64)
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerClass(MyCommentTableViewCell.self, forCellReuseIdentifier: "MyCommentTableViewCell")
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
    
    // MARK: - tableview delegate and datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCommentTableViewCell", forIndexPath: indexPath) as! MyCommentTableViewCell
        cell.dataSource = dataSource[indexPath.row]        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = TopicViewController()
        let topic = Topic(id: dataSource[indexPath.row].id)
        vc.topicDataSource = topic
        navigationController?.pushViewController(vc, animated: true)
        vc.doComment(UIButton())
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let data = dataSource[indexPath.row]
        return MyCommentTableViewCell.heightWithMyComment(data)
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
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
        self.lastRequest.fetchNextPageModels { [weak self] (data, status) -> Void in
            
            if let dataSource = data {
                if dataSource.count > 0 {
                    if let cells = self?.dataSource {
                        self?.dataSource = cells + dataSource
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
