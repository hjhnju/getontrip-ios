//
//  MyDatumViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SettingDatumViewController: MenuViewController, UITableViewDataSource, UITableViewDelegate {

    static let name = "我的"
    
    lazy var tableView = UITableView()
    
    /// 退出登陆按钮
    lazy var exitLogin: UIButton = UIButton(title: "退出登录", fontSize: 16, radius: 0, titleColor: SceneColor.frontBlack)
    /// 请登陆按钮
    var pleaseLoginButton: PleaseLoginButton = PleaseLoginButton(image: "icon_app", title: "请登录", fontSize: 16, titleColor: .whiteColor(), fontName: Font.PingFangSCLight) // NSAttachmentAttributeName
    
    /// 登陆状态
    var isLoginStatus: Bool = false {
        didSet {
            setupIsLoginSetting()
        }
    }
    
    lazy var userIconImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initTableView()
    }
    
    ///  初始化属性
    private func initView() {
        
        navBar.titleLabel.text = SettingDatumViewController.name
        view.addSubview(tableView)
        view.backgroundColor = .whiteColor()
        
        isLoginStatus = globalUser != nil ? true : false
        pleaseLoginButton.addTarget(self, action: "pleaseLoginButtonAction", forControlEvents: .TouchUpInside)
        pleaseLoginButton.imageView?.layer.borderWidth = 1.0
        pleaseLoginButton.imageView?.layer.borderColor = UIColor.whiteColor().CGColor
        
        exitLogin.backgroundColor = .whiteColor()
        exitLogin.addTarget(self, action: "exitLoginAction", forControlEvents: .TouchUpInside)
        exitLogin.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, 50), offset: CGPointMake(0, 0))
    }
    
    private func initTableView() {
        tableView.bounces    = false
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = SceneColor.greyWhite
        tableView.registerClass(SettingDatumTableViewCell.self, forCellReuseIdentifier: "SettingDatumTableViewCell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.frame = CGRectMake(0, 44, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 44)
    }
    
    // MARK: - tableview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 2 : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 { return getMyIconTableViewCell(indexPath) }
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingDatumTableViewCell", forIndexPath: indexPath) as! SettingDatumTableViewCell
        cell.selectionStyle = .None
        switch indexPath.section {
        case 1:
            cell.currentRow = indexPath.row == 0 ? 0 : 1
            if indexPath.row == 1 { cell.getShadowWithView() }
        case 2:
            cell.currentRow = 2
            cell.getShadowWithView()
            return cell
        default:
            break
        }
        return cell
    }
    
    private func getMyIconTableViewCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.backgroundView = UIImageView(image: UIImage(named: "background_my")!)
        cell.addSubview(pleaseLoginButton)
        pleaseLoginButton.ff_AlignInner(.CenterCenter, referView: cell, size: nil, offset: CGPointMake(0, -15))
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    /// 每行的行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 { return 159 }
        return 54
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(color: UIColor.clearColor())
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            let vc = SettingViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = FavoriteViewController()
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    /// 选择照片方法
    var imagePicker: UIImagePickerController!
    private func switchPhotoAction(indexPath: NSIndexPath) {
        
//        let alerController = UIAlertController(title: "", message: "请选择图片来源", preferredStyle: .ActionSheet)
//        let actionCancle     = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
//        let phootPicture   = UIAlertAction(title: "拍照", style: .Default) { [weak self] (_) -> Void in
//            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
//                ProgressHUD.showErrorHUD(self?.view, text: "当前设备不支持拍照功能")
//                return
//            }
//            self?.imagePicker = UIImagePickerController()
//            self?.imagePicker.delegate = self
//            self?.imagePicker.sourceType = .Camera
//            self?.presentViewController(self?.imagePicker ?? UIImagePickerController(), animated: true, completion: nil)
//        }
//        let existingPicture = UIAlertAction(title: "从手机相册选择", style: .Default) { [weak self] (_) -> Void in
//            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
//                ProgressHUD.showErrorHUD(self?.view, text: "当前相册不可用")
//                return
//            }
//            self?.imagePicker = UIImagePickerController()
//            self?.imagePicker.delegate = self
//            self?.presentViewController(self?.imagePicker ?? UIImagePickerController(), animated: true, completion: nil)
//        }
//        alerController.addAction(actionCancle)
//        alerController.addAction(phootPicture)
//        alerController.addAction(existingPicture)
//        alerController.modalPresentationStyle = .Popover
//        alerController.popoverPresentationController?.sourceView = tableView.cellForRowAtIndexPath(indexPath)
//        alerController.popoverPresentationController?.sourceRect = tableView.cellForRowAtIndexPath(indexPath)?.frame ?? CGRectZero
//        presentViewController(alerController, animated: true, completion: nil)
    }
    
    func pleaseLoginButtonAction() {
        
        if globalUser != nil {
            
        } else {
            LoginView.sharedLoginView.doAfterLogin { [weak self] (result, error) -> () in
                if error == nil {
                    self?.isLoginStatus = result
                    return
                }
                self?.isLoginStatus = false
                ProgressHUD.showErrorHUD(self?.view, text: "登录失败")
            }
        }
    }
    
    ///  初始化是否登陆设置
    private func setupIsLoginSetting() {
        
        if isLoginStatus == true {
            userIconImageView.sd_setImageWithURL(NSURL(string: globalUser?.icon ?? ""), placeholderImage: UIImage(named: "icon_app"), completed: { [weak self] (image, error, _, _) -> Void in
                self?.pleaseLoginButton.setImage(image, forState: .Normal)
                self?.pleaseLoginButton.setImage(image, forState: .Highlighted)
            })
            pleaseLoginButton.setTitle(globalUser?.nickname, forState: UIControlState.Normal)
        } else {
            pleaseLoginButton.imageView?.image = UIImage(named: "icon_app")
            pleaseLoginButton.setImage(UIImage(named: "icon_app"), forState: .Normal)
            pleaseLoginButton.setTitle("请登陆", forState: .Normal)
        }
    }
}
