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

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    /// 搜索展示结果控制器
    let searchResultViewController =  SearchResultsViewController()
    
    lazy var searchBar: SearchBar = SearchBar(frame: CGRectMake(0, 0, Frame.screen.width, 35))
    
    /// 搜索记录TableView
    let recordTableView = UITableView()
    
    /// 搜索记录(不可重复，按最近搜索排序）
    var recordData = [String]()
    
    /// 热门搜索词
    var hotwordData = [String]()
    
    /// 搜索提示
    var noSearchResultLabel: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "暂无搜索结果", fontSize: 14, mutiLines: true, fontName: Font.PingFangSCLight)
    
    /// 定位城市
    var locationButton: UIButton = UIButton(image: "location_search", title: " 即刻定位当前城市", fontSize: 12, titleColor: UIColor.whiteColor(), fontName: Font.PingFangSCLight)
    
    //位置管理器
    lazy var locationManager: CLLocationManager = CLLocationManager()
    
    /// 是否重设搜索框
    var isSearchFrame:Bool = false
    
    var searchBarFrame: CGRect = CGRectZero
    
    var searchBarH: CGFloat?
    
    var searchBarContainerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchBar.textFile.delegate = self
        searchBar.superController = self
        view.addSubview(searchBar)
        searchBar.frame = CGRectMake(0, 0, Frame.screen.width, 35)
//        searchBar.hidden = true
        initView()
//        searchBar.delegate = self
        initProperty()
        initTableView()
        loadHotSearchLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        isCancle = false

