//
//  SettingSexViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/27.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SettingSexViewController: MenuViewController, UITableViewDelegate, UITableViewDataSource {

    lazy var tableView = UITableView()
    
    lazy var manSwitch = UISwitch()
    
    lazy var womanSwitch = UISwitch()
    
    var sex: Int = 3 {
        didSet {
            switch sex {
            case 0:
                manSwitch.setOn(true, animated: true)
                womanSwitch.setOn(false, animated: true)
            case 1:
                manSwitch.setOn(false, animated: true)
                womanSwitch.setOn(true, animated: true)
            default:
                break
            }
        }
    }
    
    var tempSex: Int = 2 {
        didSet {
            navBar.rightButton.selected = globalUser?.gender != tempSex ? true : false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        setupBarButtonItem()
    }
    
    private func initView() {
        view.backgroundColor = .whiteColor()
        manSwitch.addTarget(self, action: "sexSwitchAction:", forControlEvents: .ValueChanged)
        womanSwitch.addTarget(self, action: "sexSwitchAction:", forControlEvents: .ValueChanged)
        view.addSubview(tableView)
        view.backgroundColor      = UIColor(hex: 0xF0F0F0, alpha: 1.0)
        tableView.delegate        = self
        tableView.dataSource      = self
        tableView.bounces         = false
        tableView.separatorStyle  = .None
        tableView.backgroundColor = UIColor(hex: 0xF0F0F0, alpha: 1.0)
        tableView.registerClass(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        tableView.ff_AlignInner(.TopLeft, referView: view, size: UIScreen.mainScreen().bounds.size, offset: CGPointMake(0, 79))
    }
    
    ///  初始化导航
    private func setupBarButtonItem() {
        navBar.setTitle("性别")
        navBar.rightButton.removeTarget(self, action: "searchAction:", forControlEvents: .TouchUpInside)
        navBar.setRightBarButton(nil, title: "保存", target: self, action: "saveUserSexAction:")
        navBar.rightButton.selected = false
        navBar.rightButton.setTitleColor(SceneColor.thinGray, forState: .Normal)
        navBar.rightButton.setTitleColor(.yellowColor(), forState: .Selected)
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")
    }

    
    // MARK: - tableView delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingTableViewCell", forIndexPath: indexPath) as! SettingTableViewCell
        cell.left.text = indexPath.row == 0 ? "男" : "女"
        
        if indexPath.row == 0 {
            cell.addSubview(manSwitch)
            manSwitch.ff_AlignInner(.CenterRight, referView: cell, size: nil, offset: CGPointMake(-9, 0))
        } else {
            cell.addSubview(womanSwitch)
            womanSwitch.ff_AlignInner(.CenterRight, referView: cell, size: nil, offset: CGPointMake(-9, 0))
        }
        
        return cell
    }
    
    // 行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
    }
    
    // 预估行高 可减少行高的大量调用
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
    }

    // MARK: - 自定义方法
    func sexSwitchAction(sexSwitch: UISwitch) {
        
        if manSwitch == sexSwitch {
            womanSwitch.setOn(!sexSwitch.on, animated: true)
        } else {
            manSwitch.setOn(!sexSwitch.on, animated: true)
        }
        
        tempSex = manSwitch.on ? 0 : 1
    }
    
    /// 保存用户信息
    func saveUserSexAction(btn: UIButton) {
        if btn.selected == false { return }
        
        ProgressHUD.sharedProgressHUD.showOperationPrompt(nil, text: "正在保存中", style: nil) { (handler) -> Void in
            
            UserLogin.sharedInstance.uploadUserInfo(nil, sex: self.tempSex, nick_name: nil) { (result, status) -> Void in
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
                    self.sex = globalUser?.gender ?? 2
                }
            }
        }
    }
}
