//
//  RecommendHotController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/28.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh

class RecommendHotController: UITableViewController {
    
    var order = "1" {
        didSet {
            lastRequest.order = order
            loadData()
        }
    }
    
    /// 网络请求加载数据(添加)
    var lastRequest: RecommendRequest = RecommendRequest()
    
    /// 是否正在加载中
    var isLoading:Bool = false
    
    /// 数据源 - 推荐列表数据
    var recommendCells  = [RecommendCellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()
        initRefresh()
    }
    
    private func initTableView() {
        lastRequest.isLoadType = RecommendLoadType.TypeContent
        tableView.registerClass(RecommendTopicViewCell.self, forCellReuseIdentifier: "RecommendTopicViewCell")
        tableView.registerClass(RecommendTableViewCell.self, forCellReuseIdentifier: "RecommendTableViewCell")
        tableView.rowHeight = 192
        tableView.contentInset = UIEdgeInsets(top: 255, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clearColor()
        tableView.separatorStyle = .None
    }
    
    // TODO: - 下拉刷新用系统的上拉刷新用框架 
    /// 初始化刷新控件
    private func initRefresh() {
        // 下拉刷新
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)
        
        //上拉刷新        
        let tbFooterView = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] () -> Void in self?.loadMore() })
        tableView.mj_footer = tbFooterView
        tbFooterView.automaticallyHidden = false
        tbFooterView.automaticallyRefresh = true
        tbFooterView.automaticallyChangeAlpha = true
        tbFooterView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        tbFooterView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbFooterView.stateLabel?.textColor = SceneColor.lightGray
        
        tableView.mj_footer = tbFooterView
    }

    // MASKS: - tableView 数据源及代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendCells.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = recommendCells[indexPath.row]
        
        var cell: UITableViewCell?
        if data.isTypeTopic() {
            cell = tableView.dequeueReusableCellWithIdentifier("RecommendTopicViewCell", forIndexPath: indexPath) as! RecommendTopicViewCell
            (cell as! RecommendTopicViewCell).data = recommendCells[indexPath.row]
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("RecommendTableViewCell", forIndexPath: indexPath) as! RecommendTableViewCell
            (cell as! RecommendTableViewCell).data = recommendCells[indexPath.row]
        }
        
        cell!.backgroundColor = UIColor.clearColor()
        let factor = calcFactor(cell!.frame.origin.y + RecommendContant.rowHeight, yOffset: 0)
        (cell as? RecommendTopicViewCell)?.cellImageView.updateFactor(factor)
        (cell as? RecommendTableViewCell)?.cellImageView.updateFactor(factor)
        if indexPath.row == recommendCells.count - 2 { loadMore() }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = recommendCells[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if ( data.isTypeSight()) {
            let vc = SightViewController()
            let sight = Sight(id: data.id)
            sight.name = data.name
            sight.image = data.image
            sight.bgColor = data.bgColor
            vc.sightDataSource = sight
            navigationController?.pushViewController(vc, animated: true)
        } else if( data.isTypeCity()) {
            let vc = CityViewController()
            let city = City(id: data.id)
            city.name = data.name
            city.image = data.image
            city.bgColor = data.bgColor
            vc.cityDataSource = city
            navigationController?.pushViewController(vc, animated: true)
        } else if( data.isTypeTopic()) {
            let vc = TopicViewController()
            let topic = Topic(id: data.id)
            topic.title = data.name
            topic.image = data.image
            topic.sightid = data.param4
            topic.bgColor = data.bgColor
            vc.topicDataSource = topic
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        (parentViewController as? RecommendViewController)?.yOffset = scrollView.contentOffset.y
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {

        let vc = parentViewController as? RecommendViewController
        if scrollView.contentOffset.y > -64 { // 禁止滚动
            vc?.collectionView.scrollEnabled = false
        } else { // 开始滚动
            vc?.collectionView.scrollEnabled = true
        }
        vc?.contentOffSet = scrollView.contentOffset
        vc?.scrollViewDidScroll(scrollView)
        
        let gap = RecommendContant.headerViewHeight + scrollView.contentOffset.y
        for vcell in tableView.visibleCells {
            if let cell = vcell as? RecommendTableViewCell {
                let factor = calcFactor(cell.frame.origin.y + RecommendContant.rowHeight, yOffset: gap)
                cell.cellImageView.updateFactor(factor)
            } else if let cell = vcell as? RecommendTopicViewCell {
                let factor = calcFactor(cell.frame.origin.y + RecommendContant.rowHeight, yOffset: gap)
                cell.cellImageView.updateFactor(factor)
            }
        }
    }
    
    
    private func calcFactor(frameY:CGFloat, yOffset: CGFloat) -> CGFloat {
        //以屏幕左上为原点的坐标
        let realY = frameY - yOffset
        let centerY = UIScreen.mainScreen().bounds.height / 2 - RecommendContant.rowHeight / 2
        //距离cell中间的距离
        let gapToCenter = -(realY - centerY)
        var divider = UIScreen.mainScreen().bounds.height / 2 - RecommendContant.rowHeight / 2
        if gapToCenter < 0 {
            divider = UIScreen.mainScreen().bounds.height / 2 - RecommendContant.rowHeight / 2
        }
        let factor: CGFloat = fmin(1.0, fmax(gapToCenter / divider, -1.0))
        //print("gap=\(gapToCenter), offsetY=\(yOffset), frame.y=\(frameY), realY=\(realY), centerY=\(centerY), factor=\(factor)")
        return factor
    }
    
    //MARK: 自定义方法
    func loadData() {
        if isLoading {
            return
        }
        
        isLoading = true
        
        //清空footer的“加载完成”
        lastRequest.fetchFirstPageModels {[weak self] (result, status) -> Void in
            self?.refreshControl?.endRefreshing()
            //处理异常状态
            if RetCode.SUCCESS != status {
                    ProgressHUD.showErrorHUD(self?.view, text: "您的网络无法连接")
                self?.isLoading = false
                return
            }
            
            //处理返回数据
            if result?.contents.count > 0 {
                self?.recommendCells = result?.contents ?? [RecommendCellData]()
                self?.tableView.reloadData()
            }
            self?.isLoading = false
        }
    }
    
    /// 底部加载更多
    func loadMore(){
        if isLoading {
            return
        }
        isLoading = true
        //请求下一页
        lastRequest.fetchNextPageModels { [weak self] (result, status) -> Void in
            if let dataSource = result {
                let newCells  = dataSource.contents
                if newCells.count > 0 {
                    if let cells = self?.recommendCells {
                        self?.recommendCells = cells + newCells
                        self?.tableView.reloadData()
                    }
                    self?.tableView.mj_footer.endRefreshing()
                } else {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    UIView.animateWithDuration(2, animations: { [weak self] () -> Void in
                        self?.tableView.mj_footer.alpha = 0.0
                        }, completion: { (_) -> Void in
                            self?.tableView.mj_footer.resetNoMoreData()
                    })
                    
                }
            }
            self?.isLoading = false
        }
    }
}
