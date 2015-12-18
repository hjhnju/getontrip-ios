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
    lazy var nickName  = UILabel(color: SceneColor.frontBlack, title: "", fontSize: 16, mutiLines: true)
    
    /// 性别
    lazy var gender: UILabel = UILabel(color: SceneColor.frontBlack, title: "男", fontSize: 16, mutiLines: false)
    
    /// 退出登陆按钮
    lazy var exitLogin: UIButton = UIButton(title: "退出登录", fontSize: 16, radius: 0, titleColor: SceneColor.frontBlack)
    
    /// 清除缓存Label
    var removeCacheLabel: UILabel = UILabel(color: SceneColor.frontBlack, title: "0.0M", fontSize: 16, mutiLines: true)
    
    /// 请登陆按钮
    var pleaseLoginButton: PleaseLoginButton = PleaseLoginButton(image: "icon_app", title: "请登录", fontSize: 16, titleColor: SceneColor.frontBlack)
    
    /// 设置昵称控制器
    lazy var nicknameController: SettingNicknameController = SettingNicknameController()
    
    /// 未登陆第一组显示几条
    var notLoginCount = 1
    
    /// 夜间模式
    lazy var nightsSwitch = UISwitch()
    
    /// 是否是夜间模式
    var isNightsModel: Bool = false
    
    /// 登陆状态
    var isLoginStatus: Bool = false {
        didSet {
            setupIsLoginSetting()
            tableView.reloadData()
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
        nightsSwitch.addTarget(self, action: "nightsSwitchAction:", forControlEvents: .ValueChanged)
        if let userDefault = NSUserDefaults.standardUserDefaults().valueForKey("isNights") as? Bool {
            isNightsModel = userDefault
        }
        
        view.backgroundColor = UIColor(hex: 0xF7F5F3, alpha: 1.0)
        addChildViewController(switchPhotoVC)
        addChildViewController(nicknameController)
        
        tableView.bounces    = false
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = .clearColor()
        tableView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - 44), offset: CGPointMake(0, 44))
        
        exitLogin.backgroundColor = .whiteColor()
        exitLogin.addTarget(self, action: "exitLoginAction", forControlEvents: .TouchUpInside)
        exitLogin.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, 50), offset: CGPointMake(0, 0))
    }
    
    ///  初始化是否登陆设置
    private func setupIsLoginSetting() {
        
        if isLoginStatus == false {
            notLoginCount = 1
            exitLogin.hidden = true
        } else {
            notLoginCount = 3
            exitLogin.hidden = false
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        isLoginStatus = globalUser == nil ? false : true
    }
    
    // MARK: - tableview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? notLoginCount : 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = SettingTableViewCell()
        
        if indexPath.section == 0 {
            if isLoginStatus == false {
                let cel = SettingTableViewCell()
                cel.baseline.removeFromSuperview()
                cel.left.removeFromSuperview()
                cel.addSubview(pleaseLoginButton)
                pleaseLoginButton.ff_AlignInner(.CenterCenter, referView: cel, size: nil, offset: CGPointMake(0, -15))
                cel.getShadowWithView()
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
                cell.getShadowWithView()
                cell.baseline.removeFromSuperview()
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
                cell.getShadowWithView()
                cell.baseline.removeFromSuperview()
            case 1:
                cell.left.text = "夜间模式"
                cell.addSubview(nightsSwitch)
                nightsSwitch.on = isNightsModel
                nightsSwitch.ff_AlignInner(.CenterRight, referView: cell, size: nil, offset: CGPointMake(-9, 0))
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(color: UIColor.clearColor())
    }
    
    var switchPhoto: Bool = false
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            if isLoginStatus == false { return }
            switch indexPath.row {
            case SettingCell.iconCell: // 选择照片
                switchPhotoAction(indexPath)
            case SettingCell.nickCell: // 选择昵称
                let nvc = SettingNicknameController()
                nvc.userNameTextField.text = globalUser?.nickname
                navigationController?.pushViewController(nvc, animated: true)
            case SettingCell.sexCell:  // 选择性别
                let vc = SettingSexViewController()
                vc.sex = globalUser?.gender.hashValue ?? 3
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0: // 清除缓存
                clearCacheSetting(indexPath)
            default:
                break
            }
        }
    }
    
    /// 选择照片方法
    var imagePicker: UIImagePickerController!
    private func switchPhotoAction(indexPath: NSIndexPath) {
        
        let alerController = UIAlertController(title: "", message: "请选择图片来源", preferredStyle: .ActionSheet)
        let actionCancle     = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let phootPicture   = UIAlertAction(title: "拍照", style: .Default) { [weak self] (_) -> Void in
            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                ProgressHUD.showErrorHUD(self?.view, text: "当前设备不支持拍照功能")
                return
            }
            self?.imagePicker = UIImagePickerController()
            self?.imagePicker.delegate = self
            self?.imagePicker.sourceType = .Camera
            self?.presentViewController(self?.imagePicker ?? UIImagePickerController(), animated: true, completion: nil)
        }
        let existingPicture = UIAlertAction(title: "从手机相册选择", style: .Default) { [weak self] (_) -> Void in
            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                ProgressHUD.showErrorHUD(self?.view, text: "当前相册不可用")
                return
            }
            self?.imagePicker = UIImagePickerController()
            self?.imagePicker.delegate = self
            self?.presentViewController(self?.imagePicker ?? UIImagePickerController(), animated: true, completion: nil)
        }
        alerController.addAction(actionCancle)
        alerController.addAction(phootPicture)
        alerController.addAction(existingPicture)
        alerController.modalPresentationStyle = .Popover
        alerController.popoverPresentationController?.sourceView = tableView.cellForRowAtIndexPath(indexPath)
        alerController.popoverPresentationController?.sourceRect = tableView.cellForRowAtIndexPath(indexPath)?.frame ?? CGRectZero
        presentViewController(alerController, animated: true, completion: nil)
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {

        navigationController?.pushViewController(switchPhotoVC, animated: true)
        switchPhotoVC.photoView.img = image
        dismissViewControllerAnimated(true) { [weak self] () -> Void in
            self?.imagePicker = nil
        }
        // 重新设回导航栏样式
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    // MARK: 自定义方法
    // 让用户登陆的方法，弹出登陆浮尘
    func pleaseLoginButtonAction() {
        
        LoginView.sharedLoginView.doAfterLogin { [weak self] (result, error) -> () in
            if error == nil {
                if result == true {
                    self?.isLoginStatus = true
                } else {
                    self?.isLoginStatus = false
                }
                return
            }
            self?.isLoginStatus = false
            ProgressHUD.showErrorHUD(self?.view, text: "登录失败")
        }
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
            SDImageCache.sharedImageCache().clearDiskOnCompletion { [weak self]() -> Void in
                handler()
                //更新显示缓存
                let size = self?.getUsedCache()
                print("CachSize2=\(size)")
                self!.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .None)
                ProgressHUD.showSuccessHUD(nil, text: "清理完毕")
            }
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
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = CGRectMake(0, view.bounds.height - 180, view.bounds.width, 180)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /// 切换夜间模式
    func nightsSwitchAction(nights: UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool(nights.on, forKey: "isNights")
    }
}

