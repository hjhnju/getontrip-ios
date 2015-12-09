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
    
    /// 搜索展示结果控制器
    let searchResultViewController =  SearchResultsViewController()
    
    /// 搜索记录TableView
    let recordTableView = UITableView()
    
    /// 第一组标题
    var oneGroupTitleView: GroupTitleView = GroupTitleView()
    
    /// 第二组标题
    var twoGroupTitleView: GroupTitleView = GroupTitleView()
    
    /// 搜索记录(不可重复，按最近搜索排序）
    var recordData = [String]()
    
    /// 热门搜索词
    var hotwordData = [String]()
    
    /// 搜索提示
    var noSearchResultLabel: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "当前搜索无内容", fontSize: 14, mutiLines: true)
    
    /// 定位城市
    var locationButton: UIButton = UIButton(image: "location_search", title: " 即刻定位当前城市", fontSize: 12, titleColor: UIColor.whiteColor())
    
    //位置管理器
    lazy var locationManager: CLLocationManager = CLLocationManager()
    
    /// 搜索栏
    var textfile: UITextField? {
        didSet {
            if #available(iOS 9.0, *) {
                textfile?.font = UIFont(name: Font.defaultFont, size: 16)
            } else {
                textfile?.font = UIFont(name: ".HelveticaNeueInterface-Light", size: 16)
            }
            textfile?.textColor = UIColor.whiteColor()
            let leftView = UIImageView(image: UIImage(named: "search_icon"))
            textfile?.leftViewMode = .Always
            textfile?.leftView = leftView
            textfile?.rightView?.backgroundColor = UIColor.whiteColor()
            
            var font: UIFont?
            if #available(iOS 9.0, *) {
                font = UIFont(name: Font.defaultFont, size: 16)
            } else {
                font = UIFont(name: ".HelveticaNeueInterface-Light", size: 16)
            }
            textfile?.attributedPlaceholder = NSAttributedString(string: "搜索城市、景点等内容", attributes: [NSForegroundColorAttributeName: UIColor(hex: 0xFFFFFF, alpha: 0.3), NSFontAttributeName : font!])
        }
    }
    
    /// 初始化完毕就替换掉系统的searchbar
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(searchResultsController: searchResultViewController)
        let searchBar = SearchBar()
        setValue(searchBar, forKey: "searchBar")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initSearchBar()
        initLocationManager()
        initProperty()
        initTableView()
        loadHotSearchLabel()
    }
    
    /// 初始化view
    private func initView() {
        let imageV = UIImageView(image: UIImage(named: "search-bg")!)
        addChildViewController(searchResultViewController)
        automaticallyAdjustsScrollViewInsets = false
        hidesNavigationBarDuringPresentation = false
        imageV.frame = UIScreen.mainScreen().bounds
        if let userDefault = NSUserDefaults.standardUserDefaults().valueForKey("recordData") as? [String] {
            recordData = userDefault
        }
        oneGroupTitleView.recordDelButton.addTarget(self, action: "deleteButtonAction", forControlEvents: .TouchUpInside)
        twoGroupTitleView.recordLabel.text = "热门搜索"
        twoGroupTitleView.recordDelButton.removeFromSuperview()
        
        view.addSubview(imageV)
        view.addSubview(searchResultViewController.view)
        view.addSubview(recordTableView)
        view.addSubview(locationButton)
        view.addSubview(noSearchResultLabel)
    }
    
    /// 初始化searchBar
    private func initSearchBar() {
        searchBar.barStyle = UIBarStyle.Black
        searchBar.keyboardAppearance = UIKeyboardAppearance.Default
        searchBar.setSearchFieldBackgroundImage(UIImage(named: "search_box"), forState: .Normal)
        searchBar.tintColor = UIColor(hex: 0xFFFFFF, alpha: 0.5)
        searchBar.translucent = true
        searchBar.delegate = self
        
        for item in searchBar.subviews {
            for it in item.subviews {
                if it.isKindOfClass(NSClassFromString("UISearchBarBackground")!) {
                    it.frame = CGRectMake(0, 0, 100, 100)
                    it.removeFromSuperview()
                }
                if it.isKindOfClass(NSClassFromString("UISearchBarTextField")!) {
                    textfile = it as? UITextField
                }
            }
        }
    }
    
    /// 初始化定位
    private func initLocationManager() {
        // 应用程序使用期间允许定位
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    /// 初始化tableView
    private func initTableView() {
        recordTableView.backgroundColor = UIColor.clearColor()
        recordTableView.delegate   = self
        recordTableView.dataSource = self
        recordTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        recordTableView.registerClass(SearchRecordTableViewCell.self, forCellReuseIdentifier: SearchViewContant.recordCellId)
        recordTableView.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, UIScreen.mainScreen().bounds.height - 110), offset: CGPointMake(0, 0))
    }
    
    /// 初始化相关属性
    private func initProperty() {
        locationButton.ff_AlignInner(.TopCenter, referView: view, size: nil, offset: CGPointMake(0, 93))
        noSearchResultLabel.ff_AlignVertical(.BottomCenter, referView: locationButton, size: nil, offset: CGPointMake(0, 81))
        recordTableView.registerClass(SearchHotwordTableViewCell.self, forCellReuseIdentifier: SearchViewContant.hotwordCellId)
        locationButton.addTarget(self, action: "switchCurrentCity:", forControlEvents: UIControlEvents.TouchUpInside)
        noSearchResultLabel.hidden = true
    }
    
    // MARK: - 加载热门搜索
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
    
    // MARK: - searchBar 代理方法
    // 点击搜索之后调用保存方法
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text != "" {
            saveRecord(searchBar.text!)
        }
    }
    
    ///  搜索栏结束编辑
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        NSUserDefaults.standardUserDefaults().setObject(recordData, forKey: "recordData")
    }
    
    ///  搜索栏文字改变时调用的方法
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // if !active { return }
        recordTableView.hidden = true
        if searchBar.text == "" { // 48 × 51
            recordTableView.hidden = false
            recordTableView.reloadData()
            searchResultViewController.tableView.hidden = true
        } else {
            locationButton.hidden = true
            searchResultViewController.tableView.hidden = false
            searchResultViewController.filterString = searchBar.text ?? ""
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}