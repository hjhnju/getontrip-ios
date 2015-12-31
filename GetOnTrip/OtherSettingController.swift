//
//  OtherSettingController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import SDWebImage

class OtherSettingController: MenuViewController, UITableViewDelegate, UITableViewDataSource {

    lazy var tableView = UITableView()
    
    /// 清除缓存Label
    lazy var removeCacheLabel: UILabel = UILabel(color: SceneColor.frontBlack, title: "0.0M", fontSize: 16, mutiLines: true)
    /// 省流量模式
    lazy var trafficSwitch = UISwitch()
    /// 夜间模式
    lazy var switchNightsSwitch = UISwitch()
    /// 退出登录按钮
    lazy var exitLogin: UIButton = UIButton(title: "退出登录", fontSize: 16, radius: 0, titleColor: SceneColor.frontBlack)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initTableView()
        initExitLogin()
    }
    
    private func initView() {
        navBar.titleLabel.text = "设置"
        view.backgroundColor = .whiteColor()
        removeCacheLabel.text = getUsedCache()
        automaticallyAdjustsScrollViewInsets = false
        trafficSwitch.addTarget(self, action: "trafficSwitchAction:", forControlEvents: .ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshLoginStatus()
    }
    
    private func initExitLogin() {
        view.addSubview(exitLogin)
        exitLogin.backgroundColor = .whiteColor()
        exitLogin.addTarget(self, action: "exitLoginAction", forControlEvents: .TouchUpInside)
        exitLogin.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, 50), offset: CGPointMake(0, 0))
    }
    
    private func initTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = SceneColor.greyWhite
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.registerClass(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        tableView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64)
    }

    // MARK: - tableview delegate and datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(color: .clearColor())
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && indexPath.row == 0 { return trafficModeCell(indexPath) }
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingTableViewCell", forIndexPath: indexPath) as! SettingTableViewCell
        cell.baseline.hidden = true
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.left.text = "清除缓存"
            cell.contentView.addSubview(removeCacheLabel)
            removeCacheLabel.ff_AlignInner(.CenterRight, referView: cell.contentView, size: nil, offset: CGPointMake(-9, 0))
        } else if indexPath.section == 2 && indexPath.row == 0 {
            cell.left.text = "给我们评分"
        } else if indexPath.section == 3 && indexPath.row == 0 {
            cell.left.text = "关于我们"
        }
        cell.baseline.hidden = false
        cell.getShadowWithView()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            clearCacheSetting(indexPath)
        }
        
        if indexPath.section == 2{
            UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/app/id1059746773")!)
        } else if indexPath.section == 3 && indexPath.row == 0 {
            let vc = GuideViewController()
            vc.numberPage = 3
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
    }
    
    // MARK: - 自定义方法
    private func trafficModeCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingTableViewCell", forIndexPath: indexPath) as! SettingTableViewCell
        cell.baseline.hidden = true
        cell.left.hidden = true
        cell.selectionStyle = .None
        let titleLabel = UILabel(color: SceneColor.frontBlack, title: "开启省流量模式", fontSize: 16, mutiLines: true, fontName: Font.PingFangSCLight)
        let subtitle = UILabel(color: SceneColor.frontBlackFour, title: "非WIFI模式下不显示图片", fontSize: 9, mutiLines: true, fontName: Font.PingFangSCLight)
        cell.addSubview(titleLabel)
        cell.addSubview(subtitle)
        cell.addSubview(trafficSwitch)
        trafficSwitch.on = UserProfiler.instance.savingTrafficMode
        titleLabel.ff_AlignInner(.CenterLeft, referView: cell, size: nil, offset: CGPointMake(9, -5))
        subtitle.ff_AlignVertical(.BottomLeft, referView: titleLabel, size: nil, offset: CGPointMake(0, 0))
        trafficSwitch.ff_AlignInner(.CenterRight, referView: cell, size: nil, offset: CGPointMake(-9, 0))
        cell.getShadowWithView()
        return cell
    }
    
    /// 清除缓存设置
    private func clearCacheSetting(indexPath: NSIndexPath) {
        let alertController = UIAlertController(title: "", message: "会清除所有缓存、离线的内容及图片", preferredStyle: .ActionSheet)
        let actionTrue      = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let actionCanale    = UIAlertAction(title: "确定", style: .Default) { [weak self] (_) -> Void in self?.clearCacheAction()}
        alertController.addAction(actionCanale)
        alertController.addAction(actionTrue)
        alertController.modalPresentationStyle = UIModalPresentationStyle.Popover
        alertController.popoverPresentationController?.sourceView = tableView.cellForRowAtIndexPath(indexPath)
        alertController.popoverPresentationController?.sourceRect = tableView.cellForRowAtIndexPath(indexPath)?.frame ?? CGRectZero
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /// 获取缓存大小
    func getUsedCache() -> String {
        let size: CGFloat = CGFloat(SDImageCache.sharedImageCache().getSize()) / 1024.0 / 1024.0
        return String(format: "%.1f M", size)
    }
    
    /// 清除缓存
    func clearCacheAction() {
        ProgressHUD.sharedProgressHUD.showOperationPrompt(nil, text: "正在清理缓存中", style: nil) { [weak self] (handler) -> Void in
            Cache.shareInstance.clear { () -> Void in }
            SDImageCache.sharedImageCache().clearMemory()
            SDImageCache.sharedImageCache().clearDiskOnCompletion { [weak self]() -> Void in
                handler()
                
                //更新显示缓存
                let size = self?.getUsedCache()
                print("CachSize2=\(size)")
                self?.removeCacheLabel.text = size
                ProgressHUD.showSuccessHUD(nil, text: "清理完毕")
            }
        }
    }
    
    /// 切换省流量模式
    func trafficSwitchAction(traffic: UISwitch) {
        UserProfiler.instance.savingTrafficMode = traffic.on
    }
    
    
    ///  退出登录
    func exitLoginAction() {
        
        let alertController = UIAlertController(title: "", message: "确认退出登录", preferredStyle: .ActionSheet)
        let actionTrue      = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let actionCanale    = UIAlertAction(title: "确定", style: .Default, handler: { [weak self] (alter) -> Void in
            UserLogin.sharedInstance.exit()
            // 将页面返回到首页
            if let vc = self?.parentViewController?.parentViewController as? SlideMenuViewController {
                vc.curVCType = RecommendViewController.self
            }
            })
        alertController.addAction(actionCanale)
        alertController.addAction(actionTrue)
        alertController.modalPresentationStyle = .Popover
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = CGRectMake(0, view.bounds.height - 180, view.bounds.width, 180)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /// 刷新登陆状态
    func refreshLoginStatus() {
        exitLogin.hidden = globalUser != nil ? false : true
    }
}
