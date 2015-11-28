//
//  SettingViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/2.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SDWebImage
import Alamofire
import CoreData

/// 定义选中的是第几行
struct SettingCell {
    /// 0
    static let iconCell = 0
    /// 1
    static let nickCell = 1
    /// 2
    static let sexCell  = 2
}

class SettingViewController: MenuViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    static let name = "设置"
    
    lazy var tableView = UITableView()
    
    /// 头像
    lazy var iconView  = UIImageView(image: UIImage(named: "icon_app"))
    
    /// 昵称
    lazy var nickName  = UILabel(color: UIColor.blackColor(), title: "", fontSize: 16, mutiLines: true)
    
    /// 性别
    lazy var gender: UILabel = UILabel(color: UIColor.blackColor(), title: "男", fontSize: 16, mutiLines: false)
    
    /// 退出登陆按钮
    lazy var exitLogin: UIButton = UIButton(title: "退出登录", fontSize: 14, radius: 0, titleColor: UIColor.blackColor())
    
    /// 清除缓存Label
    var removeCacheLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "0.0M", fontSize: 16, mutiLines: true)
    
    /// 请登陆按钮
    var pleaseLoginButton: PleaseLoginButton = PleaseLoginButton(image: "icon_app", title: "请登陆", fontSize: 16, titleColor: SceneColor.frontBlack)
    
    /// 设置昵称控制器
    lazy var nicknameController: SettingNicknameController = SettingNicknameController()
    
    /// 未登陆第一组显示几条
    var notLoginCount = 1
    
    /// 登陆状态
    var isLoginStatus: Bool = false {
        didSet {
            setupIsLoginSetting()
            tableView.reloadData()
        }
    }
    
    var saveButton: Bool = false {
        didSet {
            navBar.rightButton.selected = saveButton
        }
    }
    
    /// 切换照片控制器
    var switchPhotoVC: SwitchPhotoViewController = SwitchPhotoViewController()

    // MARK: - 初始化相关设置
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupAddProperty()
        setupBarButtonItem()
        setupIsLoginSetting()
    }
    
    ///  初始化属性
    private func setupAddProperty() {
        
        title = SettingViewController.name
        view.addSubview(tableView)
        view.addSubview(exitLogin)
        pleaseLoginButton.adjustsImageWhenHighlighted = false
        pleaseLoginButton.addTarget(self, action: "pleaseLoginButtonAction", forControlEvents: .TouchUpInside)
        
        addChildViewController(switchPhotoVC)
        addChildViewController(nicknameController)
        
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor(hex: 0xF0F0F0, alpha: 1.0)
        tableView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - 44), offset: CGPointMake(0, 44))
        
        saveButton = false
        exitLogin.backgroundColor = .whiteColor()
        exitLogin.addTarget(self, action: "exitLoginAction", forControlEvents: .TouchUpInside)
        exitLogin.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, 50), offset: CGPointMake(0, 0))
        
        isLoginStatus = globalUser == nil ? false : true
    }
    
    ///  初始化是否登陆设置
    private func setupIsLoginSetting() {
        
        if isLoginStatus == true {
            notLoginCount = 3
        } else {
            notLoginCount = 1
            
            switch globalUser?.gender.hashValue ?? 3 {
            case 0:
                gender.text = "男"
            case 1:
                gender.text = "女"
            default:
                gender.text = "未知"
                break
            }
            nickName.text = globalUser?.nickname
            if (globalUser?.icon ?? "") == "" { return }
            iconView.sd_setImageWithURL(NSURL(string: globalUser?.icon ?? ""))
        }
    }
    
    ///  初始化导航
    private func setupBarButtonItem() {
        
        navBar.rightButton.selected = false
        navBar.setTitle(SettingViewController.name)
        navBar.rightButton.removeTarget(self, action: "searchAction:", forControlEvents: .TouchUpInside)
        navBar.setRightBarButton(nil, title: "保存", target: self, action: "saveUserInfo:")
        navBar.rightButton.setTitleColor(SceneColor.thinGray, forState: .Normal)
        navBar.rightButton.setTitleColor(UIColor.yellowColor(), forState: .Selected)
    }
    
    // MARK: - tableview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? notLoginCount : 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = SettingTableViewCell()
        
        if indexPath.section == 0 {
            if isLoginStatus == false {
                let cel = UITableViewCell()
                cel.addSubview(pleaseLoginButton)
                pleaseLoginButton.ff_AlignInner(.CenterCenter, referView: cel, size: nil, offset: CGPointMake(0, -15))
                return cel
            }
            switch indexPath.row {
            case SettingCell.iconCell:
                cell.left.text = "头像"
                cell.addSubview(iconView)
                iconView.layer.cornerRadius = 66 * 0.5
                iconView.layer.masksToBounds = true
                iconView.ff_AlignInner(.CenterRight, referView: cell, size: CGSizeMake(66, 66), offset: CGPointMake(-10, 0))
            case SettingCell.nickCell:
                cell.left.text = "昵称"
                cell.addSubview(nickName)
                nickName.ff_AlignInner(.CenterRight, referView: cell, size: nil, offset: CGPointMake(-10, 0))
            case SettingCell.sexCell:
                cell.left.text = "性别"
                cell.addSubview(gender)
                gender.ff_AlignInner(.CenterRight, referView: cell, size: nil, offset: CGPointMake(-9, 0))
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                cell.left.text = "清除缓存"
                cell.addSubview(removeCacheLabel)
                removeCacheLabel.text = getUsedCache()
                removeCacheLabel.ff_AlignInner(.CenterRight, referView: cell, size: nil, offset: CGPointMake(-9, 0))
                cell.baseline.removeFromSuperview()
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }

    /// 每行的行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return isLoginStatus == true ? 102 : 159
        }
        return 51
    }
    
    var switchPhoto: Bool = false
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            if isLoginStatus == false { return }
            switch indexPath.row {
            case SettingCell.iconCell: // 选择照片
                if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) { return }
                let picker = UIImagePickerController()
                picker.delegate = self
                presentViewController(picker, animated: true, completion: nil)
            case SettingCell.nickCell: // 选择昵称
                let nvc = SettingNicknameController()
                nvc.userNameTextField.text = globalUser?.nickname
                navigationController?.pushViewController(nvc, animated: true)
            case SettingCell.sexCell:  // 选择性别
                let vc = SettingSexViewController()
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 1: // 清除缓存
                clearCacheSetting(indexPath)
            default:
                break
            }
        }
    }
    
    /// 清除缓存设置
    private func clearCacheSetting(indexPath: NSIndexPath) {
        let alertController = UIAlertController(title: "", message: "会清除所有缓存、离线的内容及图片", preferredStyle: .ActionSheet)
        let actionTrue      = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let actionCanale    = UIAlertAction(title: "确定", style: .Default) { (_) -> Void in self.clearCacheAction()}
        alertController.addAction(actionCanale)
        alertController.addAction(actionTrue)
        alertController.modalPresentationStyle = UIModalPresentationStyle.Popover
        alertController.popoverPresentationController?.sourceView = tableView.cellForRowAtIndexPath(indexPath)
        alertController.popoverPresentationController?.sourceRect = tableView.cellForRowAtIndexPath(indexPath)?.frame ?? CGRectZero
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /// 头像图片
    var iconPhoto: UIImage? {
        didSet{
            iconView.image = iconPhoto?.scaleImage(200)
            if !(iconView.image!.isEqual(iconPhoto)) {
                saveButton = true
            } else {
                saveButton = false
            }
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        

        navigationController?.pushViewController(switchPhotoVC, animated: true)
        switchPhotoVC.photoView.img = image
        self.dismissViewControllerAnimated(true, completion: nil)
        saveButton = true
        // 重新设回导航栏样式
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    // MARK: 自定义方法
    // 让用户登陆的方法，弹出登陆浮尘
    func pleaseLoginButtonAction() {
        
        
    }
    
    /// 保存用户信息
    func saveUserInfo(btn: UIButton) {
        if btn.selected == false { return }
        
        iconView.image?.scaleImage(200)
        let imageData = UIImagePNGRepresentation(iconView.image!) ?? NSData()
        
        UserLogin.sharedInstance.uploadUserInfo(imageData, sex: nil, nick_name: nil) { (result, error) -> Void in
            
            if error == nil {
                print(result)
                ProgressHUD.showSuccessHUD(self.view, text: "保存成功")
                UserLogin.sharedInstance.loadAccount()
                self.saveButton = false
            } else {
                ProgressHUD.showErrorHUD(self.view, text: "保存失败")
            }
        }
        self.tableView.reloadData()
    }
    
    /// 获取缓存大小
    func getUsedCache() -> String {
        let size: CGFloat = CGFloat(SDImageCache.sharedImageCache().getSize()) / 1024.0 / 1024.0
        return String(format: "%.1f M", size)
    }
    
    /// 清除缓存
    func clearCacheAction() {
        Cache.shareInstance.clear { () -> Void in }
        SDImageCache.sharedImageCache().clearDiskOnCompletion { [weak self]() -> Void in
            //更新显示缓存
            let size = self?.getUsedCache()
            print("CachSize2=\(size)")
            self!.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .None)
        }
    }
    
    ///  退出登陆
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
        alertController.popoverPresentationController?.sourceView = exitLogin
        alertController.popoverPresentationController?.sourceRect = exitLogin.frame
        presentViewController(alertController, animated: true, completion: nil)
    }
}

