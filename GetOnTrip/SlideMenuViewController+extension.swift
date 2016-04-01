//
//  SlideMenuViewController+extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/2.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

extension SlideMenuViewController {
    
    //左右滑动效果
    func panGestureHandler(sender: UIPanGestureRecognizer) {
        //用户对视图操控的状态。
        let state    = sender.state;
        let location = sender.locationInView(mainNavViewController.view)
        var frame    = mainNavViewController.view.frame
        
        var startX:CGFloat = 0.0
        switch (state) {
        case UIGestureRecognizerState.Began:
            //记录用户开始点击的位置
            panGestureStartLocation = location;
            startX = frame.origin.x
            break;
        case UIGestureRecognizerState.Changed:
            //相比起点Began的x轴距离(每次.Changed调用是累计的
            let xOffSet = sender.translationInView(view).x
            //右滑动
            if (xOffSet > 0 && xOffSet < SlideMenuOptions.DrawerWidth){
                if (slideMenuState == SlideMenuState.Closing){
                    frame.origin.x = xOffSet + startX
                }
                //左滑动
            }else if (xOffSet < 0 && xOffSet > -SlideMenuOptions.DrawerWidth){
                if (slideMenuState == SlideMenuState.Opening){
                    frame.origin.x = xOffSet + SlideMenuOptions.DrawerWidth
                }
            }
            mainNavViewController.view.frame = frame;
            //alpha=[0.5 ~ 1.0]
            menuAlpha = min(0.5 + frame.origin.x / SlideMenuOptions.DrawerWidth, 1.0)
            break;
        case UIGestureRecognizerState.Ended:
            let xOffSet = sender.translationInView(view).x
            //超过阀值需要自动
            if abs(xOffSet) > SlideMenuOptions.AutoSlideXOffSet {
                if xOffSet < 0 && slideMenuState == SlideMenuState.Opening {
                    didClose()
                }else if xOffSet > 0 && slideMenuState == SlideMenuState.Closing {
                    didOpen()
                }
            } else {
                reset()
            }
            break;
        default:
            break;
        }
    }
    
    //打开侧边栏
    func didOpen(){
        //设置主窗体的结束位置
        var mainSize = mainNavViewController.view.frame
        mainSize.origin.x = SlideMenuOptions.DrawerWidth
        menuAlpha = max(0.5, menuAlpha)
        //动效
        UIView.animateWithDuration(0.7,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations:{ [weak self] in
                self?.mainNavViewController.view.frame = mainSize;
                self?.menuAlpha = 1.0 },
            completion: { [weak self] (finished: Bool) -> Void in
                self?.menuAlpha = 1.0
            }
        )
        
        //将侧边栏的装填标记为打开状态
        slideMenuState = SlideMenuState.Opening
        Statistics.shareStatistics.event(Event.home_show_menuViewController_eid)
        refreshMask()
    }
    
    //关闭侧边栏
    func didClose(){
        //点击关闭时要将当前状态标记为关闭
        if slideMenuState == SlideMenuState.Opening {
            slideMenuState = SlideMenuState.Closing
        }
        //将主窗体的起始位置恢复到原始状态
        var mainSize = mainNavViewController.view.frame
        mainSize.origin.x = 0
        menuAlpha = min(1.0, menuAlpha)
        UIView.animateWithDuration(0.7,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: { [weak self] in
                self?.mainNavViewController.view.frame = mainSize;
                self?.menuAlpha = 0.5 },
            completion: { (finished: Bool) -> Void in
                //偶尔右滑到底时被执行！why
                //self.menuAlpha = 0.0
            }
        )
        
        refreshMask()
    }
    
    // MARK: SlideMenuViewControllerDelegate
    
    func toggle() {
        if slideMenuState == SlideMenuState.Opening {
            didClose()
        } else {
            didOpen()
        }
    }
    
    func reset(){
        if slideMenuState == SlideMenuState.Opening {
            didOpen()
        } else {
            didClose()
        }
    }
    
    // MARK: tableView数据源方法
    ///
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SlideMenuOptions.MenuTableViewCellID, forIndexPath: indexPath) as! MenuSettingTableViewCell
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.titleLabel.text = tableViewDataSource[indexPath.row]
        
        return cell
    }
    
    //跳转控制器
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        curVCType = usingVCTypes[indexPath.row]
    }

}