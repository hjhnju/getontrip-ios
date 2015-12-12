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
    
    /// 是否重设搜索框
    var isSearchFrame:Bool = false
    
    var searchBarY: CGFloat?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        searchResultsUpdater = searchResultViewController
    }
    
    init() {
        super.init(searchResultsController: searchResultViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        searchBar.delegate = self
        initLocationManager()
        initProperty()
        initTableView()
        loadHotSearchLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 35)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isSearchFrame == true {
            searchBar.frame = CGRectMake(49, searchBarY ?? 18, UIScreen.mainScreen().bounds.width - 49, 35)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for item in view.subviews {
            if item.isKindOfClass(NSClassFromString("_UISearchBarContainerView")!) {
                item.frame = CGRectMake(0, 20, UIScreen.mainScreen().bounds.width, 62)
            }
        }
    }
    
    /// 初始化view
    private func initView() {
        searchBar.delegate = self
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
//            searchResultViewController.tableView.hidden = false
//            searchResultViewController.filterString = searchBar.text ?? ""
        }
    }
    
    /// 点击取消调用的方法
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        isSearchFrame = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 删除按钮方法
    func clearButtonAction() {
        searchBar.text = ""
        searchBar(searchBar, textDidChange: "")
    }
}