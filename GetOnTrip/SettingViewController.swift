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

class SettingViewController: MenuViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let name = "编辑个人资料"
    
    lazy var tableView = UITableView()
    
    /// 头像
    lazy var iconViewImageView  = UIImageView(image: UIImage(named: "icon_app"))
    
    /// 昵称
    lazy var nickNameLabel  = UILabel(color: SceneColor.frontBlack, title: "", fontSize: 16, mutiLines: true)
    
    /// 性别
    lazy var genderLabel: UILabel = UILabel(color: SceneColor.frontBlack, title: "男", fontSize: 16, mutiLines: false)
    
    /// 设置昵称控制器
    lazy var nicknameController: SettingNicknameController = SettingNicknameController()
    
    // MARK: - 初始化相关设置
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupAddProperty()
        setupBarButtonItem()
        setupIsLoginSetting()
    }
    
    ///  初始化属性
    private func setupAddProperty() {
        
        view.addSubview(tableView)
        view.backgroundColor = .whiteColor()
        navBar.titleLabel.text = SettingViewController.name
        addChildViewController(nicknameController)
        
        tableView.bounces    = false
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = SceneColor.greyWhite
        tableView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64)
    }
    
    ///  初始化是否登陆设置
    private func setupIsLoginSetting() {
        
        switch globalUser?.gender.hashValue ?? 3 {
        case 0:
            genderLabel.text = "男"
        case 1:
            genderLabel.text = "女"
        default:
            genderLabel.text = "未知"
            break
        }
        nickNameLabel.text = globalUser?.nickname
        if (globalUser?.icon ?? "") == "" { return }
        iconViewImageView.sd_setImageWithURL(NSURL(string: globalUser?.icon ?? ""))
    }
    
    ///  初始化导航
    private func setupBarButtonItem() {
        navBar.rightButton.selected = false
        navBar.setTitle(SettingViewController.name)
    }
    
    // MARK: - tableview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = SettingTableViewCell()
            switch indexPath.row {
            case SettingCell.iconCell:
                cell.left.text = "头像"
                cell.contentView.addSubview(iconViewImageView)
                iconViewImageView.layer.cornerRadius = 66 * 0.5
                iconViewImageView.layer.masksToBounds = true
                iconViewImageView.ff_AlignInner(.CenterRight, referView: cell.contentView, size: CGSizeMake(66, 66), offset: CGPointMake(-9, 0))
            case SettingCell.nickCell:
                cell.left.text = "昵称"
                cell.contentView.addSubview(nickNameLabel)
                nickNameLabel.ff_AlignInner(.CenterRight, referView: cell.contentView, size: nil, offset: CGPointMake(-9, 0))
            case SettingCell.sexCell:
                cell.left.text = "性别"
                cell.contentView.addSubview(genderLabel)
                genderLabel.ff_AlignInner(.CenterRight, referView: cell.contentView, size: nil, offset: CGPointMake(-9, 0))
                cell.getShadowWithView()
                cell.baseline.removeFromSuperview()
            default:
                break
            }
        return cell
    }
    
    /// 预估组高
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }

    /// 组高
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    /// 预估cell高度
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? 104 : 51
    }
    
    /// cell高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? 104 : 51
    }
    
    /// 组view
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(color: UIColor.clearColor())
    }
    
    var switchPhoto: Bool = false
    lazy var photoVC: PhotographViewController = PhotographViewController()
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case SettingCell.iconCell: // 选择照片
                photoVC.switchPhotoAction(self, sourceview: tableView.cellForRowAtIndexPath(indexPath) ?? UIView(), setPhoto: iconViewImageView)
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
        }
    }
}

