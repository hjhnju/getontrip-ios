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
        tableView.delegate        = self
        tableView.dataSource      = self
        tableView.bounces         = false
        tableView.separatorStyle  = .None
        tableView.backgroundColor = UIColor(hex: 0xF0F0F0, alpha: 1.0)
        tableView.registerClass(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        tableView.ff_AlignInner(.TopLeft, referView: view, size: UIScreen.mainScreen().bounds.size, offset: CGPointMake(0, 64))
    }
    
    ///  初始化导航
    private func setupBarButtonItem() {
        navBar.setTitle("性别")
        navBar.rightButton.removeTarget(self, action: "searchAction:", forControlEvents: .TouchUpInside)
        navBar.setRightBarButton(nil, title: "保存", target: self, action: "saveUserName")
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
    }
    
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
    }
    
}
