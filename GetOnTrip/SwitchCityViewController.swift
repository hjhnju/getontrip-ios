//
//  SwitchCityViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/8.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SwitchCityViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    lazy var cityGroupData: NSArray = {
        let array = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("cityGroups.plist", ofType: nil)!)
        var arrayM = NSMutableArray()
        for it in array! {
            arrayM.addObject(CityGorupModel.cityGorupWithDict(it as! [NSObject : AnyObject]))
        }
        return arrayM.copy() as! NSArray
    }()

    lazy var searchBar: UISearchBar = {
        var search = UISearchBar()
        return search
    }()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        return tableView
    }()
    
    lazy var coverButton: UIButton = {
        var btn = UIButton()
        btn.backgroundColor = UIColor.blackColor()
        btn.alpha = 0
        btn.tag = 10
        
        btn.addTarget(self, action: "coverClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        // UIView + AutoLayout
//        [cover autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        // 布局单条边
//        [cover autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:15 ];
        return btn
    }()
    
    /// 搜索结果控制器
    lazy var citySearchVC: CitySearchViewController = {
        var svc = CitySearchViewController()
        return svc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(coverButton)
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.frame = CGRectMake(0, 20, view.bounds.width, 44)
        tableView.frame = CGRectMake(0, 64, view.bounds.width, view.bounds.height - 64)
        coverButton.frame = tableView.frame
        citySearchVC.view.frame = tableView.frame
        
        addChildViewController(citySearchVC)
        view.addSubview(citySearchVC.view)
        citySearchVC.view.hidden = true
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "switchCityController_Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    // MARK: - 数据源方法
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cityGroupData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cityGorupModel: AnyObject = cityGroupData[section]
        return cityGorupModel.cities!!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("switchCityController_Cell") as! UITableViewCell
        let city: CityGorupModel = cityGroupData[indexPath.section] as! CityGorupModel
        cell.textLabel!.text = city.cities![indexPath.row] as? String

        return cell
    }

    // MARK: searchBar代理方法
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
        for subView in searchBar.subviews.first!.subviews {
            if subView is UIButton {
                subView.setTitle("取消", forState: UIControlState.Normal)
            }
        }
        
        //4. 遮盖
        coverButton.alpha = 0.5
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: false)
        self.coverButton.alpha = 0
        
        searchBar.text = ""
        citySearchVC.view.hidden = true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        var text: NSString = searchBar.text as NSString
        if text.length > 0 {
            println("进这里了")
            citySearchVC.view.hidden = false
            citySearchVC.searchText = searchText
        } else {
            println("还是进这里")
            citySearchVC.view.hidden = true
        }
    }
    
//    #pragma mark 搜索内容发生改变
//    - (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//    {
//    // 如果输入有内容, 在显示搜索结果控制器的view
//    if (searchBar.text.length) {
//    self.citySearchVC.view.hidden = NO;
//    self.citySearchVC.searchText = searchText;
//    } else {
//    self.citySearchVC.view.hidden = YES;
//    }
//    }
    
    /// MARK: - 取消搜索
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func coverClick() {
        searchBar.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let cityM: AnyObject = cityGroupData[section]
        return cityM.title!!
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return cityGroupData.valueForKey("title") as? [AnyObject]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var cityM = cityGroupData[indexPath.section]
        
//        NSNotificationCenter.defaultCenter().postNotificationName(<#aName: String#>, object: <#AnyObject?#>, userInfo: <#[NSObject : AnyObject]?#>)
    }
    

//    
//    #pragma mark 选中时, 发送数据
//    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//    {
//    // 先取出对应的模型数据
//    MTCityGorupModel *cityGorupModel = self.cityGroupData[indexPath.section];
//    
//    // 发送通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:MTCityDidChangeNotifacation object:nil userInfo:@{MTSelectCityName : cityGorupModel.cities[indexPath.row]}];
//    
//    // 消失控制器
//    [self dismissViewControllerAnimated:YES completion:nil];
//    }
    

}


// MARK: - 搜索结果控制器
class CitySearchViewController: UITableViewController {
    
    /// 所有城市数据
    lazy var citiesData: NSArray = {
        var citi = NSArray()
        return citi
    }()
    
    /// 检索结果
    var resultData: NSMutableArray?
    
    var searchText: String? {
        didSet {
            // 1. copy
            var st: String = searchText!.copy() as! String
            // 2. 转换小写
            searchText! = searchText!.lowercaseString
            // 3. 清空上一次数据
            resultData!.removeAllObjects()
            // 4. 检索数据
            for cityModel: SearchCityModel in citiesData as! [SearchCityModel] {
                
                if (NSString(string: cityModel.name!).containsString(searchText!) ||
                   NSString(string: cityModel.pinYin!).containsString(searchText!) ||
                   NSString(string: cityModel.pinYinHead!).containsString(searchText!)) {
                    resultData!.addObject(cityModel.name!)
                }
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesData = MetaTool.cities
        resultData = NSMutableArray()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "citySearchController_Cell")
    }
    
    // MARK: - 数据源方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultData!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("citySearchController_Cell") as! UITableViewCell
        cell.textLabel!.text = resultData![indexPath.row] as? String ?? ""
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "共有\(resultData!.count)个搜索结果"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("CityDidChangeNotifacation", object: nil, userInfo: ["SelectCityName": resultData!.count])
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - 分类数据
class MetaTool: NSObject {
    
    /// 返回城市数据
    static var cities: NSArray = {
        let array = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("seachCities.plist", ofType: nil)!)
        var arrayM = NSMutableArray()
        for it in array! {
            arrayM.addObject(SearchCityModel.searchCityGorupWithDict(it as! [NSObject : AnyObject]))
        }
        return arrayM.copy() as! NSArray
    }()
}


// MARK: - 城市模型
class SearchCityModel: NSObject {
    /// 名字
    var name: String?
    /// 图标
    var pinYin: String?
    /// 高亮图标
    var pinYinHead: String?
    /// 子区域
    var districts: NSArray?
    
    class func searchCityGorupWithDict(dict: [NSObject: AnyObject]) -> SearchCityModel {
        var cityModel = SearchCityModel()
        cityModel.setValuesForKeysWithDictionary(dict)
        return cityModel
    }
}

// MARK: - 城市模型
class CityGorupModel: NSObject {
    /// 城市分组
    var cities: NSArray?
    /// 分组标题
    var title: String?
    
    class func cityGorupWithDict(dict: [NSObject: AnyObject]) -> CityGorupModel {
        var cityModel = CityGorupModel()
        cityModel.setValuesForKeysWithDictionary(dict)
        return cityModel
    }
}