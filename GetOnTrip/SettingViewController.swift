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

class SettingViewController: UITableViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    
    // 昵称
    @IBOutlet weak var nickName: UITextView!
    /// 选择城市/姓别
    lazy var pickView: UIPickerView = {
        var pick = UIPickerView()
        pick.backgroundColor = UIColor(hex: 0xDCD7D7, alpha: 1.0)
        pick.hidden = true
        return pick
    }()
    
    /// 省市联动
    var provinces: NSArray?
    
    /// 当前省的索引
    var provinceIndex: Int = 0
    
    /// pick切换数据源方法 如果是true则是姓别，false是城市
    var pickViewSourceNameAndCity: Bool = false
    
    // MARK: - 初始化相关设置
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickName.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        iconView.clipsToBounds = true
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "setting_black")!)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        pickView.dataSource = self
        pickView.delegate = self
        tableView.addSubview(pickView)
        
        
        
        let path = NSBundle.mainBundle().pathForResource("cities", ofType: "plist")
        let provinceArray = NSArray(contentsOfFile: path!)
        var provincesM = NSMutableArray()
        
        for dict in provinceArray! {
            let privin = Province.provinceWithDict(dict as! NSDictionary)
            //            let privin = Province(dict: dict as! NSDictionary)
            provincesM.addObject(dict)
        }
        provinces = provincesM
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let h: CGFloat = 162
        let y: CGFloat = UIScreen.mainScreen().bounds.height
        let w: CGFloat = UIScreen.mainScreen().bounds.width
        pickView.frame = CGRectMake(0, y, w, h)
    }
    
    
    // MARK: - tableview delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /// 先切换数据源方法，再实现动画
        if indexPath.row == SettingCell.sexCell {
            pickViewSourceNameAndCity = true
            pickView.reloadAllComponents()
        }
        
        if indexPath.row == SettingCell.cityCell {
            pickViewSourceNameAndCity = false
            pickView.reloadAllComponents()
        }
        
        let y: CGFloat = UIScreen.mainScreen().bounds.height - pickView.bounds.height - 64
        
        
        /// pickView 位置动画
        if indexPath.row == SettingCell.cityCell || indexPath.row == SettingCell.sexCell{
            pickView.hidden = false
            if pickView.frame.origin.y > y {
            pickView.frame.origin.y = UIScreen.mainScreen().bounds.height
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.pickView.frame.origin.y = y
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

        //        if indexPath.row == SettingCell.nickCell {
////            pickView.hidden = false
////            pickViewSourceNameAndCity = true
//        }



    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        iconView.image = image
        dismissViewControllerAnimated(true, completion: nil)
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
                    var province: AnyObject = provinces![provinceIndex]
                    return province["cities"]!!.count
                }
        }
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        if pickViewSourceNameAndCity {
            return 20
        } else {
            return 150
        }
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //省份选中
        if (component == 0) {
            var province: AnyObject = provinces![row]
            pickerView.reloadComponent(1)
            self.provinceIndex = row
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var label: UILabel?
        
        if view != nil {
            label = view as? UILabel
        } else {
            label = UILabel()
        }
        
        if pickViewSourceNameAndCity {
            
            if row == 0 {
                label?.text = "男"
            } else {
                label?.text = "女"
            }
            
        } else {
            
            if component == 0 {
                var province = provinces![row] as! NSDictionary
                var temp = Province.provinceWithDict(province)
                label?.text = temp.name
                label?.textAlignment = NSTextAlignment.Center
            } else {
                var temp = provinces![provinceIndex] as! NSDictionary
                var province = Province.provinceWithDict(temp)
                label?.textAlignment = NSTextAlignment.Center
                label!.text = province.cities![row] as? String
            }
        }
        
        
        return label!


    }
    
    
    
    // MARK: UITextView Delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        var tempText = nickName.text as NSString
        if tempText.length > 5 {
            
            return false
        }
        
        return true
    }
    
    
}





















// MARK: - settingTableViewCell
class settingTableViewCell: UITableViewCell {
    
    // 设置底线
    lazy var baseline: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(white: 0x979797, alpha: 0.3)
        return baselineView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var x: CGFloat = 0
        var h: CGFloat = 0.5
        var y: CGFloat = self.bounds.height - h
        var w: CGFloat = self.bounds.width
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