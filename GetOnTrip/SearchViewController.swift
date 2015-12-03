//
//  SearchViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import CoreLocation

struct SearchViewContant {
    static let hotwordCellId = "SearchHotwordTableViewCellID"
    static let recordCellId  = "SearchRecordTableViewCellID"
    
    static let recordLimit = 4
}

class SearchViewController: UISearchController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    let searchResultViewController =  SearchResultsViewController()
    
    /// 搜索记录TableView
    let recordTableView = UITableView()
    
    /// 搜索组标题
    var recordTitleView: UIView = UIView()
    
    let recordLabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "  搜索历史", fontSize: 12, mutiLines: true)
    
    /// 搜索记录(不可重复，按最近搜索排序）
    var recordData = [String]()
    
    /// 清除按钮
    var recordDelButton: UIButton = UIButton(title: "清除", fontSize: 10, radius: 0, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.6))
    
    /// 热门搜索词
    var hotwordData = [String]()
    
    var hotWordLabel: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "  热门搜索", fontSize: 12, mutiLines: true)
    
    /// 搜索提示
    var noSearchResultLabel: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "当前搜索无内容", fontSize: 14, mutiLines: true)
    
    /// 定位城市
    var locationButton: UIButton = UIButton(image: "location_yellow", title: " 即刻定位当前城市", fontSize: 12, titleColor: UIColor(hex: 0xF3FD54, alpha: 1.0))
    
    //位置管理器
    lazy var locationManager: CLLocationManager = CLLocationManager()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(searchResultsController: searchResultViewController)
        searchResultsUpdater = searchResultViewController
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 应用程序使用期间允许定位
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        let imageV = UIImageView(image: UIImage(named: "search-bg")!)
        view.addSubview(imageV)
        view.addSubview(searchResultViewController.view)
        imageV.frame = UIScreen.mainScreen().bounds
        setupAddProperty()
        loadHotSearchLabel()
    }
    
    /// 切换当前城市
    func switchCurrentCity(btn: UIButton) {
        // 开始定位
        locationManager.startUpdatingLocation()
        
        if currentCityId != "-1" && currentCityId != "0" && currentCityId != "" {
            let vcity = CityViewController()
            vcity.cityDataSource = City(id: currentCityId)
            self.searchResultViewController.showSearchResultController(vcity)
            return
        }
        
        if currentCityId == "-1" {
            ProgressHUD.showSuccessHUD(self.view, text: "正在定位中")
        } else if currentCityId == "0" {
            ProgressHUD.showSuccessHUD(self.view, text: "当前城市未开通")
        }
    }
    
    var textfile: UITextField? {
        didSet {
            textfile?.textColor = UIColor.whiteColor()
            let leftView = UIImageView(image: UIImage(named: "search_icon"))
            textfile?.leftViewMode = UITextFieldViewMode.Always
            textfile?.leftView = leftView
            textfile?.rightView?.backgroundColor = UIColor.whiteColor()
            textfile?.attributedPlaceholder = NSAttributedString(string: "搜索", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
    }
    
    private func setupAddProperty() {
        
        if let userDefault = NSUserDefaults.standardUserDefaults().valueForKey("recordData") as? [String] {
            recordData = userDefault
        }
        addChildViewController(searchResultViewController)
        view.addSubview(recordTableView)
        view.addSubview(locationButton)
        view.addSubview(noSearchResultLabel)
        
        hidesNavigationBarDuringPresentation = false
        searchBar.barStyle = UIBarStyle.Black
        searchBar.keyboardAppearance = UIKeyboardAppearance.Default
        searchBar.delegate = self
        
        recordTableView.registerClass(SearchRecordTableViewCell.self, forCellReuseIdentifier: SearchViewContant.recordCellId)
        recordTableView.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, UIScreen.mainScreen().bounds.height - 110), offset: CGPointMake(0, 0))
        locationButton.ff_AlignInner(.TopCenter, referView: view, size: nil, offset: CGPointMake(0, 92))
        noSearchResultLabel.ff_AlignVertical(.BottomCenter, referView: locationButton, size: nil, offset: CGPointMake(0, 81))
        recordTableView.backgroundColor = UIColor.clearColor()
        recordTableView.dataSource = self
        recordTableView.delegate = self
        recordTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        recordTitleView.addSubview(recordLabel)
        recordTitleView.addSubview(recordDelButton)
        recordDelButton.addTarget(self, action: "deleteButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        recordLabel.frame = CGRectMake(0, 50 - 25, 100, 12)
        recordDelButton.frame = CGRectMake(view.bounds.width - 30, 50 - 25 , 20, 10)
        recordTableView.registerClass(SearchHotwordTableViewCell.self, forCellReuseIdentifier: SearchViewContant.hotwordCellId)
        
        locationButton.addTarget(self, action: "switchCurrentCity:", forControlEvents: UIControlEvents.TouchUpInside)
        noSearchResultLabel.hidden = true
        
        searchBar.setSearchFieldBackgroundImage(UIImage(named: "search_box"), forState: UIControlState.Normal)
        searchBar.tintColor = UIColor(hex: 0xFFFFFF, alpha: 0.5)
        searchBar.translucent = true
        
        for item in searchBar.subviews {
            for it in item.subviews {
                if it.isKindOfClass(NSClassFromString("UISearchBarBackground")!) {
                    it.removeFromSuperview()
                }
                if it.isKindOfClass(NSClassFromString("UISearchBarTextField")!) {
                    textfile = it as? UITextField
                }
            }
        }
    }
    
    private func loadHotSearchLabel() {
        SearchRequest.sharedInstance.fetchHotWords { (result, status) -> Void in
            if status == RetCode.SUCCESS {
                if let data = result {
                    self.hotwordData = data
                    self.recordTableView.reloadData()
                }
            }
        }
    }
    
    // 点击搜索之后调用保存方法
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text != "" {
            saveRecord(searchBar.text!)
        }
    }
    
    ///  搜索栏结束编辑
    ///
    ///  - parameter searchBar: 搜索栏
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        NSUserDefaults.standardUserDefaults().setObject(recordData, forKey: "recordData")
    }
    
    ///  搜索栏文字改变时调用的方法
    ///
    ///  - parameter searchBar:  搜索栏
    ///  - parameter searchText: 搜索栏文本
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        recordTableView.hidden = true
        
        if searchBar.text == "" { // 48 × 51
            recordTableView.hidden = false
            recordTableView.reloadData()
        } else {
            locationButton.hidden = true
        }
    }
    
    // MARK: - tableview 数据源及代理方法
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return hotwordData.count == 0 ? 1 : 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? recordData.count : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(SearchViewContant.recordCellId, forIndexPath: indexPath) as! SearchRecordTableViewCell
            cell.textLabel?.text = recordData[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(SearchViewContant.hotwordCellId, forIndexPath: indexPath) as! SearchHotwordTableViewCell
            addSearchHotwordButtonAction(cell)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return recordTitleView
        } else {
            return hotWordLabel
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 46 : 100
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        view.endEditing(true)
        if indexPath.section != 1 {
            searchBar.text = recordData[indexPath.row]
            
            tableView.hidden = true
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    // MARK: - 删除历史记录方法
    func deleteButtonAction() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("recordData")
        recordData.removeAll()
        recordTableView.reloadData()
    }
    
    func addSearchHotwordButtonAction(cell: UITableViewCell) {
        let btnWidth:CGFloat  = UIScreen.mainScreen().bounds.width / 5
        let btnHeight:CGFloat = 20
        let totalCol:Int      = 5
        let totalRow:Int      = 5
        let marginX:CGFloat   = (UIScreen.mainScreen().bounds.size.width - btnWidth * CGFloat(totalCol)) / CGFloat(totalCol + 1) + 9
        let yOffset:CGFloat   = 14
        let marginY:CGFloat   = 26
        
        for (var i = 0; i < hotwordData.count; i++) {
            let btn = UIButton(title: hotwordData[i], fontSize: 16, radius: 0)
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            cell.addSubview(btn)
            
            btn.addTarget(self, action: "searchHotwordButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            let row:Int = i / totalCol
            let col:Int = i % totalCol
            
            if row >= totalRow {
                break
            }
            
            let btnX:CGFloat = marginX + (marginX + btnWidth) * CGFloat(col)
            let btnY:CGFloat = yOffset + (marginY + btnHeight) * CGFloat(row)
            btn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight)
        }
        
    }
    
    func searchHotwordButtonAction(btn: UIButton) {
        view.endEditing(true)
        searchBar.text = btn.titleLabel?.text ?? ""
        recordTableView.hidden = true
    }
    
    func showSearchResultController(vc: UIViewController) {
        //采用push可手势返回
        parentViewController?.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     设置无搜索结果
     - parameter isNoResult:
     */
    func showNoResult(show: Bool = true) {
        noSearchResultLabel.hidden = !show
    }
    
    /**
     保存搜索历史纪录
     - parameter filterString: query
     */
    func saveRecord(filterString: String) {
        if filterString == "" {
            return
        }
        
        if let index = recordData.indexOf(filterString) {
            recordData.removeAtIndex(index)
        }
        
        recordData.insert(filterString, atIndex: 0)
        if recordData.count > SearchViewContant.recordLimit {
            recordData.removeLast()
        }
    }
    
    // MARK: - 地理定位代理方法
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /// 只定位一次
        locationManager.stopUpdatingLocation()
        if currentCityId == "" {
            currentCityId = "-1"
        }
        
        // 获取位置信息
        let coordinate = locations.first?.coordinate
        // 反地理编码
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) -> Void in
            if let locality = placemarks?.first?.locality {
                struct Static {
                    static var onceToken: dispatch_once_t = 0
                }
                dispatch_once(&Static.onceToken, {
                    LocateToCity.locate(locality, handler: { (result, status) -> Void in
                        if status == RetCode.SUCCESS {
                            currentCityId = result as? String ?? "0"
                            if result != nil {
                                let vcity = CityViewController()
                                vcity.cityDataSource = City(id: currentCityId)
                                self?.searchResultViewController.showSearchResultController(vcity)
                            }
                        } else {
                            ProgressHUD.showSuccessHUD(self?.view, text: "网络连接失败，请检查网络")
                        }
                    })
                })
            }
        }
    }
}