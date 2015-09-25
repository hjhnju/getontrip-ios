//
//  SettingViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/2.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

/// 定义选中的是第几行
struct SettingCell {
    /// 0
    static let iconCell = 0
    /// 1
    static let nickCell = 1
    /// 2
    static let sexCell  = 2
    /// 3
    static let cityCell = 3
}

class SettingViewController: UITableViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    /// 头像
    lazy var iconView: UIImageView = UIImageView()
    
    /// 昵称
    lazy var nickName: UITextField = UITextField(alignment: NSTextAlignment.Right, sizeFout: 14, color: UIColor.whiteColor())
    /// 性别
    lazy var gender: UILabel = UILabel(color: UIColor.whiteColor(), title: "男", fontSize: 14, mutiLines: false)
    
    /// 临时保存性别
    var saveGender: String?
    
    /// 通知
    lazy var informSwitch: UISwitch = UISwitch()
    
    /// 城市
    lazy var city: UILabel = UILabel(color: UIColor.whiteColor(), title: "未知", fontSize: 14, mutiLines: false)
    
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
    lazy var pickView: UIPickerView = UIPickerView(color: SceneColor.shallowWhite, hidde: true)
    
    /// 选择底部的view
    lazy var cancleBottomView: UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 50))
    
    /// 取消按钮
    lazy var cancleButton: UIButton = UIButton(title: "取消", fontSize: 18, radius: 0, titleColor: UIColor.blueColor())

    /// 确定按钮
    lazy var trueButton: UIButton = UIButton(title: "确定", fontSize: 18, radius: 0, titleColor: UIColor.blueColor())
    
    /// 性别按钮
    lazy var sortButton: UIButton = UIButton(title: "性别", fontSize: 18, radius: 0, titleColor: UIColor.blueColor())
    
    /// 遮罩
    lazy var shadeView: UIButton = UIButton(color: UIColor.blackColor(), alphaF: 0.0)
    
    /// 保存按钮
    var saveItem: UIBarButtonItem?
    
    /// 保存用户信息请求
    var lastSuccessRequest: UserUploadInfoRequest?

    /// 退出登陆按钮
    lazy var exitLogin: UIButton = UIButton(title: "退出登陆", fontSize: 14, radius: 34 * 0.5)
    
    // MARK: - 初始化相关设置
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddProperty()
        setupInitSetting()
        setupBarButtonItem()
        loadInitSetting()
    }
    
    private func setupAddProperty() {
        
        cancleBottomView.backgroundColor = UIColor.whiteColor()
        cancleBottomView.addSubview(self.trueButton)
        cancleBottomView.addSubview(self.sortButton)
        cancleBottomView.addSubview(self.cancleButton)
        
        shadeView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        cancleButton.addTarget(self, action: "shadeViewClick:", forControlEvents: UIControlEvents.TouchUpInside)
        trueButton.addTarget(self, action: "trueButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        sortButton.addTarget(self, action: "sortClick", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupInitSetting() {
        title = "设置"
        /// TPDO: 先注释
        iconView.sd_setImageWithURL(NSURL(string: sharedUserAccount!.icon!))
        nickName.text = sharedUserAccount?.nickname
        
        if      sharedUserAccount?.gender?.hashValue == 0 { gender.text = "男" }
        else if sharedUserAccount?.gender?.hashValue == 1 { gender.text = "女" }
        else                                              { gender.text = "未知"}
        
        city.text = sharedUserAccount?.city
        
    }
    
    private func setupBarButtonItem() {
        
        saveItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: "saveUserInfo:")
        navigationItem.rightBarButtonItem = saveItem
        saveItem!.enabled = false
        informSwitch.addTarget(self, action: "informSwitchClick:", forControlEvents: UIControlEvents.TouchUpInside)
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
        // tableview设置
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "setting_black")!)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 省市联动
        pickView.dataSource = self
        pickView.delegate = self
        let path = NSBundle.mainBundle().pathForResource("cities", ofType: "plist")
        let provinceArray = NSArray(contentsOfFile: path!)
        let provincesM = NSMutableArray()
        
        for dict in provinceArray! {
            _ = Province.provinceWithDict(dict as! NSDictionary)
            provincesM.addObject(dict)
        }
        provinces = provincesM
        
        // 退出登陆
        exitLogin.addTarget(self, action: "exitLoginClick", forControlEvents: UIControlEvents.TouchUpInside)
        exitLogin.layer.cornerRadius = 15
        exitLogin.clipsToBounds = true
    }
    
    func exitLoginClick() {
        print("退出登陆")
        sharedUserAccount = nil
        // 将页面返回到首页
        navigationController!.popViewControllerAnimated(true)
    }
    
    func sortClick() {
        print("点击了")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pickerView(pickView, didSelectRow: 0, inComponent: 0)
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
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 2
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.7), title: "   基本资料", fontSize: 11, mutiLines: false)
        } else {
            return UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.7), title: "   消息推送", fontSize: 11, mutiLines: false)
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = settingTableViewCell()
        if indexPath.section == 0 {
            
            if indexPath.row == SettingCell.iconCell {

                let baseView = UIView(color: SceneColor.shallowGrey, alphaF: 0.2)
                cell.left.text = "头像"
                cell.addSubview(iconView)
                iconView.layer.cornerRadius = 66 * 0.5
                iconView.layer.masksToBounds = true
                iconView.ff_AlignInner(ff_AlignType.CenterRight, referView: cell, size: CGSizeMake(66, 66), offset: CGPointMake(-10, 0))
                cell.addSubview(baseView)
                baseView.ff_AlignInner(ff_AlignType.TopCenter, referView: cell, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
                
            } else if indexPath.row == SettingCell.nickCell {
                
                cell.left.text = "昵称"
                cell.addSubview(nickName)
                nickName.ff_AlignInner(ff_AlignType.CenterRight, referView: cell, size: CGSizeMake(200, 17), offset: CGPointMake(-10, 0))
                nickName.text = "美女，亲一个"
                
            } else if indexPath.row == SettingCell.sexCell {
                
                cell.left.text = "性别"
                cell.addSubview(gender)
                gender.ff_AlignInner(ff_AlignType.CenterRight, referView: cell, size: nil, offset: CGPointMake(-9, 0))
                
            } else {
                
                cell.left.text = "城市"
                cell.addSubview(city)
                city.ff_AlignInner(ff_AlignType.CenterRight, referView: cell, size: nil, offset: CGPointMake(-9, 0))
            }
            
        } else {
            
            if indexPath.row == 0 {
                
                let baseView = UIView(color: SceneColor.shallowGrey, alphaF: 0.2)
                cell.left.text = "是否实时接收我们为您推荐的相关话题？"
                cell.addSubview(baseView)
                baseView.ff_AlignInner(ff_AlignType.TopCenter, referView: cell, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
                cell.addSubview(informSwitch)
                informSwitch.ff_AlignInner(ff_AlignType.CenterRight, referView: cell, size: nil, offset: CGPointMake(-9, 0))
            } else {
                cell.left.removeFromSuperview()
                cell.addSubview(self.exitLogin)
                exitLogin.ff_AlignInner(ff_AlignType.CenterCenter, referView: cell, size: CGSizeMake(167, 34), offset: CGPointMake(0, 0))
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 46 : 94
    }

    /// 每行的行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            if indexPath.row == 0      { return 102}
            else if indexPath.row == 1 { return 51 }
            else if indexPath.row == 2 { return 51 }
            else                       { return 51 }
        } else {
            if indexPath.row == 0      { return 51 }
            else                       { return 200 }
        }
    }

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
                    let provinceIndex = pickerView.selectedRowInComponent(0)
                    return provinces![provinceIndex]["cities"]!!.count
                }
        }
    }
    
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
                
                print(row)
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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
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
        
        let typeValue = "multipart/form-data; boundary=upload"
        request.setValue(typeValue, forHTTPHeaderField: "Content-Type")
        
        _ = UIImagePNGRepresentation(iconView.image!)
        let data = formData(fieldName, dataDict: dataDict, params: params)

        NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: data) { (data, response, error) -> Void in
//            print(data)
            
        }.resume()
    }

    func formData(fieldName: String, dataDict: NSDictionary, params: NSDictionary) -> NSData {
        
        let dataM = NSMutableData()
        
        dataDict.enumerateKeysAndObjectsUsingBlock { (fileName, fileData, stop) -> Void in
            
            let strM = NSMutableString()
            
            strM.appendFormat("--%@\r\n", "xxx")
            strM.appendFormat("Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName as String, fileName as! String)
            strM.appendString("Content-Type: application/octet-stream\r\n\r\n")
            dataM.appendData(strM.dataUsingEncoding(NSUTF8StringEncoding)!)
            dataM.appendData(fileData as! NSData)
            let tail = NSString(format: "\r\n--%@--", "xxx")
            dataM.appendData(tail.dataUsingEncoding(NSUTF8StringEncoding)!)
            
        }
        
        return dataM.copy() as! NSData
    }

    
    /// MARK: - 保存用户信息
    func saveUserInfo(item: UIBarButtonItem) {
        
        let imageData = UIImagePNGRepresentation(iconView.image!)
        var post       = [String: String]()
        post["userid"] = String(stringInterpolationSegment: appUUID)
        post["type"]   = String(stringInterpolationSegment: 3)
        post["param"]  = String(stringInterpolationSegment: [["nick_name": "aa"], ["type": "png"], ["sex": "1"]])
        post["image"]  = String(stringInterpolationSegment: imageData)
        HttpRequest.uploadPicture("http://127.0.0.1", fieldName: "123", dataList: ["123" : imageData!], parameters: post) { (JSON) -> () in
            print(JSON)
        }
        
        var params = [String:String]()
        params["userid"] = appUUID
        params["type"] = "3"
        params["param"] = "nick_name:aa,type:jpg,sex:1"
        
        
    
    
        print("保存用户信息\(item)")
        

        
        

        

    }
    
    private func saveUserInfo() {
        
        //获取数据更新tableview
        if lastSuccessRequest == nil {
//            param=nick_name:aa,type:jpg,image:bb,sex:1
            var param = [[String: String]]()
            
            param.append(["nick_name": nickName.text!])
            param.append(["type": "png"])
            let imageData = UIImageJPEGRepresentation(iconView.image!, 1)
//            param.append(["image": "\(imageData)"])
            let sex = gender.text == "男" ? "1" : "2"
            param.append(["sex":  sex])
            lastSuccessRequest = UserUploadInfoRequest(userid: Int(sharedUserAccount!.uid!)!, type: sharedUserAccount!.type, param: param, image: "\(imageData)")
        }
        
        lastSuccessRequest!.fetchAddInfoModels { (handler: Topic) -> Void in
        
        }
    }

}

// MARK: - settingTableViewCell
class settingTableViewCell: UITableViewCell {
    
    /// 左标签
    lazy var left: UILabel = UILabel(color: UIColor.whiteColor(), title: "名字", fontSize: 14, mutiLines: false)
    
    /// 设置底线
    lazy var baseline: UIView! = UIView(color: SceneColor.shallowGrey, alphaF: 0.3)
    
    init() {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        backgroundColor = UIColor.clearColor()
        
        addSubview(baseline)
        addSubview(left)
        
        selectionStyle = UITableViewCellSelectionStyle.None
        baseline.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
        left.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: nil, offset: CGPointMake(9, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 省市模型
class Province : NSObject {
    
    var name: String?
    var cities: NSArray?
    
    class func provinceWithDict(dict: NSDictionary) -> Province {
        let province = Province()
        province.setValuesForKeysWithDictionary(dict as! [String : AnyObject])
        return province
    }
}
