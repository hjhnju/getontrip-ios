//
//  RecommendViewController+extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/10.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

extension RecommendViewController {
    
    // MASKS: - tableView 数据源及代理方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendCells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = recommendCells[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if ( data.isTypeSight()) {
            let vc = SightViewController()
            let sight = Sight(id: data.id)
            sight.name = data.name
            sight.image = data.image
            vc.sightDataSource = sight
            navigationController?.pushViewController(vc, animated: true)
        } else if( data.isTypeCity()) {
            let vc = CityViewController()
            let city = City(id: data.id)
            city.name = data.name
            city.image = data.image
            vc.cityDataSource = city
            navigationController?.pushViewController(vc, animated: true)
        } else if( data.isTypeTopic()) {
            let vc = TopicViewController()
            let topic = Topic(id: data.id)
            topic.title = data.name
            topic.image = data.image
            topic.sightid = data.param4
            vc.topicDataSource = topic
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        yOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //导航渐变
        let threshold:CGFloat = 198 - 64
        let offsetY = scrollView.contentOffset.y
        let gap = RecommendContant.headerViewHeight + offsetY
        if gap > 0 {
            navBarAlpha = gap / threshold;
            if navBarAlpha > 1 {
                navBarAlpha = 1
            } else if navBarAlpha < 0.1 {
                navBarAlpha = 0
            }
        }
        
        //headerView高度动态变化
        let initTop: CGFloat = 0.0
        let newTop = min(-gap, initTop)
        headerViewTopConstraint?.constant = newTop
        
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
    
    //触发搜索列表的方法
    func clkSearchLabelMethod(sender: RecommendButton) {
        if sender.tag == currentSearchLabelButton?.tag { return }
        
        sender.selected = true
        sender.numLabel.textColor = UIColor.whiteColor()
        currentSearchLabelButton?.selected = false
        currentSearchLabelButton?.numLabel.textColor = UIColor(hex: 0xFFFFFF, alpha: 0.6)
        currentSearchLabelButton = sender
        
        lastRequest?.order = String(sender.tag)
        tableView.mj_header.beginRefreshing()
    }
    
    /// 发送搜索信息
    /// 注意：不能在loadData中进行beginRefreshing, beginRefreshing会自动调用loadData
    func loadData() {
        if isLoading {
            return
        }
        
        isLoading = true
        errorView.hidden = true
        
        //清空footer的“加载完成”
        tableView.mj_footer.resetNoMoreData()
        if lastRequest == nil {
            lastRequest = RecommendRequest()
            lastRequest?.order = "1" //默认返回带所有搜索标签
        }
        
        lastRequest?.fetchFirstPageModels {[weak self] (data, status) -> Void in
            //处理异常状态
            if RetCode.SUCCESS != status {
                if self?.recommendCells.count == 0 {
                    //当前无内容时显示出错页
                    self?.tableView.hidden = true
                    self?.errorView.hidden = false
                } else {
                    //当前有内容显示出错浮层
                    ProgressHUD.showErrorHUD(self?.view, text: "您的网络无法连接")
                }
                self?.tableView.mj_header.endRefreshing()
                self?.isLoading = false
                return
            }
            
            //处理返回数据
            if let dataSource = data {
                let cells  = dataSource.objectForKey("cells") as! [RecommendCellData]
                //有数据才更新
                if cells.count > 0 {
                    self?.recommendCells = cells
                }
                let labels = dataSource.objectForKey("labels") as! [RecommendLabel]
                if labels.count > 0 {
                    self?.recommendLabels = labels
                }
                self?.loadHeaderImage(dataSource.objectForKey("image") as? String)
                self?.tableView.reloadData()
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
        lastRequest?.fetchNextPageModels { [weak self] (data, status) -> Void in
            
            if let dataSource = data {
                let newCells  = dataSource.objectForKey("cells") as! [RecommendCellData]
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
        errorView.hidden = true
        tableView.hidden = false
        //重新加载
        if !tableView.mj_header.isRefreshing() {
            tableView.mj_header.beginRefreshing()
        }
    }
    
    func loadHeaderImage(url: String?) {
        if let url = url {
            //从网络获取
            headerImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: PlaceholderImage.defaultLarge)
        }
    }

    func defaultPromptTextHidden(textFiled: UITextField) {
        if textFiled.text == "" || textFiled.text == nil {
            defaultPrompt.titleLabel?.hidden = false
        } else {
            defaultPrompt.titleLabel?.hidden = true
        }
    }
    
}