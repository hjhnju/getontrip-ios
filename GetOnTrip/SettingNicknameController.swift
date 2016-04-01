//
//  SettingNicknameController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/21.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SettingNicknameController: MenuViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var tableView = UITableView()
    
    lazy var userNameTextField = UITextField(alignment: .Left, sizeFout: 16, color: UIColor.blackColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initTextField()
        setupBarButtonItem()
        navBar.setTitle("昵称")
    }
    
    private func initView() {
        view.addSubview(tableView)
        view.backgroundColor = UIColor(hex: 0xF7F5F3, alpha: 1.0)
        
        tableView.bounces    = false
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.ff_AlignInner(.TopLeft, referView: view, size: UIScreen.mainScreen().bounds.size, offset: CGPointMake(0, 79))
    }
    
    private func initTextField() {
        userNameTextField.backgroundColor     = .whiteColor()
        userNameTextField.borderStyle         = .None
        userNameTextField.autocorrectionType  = .Default
        userNameTextField.autocapitalizationType = .None
        userNameTextField.returnKeyType       = .Done
        userNameTextField.clearButtonMode     = .Always
        userNameTextField.addTarget(self, action: #selector(SettingNicknameController.nickNameTextFieldTextDidChangeNotification(_:)), forControlEvents: .EditingChanged)
    }
    
    ///  初始化导航
    private func setupBarButtonItem() {
        
        navBar.setRightBarButton(nil, title: "保存", target: self, action: #selector(SettingNicknameController.saveUserName(_:)))
        navBar.rightButton.selected = false
        navBar.rightButton.setTitleColor(SceneColor.thinGray, forState: .Normal)
        navBar.rightButton.setTitleColor(UIColor.yellowColor(), forState: .Selected)
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: #selector(SettingNicknameController.popViewAction(_:)))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        userNameTextField.becomeFirstResponder()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.addSubview(userNameTextField)
        userNameTextField.ff_AlignInner(.CenterCenter, referView: cell, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 52))
        cell.getShadowWithView()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
    }
    
    ///  昵称的文本改变时调用的通知
    ///
    ///  - parameter notification: 通知
    func nickNameTextFieldTextDidChangeNotification(textField: UITextField) {
        
        if globalUser?.nickname != textField.text && textField.text != "" {
            navBar.rightButton.selected = true
        } else {
            navBar.rightButton.selected = false
        }
    }
    
    /// 保存用户名
    func saveUserName(btn: UIButton) {
        
        if btn.selected == false { return }
        ProgressHUD.sharedProgressHUD.showOperationPrompt(nil, text: "正在保存中", style: nil) { (handler) -> Void in
            
            UserLogin.sharedInstance.uploadUserInfo(nil, sex: nil, nick_name: self.userNameTextField.text) { (result, status) -> Void in
                handler()
                if status == RetCode.SUCCESS {
                    UserLogin.sharedInstance.loadAccount({ (result, status) -> Void in
                        if status == RetCode.SUCCESS {
                            ProgressHUD.showSuccessHUD(nil, text: "保存成功")
                            self.navBar.rightButton.selected = false
                            self.navigationController?.popViewControllerAnimated(true)
                            return
                        }
                        ProgressHUD.showErrorHUD(nil, text: "保存失败")
                    })
                } else {
                    ProgressHUD.showErrorHUD(nil, text: RetCode.getShowUNE(status ?? 0))
                }
            }
        }
    }
}