//        searchBar.ff_AlignInner(.TopLeft, referView: searchBar.superview ?? searchBar, size: CGSizeMake(Frame.screen.width - 18, 35))
//        searchBar.backgroundColor = UIColor.randomColor()
//        let vc = presentingViewController as? RecommendViewController
//        vc?.searchBarMaxX?.constant = 9
//        vc?.searchBarTopY?.constant = 50
//        vc?.searchBarW?.constant    = Frame.screen.width - 18
//        vc?.searchBarH?.constant    = 35
//        
//        UIView.animateWithDuration(0.5) { () -> Void in
////            vc?.searchController.searchBar.layoutIfNeeded()
////            vc?.textfile?.frame = CGRectMake(0, 0, Frame.screen.width, 35)
//        }
        recordTableView.hidden = true
        searchResultViewController.view.hidden = true
        
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        refreshSearchBarContaineView()
        
        
       
    }
    
    /// 初始化view
    private func initView() {
        let imageV = UIImageView(image: UIImage(named: "search-bg")!)
        addChildViewController(searchResultViewController)
        automaticallyAdjustsScrollViewInsets = false
        imageV.frame = UIScreen.mainScreen().bounds
        if let userDefault = NSUserDefaults.standardUserDefaults().valueForKey("recordData") as? [String] {
            recordData = userDefault
        }
        
        view.addSubview(imageV)
        view.addSubview(searchResultViewController.view)
        view.addSubview(recordTableView)
        view.addSubview(locationButton)
        view.addSubview(noSearchResultLabel)
    }
    
    /// 初始化tableView
    private func initTableView() {
        recordTableView.backgroundColor = UIColor.clearColor()
        recordTableView.delegate   = self
        recordTableView.dataSource = self
        recordTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        recordTableView.registerClass(SearchHeaderView.self, forHeaderFooterViewReuseIdentifier: "SearchHeaderView")
        recordTableView.registerClass(SearchRecordTableViewCell.self, forCellReuseIdentifier: SearchViewContant.recordCellId)
        recordTableView.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, UIScreen.mainScreen().bounds.height - 110), offset: CGPointMake(0, -2))
    }
    
    /// 初始化相关属性
    private func initProperty() {
        locationButton.ff_AlignInner(.TopCenter, referView: view, size: nil, offset: CGPointMake(0, 93))
        noSearchResultLabel.ff_AlignVertical(.BottomCenter, referView: locationButton, size: nil, offset: CGPointMake(0, 141))
        recordTableView.registerClass(SearchHotwordTableViewCell.self, forCellReuseIdentifier: SearchViewContant.hotwordCellId)
        locationButton.addTarget(self, action: "switchCurrentCity:", forControlEvents: UIControlEvents.TouchUpInside)
        noSearchResultLabel.hidden = true
    }
    
    // MARK: - 加载热门搜索
    private func loadHotSearchLabel() {
        SearchRequest.sharedInstance.fetchHotWords { [weak self] (result, status) -> Void in
            if status == RetCode.SUCCESS {
                if let data = result {
                    self?.hotwordData = data
                    self?.recordTableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - searchBar 代理方法
    // 点击搜索之后调用保存方法
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text != "" {
            saveRecord(searchBar.text ?? "")
        }
    }
    
    ///  搜索栏结束编辑
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        NSUserDefaults.standardUserDefaults().setObject(recordData, forKey: "recordData")
        let vc = presentingViewController as? RecommendViewController
        if isCancle == true {
            searchBar.text = ""
            recordTableView.hidden = false
//            vc?.defaultPrompt.titleLabel?.hidden = false
            return
        }
    }
    
    ///  搜索栏文字改变时调用的方法
    var isCancle:Bool = false
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        recordTableView.hidden = true
        let vc = presentingViewController as? RecommendViewController
        
        if searchBar.text == "" { // 48 × 51
//            vc?.defaultPrompt.titleLabel?.hidden = false
            recordTableView.hidden = false
            locationButton.hidden = false
            recordTableView.reloadData()
            searchResultViewController.view.hidden = true
        } else {
//            vc?.defaultPrompt.titleLabel?.hidden = true
            locationButton.hidden = true
            recordTableView.hidden = true
            searchResultViewController.view.hidden = false
        }
    }
    
    /// 点击取消调用的方法
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        isCancle = true
        isSearchFrame = true
        searchResultViewController.filterString = ""
        searchResultViewController.view.hidden = true
        recordTableView.hidden = false
        locationButton.hidden = false
        searchBarTextDidEndEditing(searchBar)
        dismissViewControllerAnimated(true) { [weak self] () -> Void in
            self?.searchResultViewController.dataSource = SearchInitData()
            SearchAllRequest.sharedInstance.restoreDefaultData()
            self?.searchResultViewController.filterString = ""
            self?.searchResultViewController.lastSearchContent = ""
        }
    }
    
    /// 删除按钮方法
    func clearButtonAction() {
        searchResultViewController.filterString = ""
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        updateSearchBarDefaultFrame()
        UIView.animateWithDuration(0.5) { [weak self] () -> Void in
            self?.view.alpha = 1.0
            self?.searchBar.layoutIfNeeded()
        }
        
        return true
    }
    
    func updateSearchBarDefaultFrame() {
        let vc = parentViewController as? RecommendViewController
        searchBarTX = vc?.searchBarMaxX?.constant ?? 0
        searchBarTY = vc?.searchBarTopY?.constant ?? 0
        searchBarTW = vc?.searchBarW?.constant ?? 0
        searchBarTH = vc?.searchBarH?.constant ?? 0
        vc?.searchBarMaxX?.constant = 0
        vc?.searchBarTopY?.constant = 36
        vc?.searchBarW?.constant    = Frame.screen.width
        vc?.searchBarH?.constant    = 35
        searchBar.updateWidthFrame(Frame.screen.width - 18)
    }
    
    /// 临时记录改变前的值
    var searchBarTX: CGFloat = 0
    var searchBarTY: CGFloat = 0
    var searchBarTW: CGFloat = 0
    var searchBarTH: CGFloat = 0
    
    func modificationSearchBarFrame() {
        let vc = parentViewController as? RecommendViewController
        vc?.searchBarMaxX?.constant = searchBarTX
        vc?.searchBarTopY?.constant = searchBarTY
        vc?.searchBarW?.constant    = searchBarTW
        vc?.searchBarH?.constant    = searchBarTH
        searchBar.updateWidthFrame(Frame.screen.width - 128)
    }
}