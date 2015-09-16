//
//  SettingViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/2.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import Alamofire

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
    
    /// 昵称
    @IBOutlet weak var nickName: UITextField!
    /// 性别
    @IBOutlet weak var gender: UILabel!
    /// 临时保存性别
    var saveGender: String?
    /// 通知
    @IBOutlet weak var informSwitch: UISwitch!
    /// 通知行的cell
    @IBOutlet weak var informCell: settingTableViewCell!
    /// 城市
    @IBOutlet weak var city: UILabel!
    /// 临时保存城市
    var saveCity: String?
    var saveTown: String?
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
        btn.addTarget(self, action: "shadeViewClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    /// 确定按钮
    lazy var trueButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: "trueButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    /// 类别按钮
    lazy var sortButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("性别", forState: UIControlState.Normal)
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
    
    /// 保存按钮
    var saveItem: UIBarButtonItem?
    
    /// 保存用户信息请求
    var lastSuccessRequest: UserUploadInfoRequest?

    
    
    /// 退出登陆按钮
    @IBOutlet weak var exitLogin: UIButton!
    
    // MARK: - 初始化相关设置
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// TPDO: 先注释
        iconView.sd_setImageWithURL(NSURL(string: sharedUserAccount!.icon!))
        nickName.text = sharedUserAccount?.nickname
        println(sharedUserAccount?.gender)
        if sharedUserAccount?.gender?.hashValue == 0 {
            gender.text = "男"
        } else if sharedUserAccount?.gender?.hashValue == 1 {
            gender.text = "女"
        } else {
            gender.text = "未知"
        }
        
        city.text = sharedUserAccount?.city
        
        saveItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: "saveUserInfo:")
        navigationItem.rightBarButtonItem = saveItem
        saveItem!.enabled = false

        informSwitch.addTarget(self, action: "informSwitchClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        loadInitSetting()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "nickNameTextFieldTextDidChangeNotification:", name: UITextFieldTextDidChangeNotification, object: nickName)
    }
    
    func nickNameTextFieldTextDidChangeNotification(notification: NSNotification) {
        saveItem?.enabled = true
        let textField = notification.object as! UITextField
        nickName.text = textField.text
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: nickName)
    }
    
    private func loadInitSetting() {
        // 头像及tableview设置
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        iconView.clipsToBounds = true
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "setting_black")!)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 省市联动
        pickView.dataSource = self
        pickView.delegate = self
        let path = NSBundle.mainBundle().pathForResource("cities", ofType: "plist")
        let provinceArray = NSArray(contentsOfFile: path!)
        var provincesM = NSMutableArray()
        
        for dict in provinceArray! {
            let privin = Province.provinceWithDict(dict as! NSDictionary)
            provincesM.addObject(dict)
        }
        provinces = provincesM
        
        // 退出登陆
        exitLogin.addTarget(self, action: "exitLoginClick", forControlEvents: UIControlEvents.TouchUpInside)
        exitLogin.layer.cornerRadius = 15
        exitLogin.clipsToBounds = true
    }
    
    func exitLoginClick() {
        println("退出登陆")
        sharedUserAccount = nil
        // 将页面返回到首页
        super.navigationController?.navigationController!.popViewControllerAnimated(true)
    }
    
    func sortClick() {
        print("点击了")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pickerView(pickView, didSelectRow: 0, inComponent: 0)
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
            saveItem?.enabled = true
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
        
        if pickViewSourceNameAndCity == false {
            
            let provin: AnyObject = self.provinces![lastProvinceIndex]
            switch (component) {
            case 0:
                saveCity = provin["name"] as? String
                let citi = provin["cities"] as! NSArray
                saveTown = citi[0] as? String
                
                println(row)
                break;
            case 1:
                let citi = provin["cities"] as! NSArray
                saveTown = citi[row] as? String
                break;
            default:
                break;
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var label: UILabel?
        
        label = view != nil ? view as? UILabel : UILabel()
        
        label?.textAlignment = NSTextAlignment.Center
        
        if pickViewSourceNameAndCity {
            label?.text = row == 0 ? "男" : "女"
            saveGender = label?.text
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
    
    // MARK: - other method
    /// 确定按钮
    func trueButtonClick(btn: UIButton) {
        
        if pickViewSourceNameAndCity {
            // 设置性别
            gender.text = saveGender
//            pickerView(pickView, didSelectRow: 0, inComponent: 0)
            pickView.selectedRowInComponent(0)
        } else {
            // 设置城市
            city.text = saveCity! + saveTown!
        }
        shadeViewClick()
        saveItem?.enabled = true
    }
    
    
    /*
    - (NSData *)formData:(NSData *)fileData fieldName:(NSString *)fieldName fileName:(NSString *)fileName {
        NSMutableData *dataM = [NSMutableData data];
        
        NSMutableString *strM = [NSMutableString string];
        
        [strM appendFormat:@"--%@\r\n", boundary];
        [strM appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, fileName];
        [strM appendString:@"Content-Type: application/octet-stream\r\n\r\n"];
        
        // 先插入 strM
        [dataM appendData:[strM dataUsingEncoding:NSUTF8StringEncoding]];
        // 插入文件数据
        [dataM appendData:fileData];
        
        NSString *tail = [NSString stringWithFormat:@"\r\n--%@--", boundary];
        [dataM appendData:[tail dataUsingEncoding:NSUTF8StringEncoding]];
        
        return dataM.copy;
    }
*/
    
    /*
    - (void)postUpload:(NSString *)fieldName dataDict:(NSDictionary *)dataDict params:(NSDictionary *)params {
        // 1. url － 负责上传文件的脚本路径
        NSURL *url = [NSURL URLWithString:@"http://192.168.13.85/post/upload-m.php"];
        
        // 2. request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        // 2.1 method
        request.HTTPMethod = @"POST";
        // 2.2 content-type
        NSString *typeValue = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:typeValue forHTTPHeaderField:@"Content-Type"];
        
        // 2.3 httpbody !!! - uploadTask 不需要
        // *** session 通过 fromData 来指定
        NSData *data = [self formData:fieldName dataDict:dataDict params:params];
        
        [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]);
        }] resume];
    }
*/
    func postUpload(fieldName: String, dataDict: NSDictionary, params: NSDictionary) {
        let url = NSURL(string: "http://127.0.0.1/uploads/upload-m.php")
        
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        
        var typeValue = "multipart/form-data; boundary=upload"
        request.setValue(typeValue, forHTTPHeaderField: "Content-Type")
        
        var imageData = UIImagePNGRepresentation(iconView.image)
        var data = formData(fieldName, dataDict: dataDict, params: params)

        NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: data) { (data, response, error) -> Void in
            println(data)
            
        }.resume()
    }

    func formData(fieldName: String, dataDict: NSDictionary, params: NSDictionary) -> NSData {
        
        var dataM = NSMutableData()
        
        dataDict.enumerateKeysAndObjectsUsingBlock { (fileName, fileData, stop) -> Void in
            
            var strM = NSMutableString()
            
            strM.appendFormat("--%@\r\n", "xxx")
            strM.appendFormat("Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName as String, fileName as! String)
            strM.appendString("Content-Type: application/octet-stream\r\n\r\n")
            dataM.appendData(strM.dataUsingEncoding(NSUTF8StringEncoding)!)
            dataM.appendData(fileData as! NSData)
            var tail = NSString(format: "\r\n--%@--", "xxx")
            dataM.appendData(tail.dataUsingEncoding(NSUTF8StringEncoding)!)
            
        }
        
        return dataM.copy() as! NSData
    }
    
    
    /// MARK: - 保存用户信息
    func saveUserInfo(item: UIBarButtonItem) {
        
        let path = NSBundle.mainBundle().pathForResource("1.jpg", ofType: nil)
//        NSDictionary *dict = @{@"other.png": [NSData dataWithContentsOfFile:path]};
       
        var dict = NSMutableDictionary()
        dict.setValue(NSData(contentsOfFile: path!), forKey: "2.jpg")
        
        
        postUpload("userfile[]", dataDict: dict, params: NSDictionary())
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        println("保存用户信息\(item)")
        
        
//        let fileURL = NSBundle.mainBundle().URLForResource("Default", withExtension: "png")
        
//        let imageData = UIImagePNGRepresentation(iconView.image)
//    
////        Alamofire.upload(.POST, "http://123.57.46.229:8301/upload/pic", file: fileURL!)
//        imageData.writeToURL(NSURL(string: "http://127.0.0.1/uploads/2.png")!, atomically: true)
//        
//        Alamofire.upload(.POST, "http://127.0.0.1/upload-m.php", data: formData(imageData, fieldName: "2.png", fileName: "3.png"))
//        
//        NSURL *url = [NSURL URLWithString:@"http://192.168.13.85/post/upload-m.php"];
//        
//        // 2. request
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//        request.HTTPMethod = @"POST";
//        
//        // 2.1 设置 content-type
//        NSString *type = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//        [request setValue:type forHTTPHeaderField:@"Content-Type"];
//        
//        // 2.2 设置数据体
//        request.HTTPBody = [self formData:fileDict fieldName:fieldName params:params];
//        
//        // 3. connection
//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]);
//        }];

        
        /*
        
       
        
        
        
        --随便\r\n
        Content-Disposition: form-data; name="userfile"; filename="111.txt"\r\n
        Content-Type: application/octet-stream\r\n\r\n
        
        要上传文件的二进制数据
        \r\n
        --随便--
        */
        

    }
    
    private func saveUserInfo() {
        
        //获取数据更新tableview
        if lastSuccessRequest == nil {
//            param=nick_name:aa,type:jpg,image:bb,sex:1
            var param = [[String: String]]()
            
            param.append(["nick_name": nickName.text])
            param.append(["type": "png"])
            let imageData = UIImageJPEGRepresentation(iconView.image, 1)
//            param.append(["image": "\(imageData)"])
            let sex = gender.text == "男" ? "1" : "2"
            param.append(["sex":  sex])
            lastSuccessRequest = UserUploadInfoRequest(userid: sharedUserAccount!.uid!.toInt()!, type: sharedUserAccount!.type, param: param, image: "\(imageData)")
        }
        
//        lastSuccessRequest?.fetchAddInfoModels {(handler: Topic -> Void)
        lastSuccessRequest!.fetchAddInfoModels { (handler: Topic) -> Void in
        
        }
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