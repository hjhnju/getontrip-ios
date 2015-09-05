//
//  SettingViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/2.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // 头像
    @IBOutlet weak var iconView: UIImageView!
    
    lazy var pickView: UIPickerView = {
        var pick = UIPickerView()
        pick.backgroundColor = UIColor(hex: 0xDCD7D7, alpha: 1.0)
        return pick
    }()
    
    lazy var provinces: NSArray = {
        let path = NSBundle.mainBundle().pathForResource("provinces", ofType: "plist")
        let provinceArray = NSArray(contentsOfFile: path!)
        var provincesM = NSMutableArray()
        
        for dict in provinceArray! {
            let privin = Provinces().provinceWithDict(dict as! NSDictionary)
            provincesM.addObject(dict)
        }
        
        return provincesM
    }()
    
    var provinceIndex: Int = 0
    
    // MARK: - 初始化相关设置
    override func viewDidLoad() {
        super.viewDidLoad()

        println(provinces)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        iconView.clipsToBounds = true
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "setting_black")!)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        pickView.dataSource = self
        pickView.delegate = self
        tableView.addSubview(pickView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let h: CGFloat = 162
        let y: CGFloat = UIScreen.mainScreen().bounds.height - h - 64
        let w: CGFloat = UIScreen.mainScreen().bounds.width
        pickView.frame = CGRectMake(0, y, w, h)
    }
    
    // MARK: - tableview delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        if indexPath.row == 1 {
            // 选择照片
            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                return
            }
            let picker = UIImagePickerController()
            picker.delegate = self
            presentViewController(picker, animated: true, completion: nil)
        }
        
        if indexPath.row == 3 {
//            let h: CGFloat = 162
//            let y: CGFloat = UIScreen.mainScreen().bounds.height - h - 64
//            let w: CGFloat = UIScreen.mainScreen().bounds.width
//            var pick = UIPickerView(frame: CGRectMake(0, y, w, h))
//            tableView.addSubview(pick)
//            pick.backgroundColor = UIColor.whiteColor()
//            pick.dataSource = self
//            pick.delegate = self
            
        }

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        iconView.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - pickView dataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return provinces.count
        } else {
            var province: AnyObject = provinces[provinceIndex]
            return 5
        }

    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 150
        } else {
            return 150
        }
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        var province: AnyObject = provinces[row]
        return province.name
    }
    
//    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
//        
//        var label: UILabel?
//        
//        if view != nil {
//            label = view as? UILabel
//        } else {
//            label = UILabel()
//        }
//        
//        if component == 0 {
//            var province: AnyObject = provinces[row]
//            label?.text = province.name
//            label?.backgroundColor = UIColor.grayColor()
//            label?.bounds = CGRectMake(0, 0, 150, 30)
//        } else {
//            var province: AnyObject = provinces[provinceIndex]
//            label!.text = province.cities[row]! as! String
//            label!.backgroundColor = UIColor.purpleColor()
//        }
//        return label!
//        
//
//
//    }
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
//        if row == 0 {
//            return "男"
//        } else {
//            return "女"
//        }
//    }
    
    
    
    
    
    
    
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
class Provinces : NSObject {
    
    var name: String?
    var cities: NSArray?
    
    func provinceWithDict(dict: NSDictionary) -> Provinces{
        var provinces = Provinces()
        provinces.setValuesForKeysWithDictionary(dict as [NSObject : AnyObject])
        return provinces
    }
}