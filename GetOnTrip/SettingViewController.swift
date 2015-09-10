//
//  SettingViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/2.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

/// 定义选中的是第几行
struct SettingCell {
    static let iconCell = 1
    static let nickCell = 2
    static let sexCell  = 3
    static let cityCell = 4
}

class SettingViewController: UITableViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    
    // 昵称
    @IBOutlet weak var nickName: UITextField!
    
    /// 通知
    @IBOutlet weak var informSwitch: UISwitch!
    /// 通知行的cell
    @IBOutlet weak var informCell: settingTableViewCell!
    
    /// 省市联动
    var provinces: NSArray?
    
    /// 当前省的索引
    var provinceIndex: Int = 0
    
    /// pick切换数据源方法 如果是true则是姓别，false是城市
    var pickViewSourceNameAndCity: Bool = false
    
    var lastProvinceIndex: Int = 0
    
    /// 选择城市/姓别
    lazy var pickView: UIPickerView = {
        var pick = UIPickerView()
        pick.backgroundColor = UIColor(hex: 0xDCD7D7, alpha: 1.0)
        pick.hidden = true
        return pick
    }()
    
    /// 选择底部的view
    lazy var cancleBottomView: UIView = {
        var ve = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 50))
        ve.backgroundColor = UIColor.whiteColor()
        ve.addSubview(self.trueButton)
        ve.addSubview(self.sortButton)
        ve.addSubview(self.cancleButton)
        let w: CGFloat = 50
        self.trueButton.bounds = CGRectMake(0, 0, w, 44)
        self.sortButton.bounds = CGRectMake(0, 0, w, 44)
        self.cancleButton.bounds = CGRectMake(0, 0, w, 44)
        self.sortButton.center = ve.center
        let x: CGFloat = ve.bounds.width - w + w * 0.5
        let y: CGFloat = ve.bounds.height * 0.5
        self.trueButton.center = CGPointMake(x, y)
        let cx: CGFloat = w * 0.5
        self.cancleButton.center = CGPointMake(cx, y)
        self.sortButton.addTarget(self, action: "sortClick", forControlEvents: UIControlEvents.TouchUpInside)

        return ve
    }()
    /// 取消按钮
    lazy var cancleButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        return btn
    }()
    /// 确定按钮
    lazy var trueButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        return btn
    }()
    /// 类别按钮
    lazy var sortButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("类别", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        return btn
    }()
    
    /// 遮罩
    lazy var shadeView: UIButton = {
        let sv = UIButton(frame: UIScreen.mainScreen().bounds)
        sv.backgroundColor = UIColor.blackColor()
        sv.alpha = 0.0
        return sv
    }()
    
    @IBOutlet weak var exitLogin: UIButton!
    
    // MARK: - 初始化相关设置
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let saveButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
//        saveButton.setTitle("保存", forState: UIControlState.Normal)
//        saveButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
//        saveButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Selected)
//        saveButton.selected = true
//        saveButton.bounds = CGRectMake(0, 0, 40, 40)
//        saveButton.addTarget(self, action: "saveUserInfo:", forControlEvents: UIControlEvents.TouchUpInside)
//        let saveItem = UIBarButtonItem(customView: saveButton)
        let saveItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: "saveUserInfo:")
        navigationItem.rightBarButtonItem = saveItem
        saveItem.customView?.userInteractionEnabled = false
        
        
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        iconView.clipsToBounds = true
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "setting_black")!)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        pickView.dataSource = self
        pickView.delegate = self
        
        informSwitch.addTarget(self, action: "informSwitchClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let path = NSBundle.mainBundle().pathForResource("cities", ofType: "plist")
        let provinceArray = NSArray(contentsOfFile: path!)
        var provincesM = NSMutableArray()
        
        for dict in provinceArray! {
            let privin = Province.provinceWithDict(dict as! NSDictionary)
            provincesM.addObject(dict)
        }
        provinces = provincesM
        
        exitLogin.addTarget(self, action: "exitLoginClick", forControlEvents: UIControlEvents.TouchUpInside)
        exitLogin.layer.cornerRadius = 15
        exitLogin.clipsToBounds = true
    }
    
    func saveUserInfo(item: UIBarButtonItem) {
        
        println("保存用户信息\(item)")
    }
    
    func exitLoginClick() {
        println("退出登陆")
    }
    
    func sortClick() {
        print("点击了")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 删除最后的线
        informCell.baseline.removeFromSuperview()
    }
    
    func shadeViewClick() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.shadeView.alpha = 0.0
            self.pickView.frame.origin.y = UIScreen.mainScreen().bounds.height
            self.cancleBottomView.frame.origin.y = UIScreen.mainScreen().bounds.height
        }) { (_) -> Void in
            self.shadeView.removeFromSuperview()
            self.pickView.removeFromSuperview()
            self.cancleBottomView.removeFromSuperview()
        }
    }
    
    // MARK: - tableview delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 退出键盘
        nickName.resignFirstResponder()
        
        /// 先切换数据源方法，再实现动画
        if indexPath.row == SettingCell.sexCell {
            pickViewSourceNameAndCity = true
            pickView.reloadAllComponents()
        }
        
        if indexPath.row == SettingCell.cityCell {
            pickViewSourceNameAndCity = false
            pickView.reloadAllComponents()
        }
        
        
        
        /// pickView 位置动画
        if indexPath.row == SettingCell.cityCell || indexPath.row == SettingCell.sexCell{
            
            let h: CGFloat = pickViewSourceNameAndCity ? 162 : 216
            let y1: CGFloat = UIScreen.mainScreen().bounds.height
            let w: CGFloat = UIScreen.mainScreen().bounds.width
            pickView.frame = CGRectMake(0, y1, w, h)
            let y: CGFloat = UIScreen.mainScreen().bounds.height - pickView.bounds.height
            cancleBottomView.frame = CGRectMake(0, y1, w, 44)
            
            UIApplication.sharedApplication().keyWindow!.addSubview(shadeView)
            shadeView.addTarget(self, action: "shadeViewClick", forControlEvents: UIControlEvents.TouchUpInside)
            UIApplication.sharedApplication().keyWindow!.addSubview(pickView)
            UIApplication.sharedApplication().keyWindow!.addSubview(cancleBottomView)
            
            pickView.hidden = false
            if pickView.frame.origin.y > y {
            pickView.frame.origin.y = UIScreen.mainScreen().bounds.height
            let cy: CGFloat = y1 - pickView.frame.height - 44
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.pickView.frame.origin.y = y
                    self.shadeView.alpha = 0.5
                    self.cancleBottomView.frame.origin.y = cy
                })
            }
        } else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.pickView.frame.origin.y = UIScreen.mainScreen().bounds.height
            })
        }
        
        if indexPath.row == SettingCell.iconCell {
            // 选择照片
            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                return
            }
            let picker = UIImagePickerController()
            picker.delegate = self
            presentViewController(picker, animated: true, completion: nil)
        }

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        iconView.image = image
        dismissViewControllerAnimated(true, completion: nil)
        // 重新设回导航栏样式
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    // MARK: - pickView dataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickViewSourceNameAndCity ? 1 : 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickViewSourceNameAndCity {
                return 2
            } else {
                if component == 0 {
                    return provinces!.count
                } else {
                    var provinceIndex = pickerView.selectedRowInComponent(0)
                    return provinces![provinceIndex]["cities"]!!.count
                }
        }
    }
    
