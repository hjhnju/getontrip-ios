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
        collectionView.scrollToItemAtIndexPath( NSIndexPath(forItem: sender.tag, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        yOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        if scrollView.contentOffset.x != 0 { switchHotLabelAction(scrollView) }
        if scrollView.contentOffset.y == 0 || searchController.isEnterSearchController { return }
        
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

        if offsetY < -64 && offsetY > -120 {
            if searchBarW?.constant < 51 { changeSearchBar(64 * 0.5 - 10) }
            return
        }
        
        if offsetY > -120 { // 变圆
            changeRound()
            searchController.searchBar.leftView.hidden = true
        } else { // 变回去
            if isUpdataSearchBarFrame {
               changeSearchBar(newTop + RecommendContant.searchBarTopY)
            } else {
                searchBarTopY?.constant = newTop + RecommendContant.searchBarTopY
            }
        }
    }
    
    /// 切换热门标签方法
    private func switchHotLabelAction(scrollView: UIScrollView) {
        titleSelectView.selectView.frame.origin.x = scrollView.contentOffset.x * 0.5
        let isSelected = titleSelectView.selectView.center.x < Frame.screen.width * 0.5 ? true : false
        titleSelectView.hotContentButton.selected = isSelected
        titleSelectView.hotSightButton.selected   = !isSelected
        navTitleLabel.text = isSelected ? recommendLabels[0].name : recommendLabels[1].name
    }
    
    /// 变搜索框
    private func changeSearchBar(changeY: CGFloat) {
        searchBarW?.constant = Frame.screen.width * 0.69
        searchController.searchBar.updateWidthFrame(Frame.screen.width * 0.69 - 9)
        searchController.searchBar.tempUpdateFrame = Frame.screen.width * 0.69
        searchController.searchBar.defaultPromptButton.titleLabel?.alpha = 1

        self.searchBarMaxX?.constant = 0
        self.searchBarTopY?.constant = changeY
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.searchController.searchBar.layoutIfNeeded()
            self.navTitleLabel.alpha = 0
            }, completion: { (_) -> Void in
                self.isUpdataSearchBarFrame = false
        })
    }
    
    /// 变圆
    private func changeRound() {
        searchBarW?.constant = 48
        searchController.searchBar.updateWidthFrame(50 - 15.5)
        searchController.searchBar.tempUpdateFrame = 48
        searchBarMaxX?.constant = Frame.screen.width * 0.5 - 30
        searchController.searchBar.defaultPromptButton.titleLabel?.alpha = 0
        searchBarTopY?.constant = 64 * 0.5 - 8
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.searchController.searchBar.layoutIfNeeded()
            }, completion: { (_) -> Void in
                self.isUpdataSearchBarFrame = true
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.navTitleLabel.alpha = 1.0
                })
        })
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
        return fmin(1.0, fmax(gapToCenter / divider, -1.0))
    }
    
    //MARK: 加载数据方法
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
                self?.collectionView.reloadData()
                self?.hotContentVC.loadData()
                self?.hotSightVC.loadData()
            }
        }
    }
    
    /// 网络异常重现加载
    func refreshFromErrorView(sender: UIButton){
        errorView.hidden = true
        loadData()
    }
    
    // MARK: - 自定义方法
    /// 点击热门推荐和推荐景点使collectionview转到相对应的位置
    func hotContentAndSightButtonAction(sender: UIButton) {

        collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: sender.tag == 3 ? 0 : 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
    }
    
    /// 启动定时器，开始让图片转起来
    func updatePhotoAction() {
        headerImageView.swipeLeftAction()
    }
    
    /// 图片轮播调用右转还是左转
    func swipeAction(sender: UIButton) {
        sender.tag == 1 ? headerImageView.swipeLeftAction() : headerImageView.swipeRightActiona()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return isSlideMenu
    }
}