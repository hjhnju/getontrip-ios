//
//  SearchViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

struct SearchViewContant {
    static let hotwordCellId = "SearchHotwordTableViewCellID"
    static let recordCellId  = "SearchRecordTableViewCellID"
    
    static let recordLimit = 4
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    /// 搜索展示结果控制器
    let searchResultViewController =  SearchResultsViewController()
    
    lazy var searchBar: SearchBar = SearchBar(frame: CGRectMake(0, 0, Frame.screen.width, 35))
    
    /// 搜索记录TableView
    let recordTableView = UITableView()
    
    /// 搜索记录(不可重复，按最近搜索排序）
    var recordData = [String]()
    
    /// 热门搜索词
    var hotwordData = [String]()
    
    /// 是否刷新搜索
    var isRefreshSearchBar: Bool = true
    /// 是否已经进入搜索控制器
    var isEnterSearchController:Bool = false
    
    /// 搜索提示
    var noSearchResultLabel: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "暂无搜索结果", fontSize: 14, mutiLines: true, fontName: Font.PingFangSCLight)
    
    // TODO: 首页如果要定位，那这个就没啥意义了 定位城市
    var locationButton: UIButton = UIButton(image: "location_search", title: " 即刻定位当前城市", fontSize: 12, titleColor: UIColor.whiteColor(), fontName: Font.PingFangSCLight)
    
    var searchBarContainerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.textFile.delegate = self
        searchBar.superController = self
        view.addSubview(searchBar)
        searchBar.textFile.addTarget(self, action: "textfileValueChangedAction:", forControlEvents: .EditingChanged)
        searchBar.textFile.addTarget(self, action: "textEditingDidBegin:", forControlEvents: .EditingDidBegin)

        initView()
        initProperty()
        initTableView()
        loadHotSearchLabel()
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
    
    // MARK: - searchBar 中 textfiled 方法
    // 点击搜索之后调用保存方法
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text != "" {
            saveRecord(textField.text ?? "")
            recordTableView.reloadData()
        }
        searchBar.textFile.resignFirstResponder()
        return true
    }
    
    // 文本字段改变时需要调用搜索的方法
    func textfileValueChangedAction(textfiled: UITextField) {
        
        if let text = textfiled.text {
            if text != "" {
                recordTableView.hidden = true
                searchResultViewController.tableView.hidden = false
                searchResultViewController.filterString     = text
                searchBar.defaultPromptButton.titleLabel?.hidden = true
            } else {
                recordTableView.hidden = false
                searchResultViewController.tableView.hidden = true
                searchBar.defaultPromptButton.titleLabel?.hidden = false
            }
        }
    }
    
    ///  搜索栏结束编辑
    func textFieldDidEndEditing(textField: UITextField) {
        NSUserDefaults.standardUserDefaults().setObject(recordData, forKey: "recordData")
    }
    
    func textEditingDidBegin(textfiled: UITextField) {
        searchBar.clearTextButton.hidden = false
        if isRefreshSearchBar {
            searchBar.updateCancelButtonShow(true)
        }
    }
    
    /// 开始进入搜索控制器
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        isEnterSearchController = true
        openSearchControllerAction()
        (parentViewController as? RecommendViewController)?.isSlideMenu = false
        (parentViewController as? RecommendViewController)?.slideNavButton.hidden = true
        return true
    }
    
    /// 打开搜索控制器方法
    func openSearchControllerAction() {
        if isRefreshSearchBar {
            updateSearchBarDefaultFrame()
        }
        searchBar.deleteButton.hidden = isEnterSearchController ? false : true
        searchBar.defaultPromptButton.titleLabel?.hidden = searchBar.textFile.text == "" ? false : true
        UIView.animateWithDuration(0.5) { [weak self] () -> Void in
            self?.view.alpha = 1.0
            self?.searchBar.layoutIfNeeded()
        }
    }
    
    /// 删除按钮方法
    func clearButtonAction() {
        searchResultViewController.filterString = ""
    }
    
    func updateSearchBarDefaultFrame() {
        let vc = parentViewController as? RecommendViewController
        vc?.searchBarTX = vc?.searchBarMaxX?.constant ?? 0
        vc?.searchBarTY = vc?.searchBarTopY?.constant ?? 0
        vc?.searchBarTW = vc?.searchBarW?.constant ?? 0
        vc?.searchBarTH = vc?.searchBarH?.constant ?? 0
        vc?.searchBarMaxX?.constant = 0
        vc?.searchBarTopY?.constant = 36
        vc?.searchBarW?.constant    = Frame.screen.width
        vc?.searchBarH?.constant    = 35
        searchBar.updateWidthFrame(Frame.screen.width - 18)
    }
    
    /// 临时记录改变前的值
    func modificationSearchBarFrame() {
        let vc = parentViewController as? RecommendViewController
        vc?.searchBarMaxX?.constant = vc?.searchBarTX ?? 0
        vc?.searchBarTopY?.constant = vc?.searchBarTY ?? 0
        vc?.searchBarW?.constant    = vc?.searchBarTW ?? 0
        vc?.searchBarH?.constant    = vc?.searchBarTH ?? 0
    }
}