//    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        
//        return pickViewSourceNameAndCity ? 20 : 132
//    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //省份选中
        if (component == 0 && pickViewSourceNameAndCity == false) {
            pickerView.reloadComponent(1)
            self.lastProvinceIndex = row
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var label: UILabel?
        
        label = view != nil ? view as? UILabel : UILabel()
        
        label?.textAlignment = NSTextAlignment.Center
        
        if pickViewSourceNameAndCity {
            label?.text = row == 0 ? "男" : "女"
        } else {
            label?.text = component == 0 ? Province.provinceWithDict(provinces![row] as! NSDictionary).name : Province.provinceWithDict(provinces![lastProvinceIndex] as! NSDictionary).cities![row] as? String
        }
        return label!
    }
    

    
    /// 通知方法
    func informSwitchClick(inform: UISwitch) {
        let alertView = UIAlertView(title: nil, message: "请到设置—通知中打开我们的推送功能", delegate: self, cancelButtonTitle: "确定")
        alertView.show()
        inform.on = false
    }

}

// MARK: - settingTableViewCell
class settingTableViewCell: UITableViewCell {
    
    // 设置底线
    lazy var baseline: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(hex: 0x979797, alpha: 0.3)
        return baselineView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var x: CGFloat = 9
        var h: CGFloat = 0.5
        var y: CGFloat = self.bounds.height - h
        var w: CGFloat = self.bounds.width - x * 2
        baseline.frame = CGRectMake(x, y, w, h)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCellSelectionStyle.None
        addSubview(baseline)
    }
}

// MARK: - 省市模型
class Province : NSObject {
    
    var name: String?
    var cities: NSArray?
    
    class func provinceWithDict(dict: NSDictionary) -> Province {
        var province = Province()
        province.setValuesForKeysWithDictionary(dict as [NSObject : AnyObject])
        return province
    }
}