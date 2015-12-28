//
//  RecommendHotController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/28.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class RecommendHotController: UITableViewController {
    
    var order = "1" {
        didSet {
            lastRequest.order = order
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

        refreshControl = UIRefreshControl()
        lastRequest.isLoadType = RecommendLoadType.TypeContent
        loadData()
    }

    // MASKS: - tableView 数据源及代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendCells.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = recommendCells[indexPath.row]
        if data.isTypeTopic() {
            let cell = tableView.dequeueReusableCellWithIdentifier(RecommendContant.recommendTopicViewCellID, forIndexPath: indexPath) as! RecommendTopicViewCell
            cell.backgroundColor = UIColor.clearColor()
            cell.data = recommendCells[indexPath.row]
            
            let factor = calcFactor(cell.frame.origin.y + RecommendContant.rowHeight, yOffset: 0)
            cell.cellImageView.updateFactor(factor)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(RecommendContant.recommendTableViewCellID, forIndexPath: indexPath) as! RecommendTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.data = recommendCells[indexPath.row]
        
        let factor = calcFactor(cell.frame.origin.y + RecommendContant.rowHeight, yOffset: 0)
        cell.cellImageView.updateFactor(factor)
        
        return cell
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
        parentViewController
        print(parentViewController)
        (parentViewController as? RecommendViewController)?.yOffset = scrollView.contentOffset.y
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        //导航渐变
        let threshold:CGFloat = 198 - 64
        let offsetY = scrollView.contentOffset.y
        let gap = RecommendContant.headerViewHeight + offsetY
        let vc = parentViewController as? RecommendViewController
        if gap > 0 {
            vc?.navBarAlpha = gap / threshold;
            if vc?.navBarAlpha > 1 {
                vc?.navBarAlpha = 1
            } else if vc?.navBarAlpha < 0.1 {
                vc?.navBarAlpha = 0
            }
        }
        
        //headerView高度动态变化
        let initTop: CGFloat = 0.0
        let newTop = min(-gap, initTop)
        vc?.headerViewTopConstraint?.constant = newTop
        
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
        tableView.mj_footer.resetNoMoreData()
        
        lastRequest.fetchFirstPageModels {[weak self] (result, status) -> Void in
            //处理异常状态
            if RetCode.SUCCESS != status {
                    ProgressHUD.showErrorHUD(self?.view, text: "您的网络无法连接")
                }
                self?.tableView.mj_header.endRefreshing()
                self?.isLoading = false
                return
            
            //处理返回数据
            if let dataSource = result {
                self?.recommendCells = dataSource.contents
            }
            
            self?.tableView.mj_header.endRefreshing()
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
                }
            }
            self?.isLoading = false
        }
    }
    
    /// 网络异常重现加载
    func refreshFromErrorView(sender: UIButton){
        tableView.hidden = false
        //重新加载
        if !tableView.mj_header.isRefreshing() {
            tableView.mj_header.beginRefreshing()
        }
    }
    
//    func loadHeaderImage(url: String?) {
//        if let url = url {
//            //从网络获取
//            headerImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "default_picture"))
//        }
//    }

}
