//
//  RecommendViewController+extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/10.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

extension RecommendViewController {
    
    // MARK: - collectionView 数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath)
        if indexPath.row == 0 {
            cell.addSubview(hotContentVC.tableView)
            hotContentVC.view.ff_Fill(cell)
            hotContentVC.tableView.contentOffset = contentOffSet
        } else if indexPath.row == 1 {
            cell.addSubview(hotSightVC.tableView)
            hotSightVC.view.ff_Fill(cell)
            hotSightVC.tableView.contentOffset = contentOffSet
        }
        
        return cell
    }
    
    /// MARK: - 切换收藏视图方法
    func switchCollectButtonClick(sender: UIButton) {
        
        let indexPath = NSIndexPath(forItem: sender.tag, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        yOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        if scrollView.contentOffset.x != 0 { // 防止上下滑动
            titleSelectView.selectView.frame.origin.x = scrollView.contentOffset.x * 0.5
            let isSelected = titleSelectView.selectView.center.x < Frame.screen.width * 0.5 ? true : false
            titleSelectView.hotContentButton.selected = isSelected
            titleSelectView.hotSightButton.selected   = !isSelected
        }
        
        if scrollView.contentOffset.y == 0 { return }
        
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
    /// 发送搜索信息
    /// 注意：不能在loadData中进行beginRefreshing, beginRefreshing会自动调用loadData
    func loadData() {
        
        errorView.hidden = true
        lastRequest.isLoadType = RecommendLoadType.TypeLabelAndImages
        lastRequest.fetchFirstPageModels {[weak self] (result, status) -> Void in
            //处理异常状态
            if RetCode.SUCCESS != status {
                if self?.recommendLabels.count == 0 {
                    //当前无内容时显示出错页
                    self?.collectionView.hidden = true
                    self?.errorView.hidden = false
                } else {
                    //当前有内容显示出错浮层
                    ProgressHUD.showErrorHUD(self?.view, text: "您的网络无法连接")
                }
                return
            }
            
            //处理返回数据
            if let data = result {
                self?.recommendLabels = data.labels
                self?.headerImagesData = data.images
            }
        }
    }
    
    /// 网络异常重现加载
    func refreshFromErrorView(sender: UIButton){
        errorView.hidden = true
        loadData()
    }

    func defaultPromptTextHidden(textFiled: UITextField) {
        if textFiled.text == "" || textFiled.text == nil {
            defaultPrompt.titleLabel?.hidden = false
        } else {
            defaultPrompt.titleLabel?.hidden = true
        }
    }
}