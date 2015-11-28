//
//  SearchBaseViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/5.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

struct SearchResultContant {
    static let NormalCellHeight:CGFloat = 61
    static let BookCellHeight:CGFloat   = 70
}

class SearchResultsViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    /// 第一次搜索结果数据源
    var resultDataSource = [String : AnyObject]() {
        didSet {
            updateNoResultHint()
        }
    }
    
    /// 结果字段名
    var sectionFileds    = ["searchCitys", "searchSights", "searchContent"]
    var sectionNumFileds = ["city_num", "sight_num", "content_num"]
    var sectionTitles = ["城市", "景点", "内容"]
    var sectionTypes  = [SearchType.City, SearchType.Sight, SearchType.Content]
    
    /// 是否在“显示全部内容”界面
    var isSearchingAll: Bool = false
    
    /// 显示全部内容的搜索类型
    var searchType: Int = SearchType.Content
    
    /// 搜索更多内容数据
    var contentData = [SearchContentResult]() {
        didSet {
            updateNoResultHint()
        }
    }
    
    /// 搜索更多城市或者景点数据
    var normalData  = [SearchResult]() {
        didSet {
            updateNoResultHint()
        }
    }
    
    var cityId = ""
    
    var tableView = UITableView()
    
    var filterString: String = "" {
        didSet {
            if filterString == "" {
                isSearchingAll = false
                resultDataSource.removeAll()
                contentData.removeAll()
                normalData.removeAll()
                tableView.reloadData()
                //不显示无内容
                if let searvc = parentViewController as? SearchViewController {
                    searvc.showNoResult(false)
                }
                return
            }
            requestSearching()
        }
    }
    
    //MARK: View Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupAutoLayout()
    }

    private func initView() {
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.separatorColor  = UIColor.grayColor()
        tableView.rowHeight = SearchResultContant.NormalCellHeight
        tableView.separatorStyle = .None
        tableView.backgroundColor = .clearColor()
        tableView.registerClass(SearchResultsCell.self, forCellReuseIdentifier: "SearchResults_Cell")
        tableView.registerClass(ShowMoreTableViewCell.self, forCellReuseIdentifier: "ShowMoreTableView_Cell")
    }
    
    private func setupAutoLayout() {
        tableView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - 64 - 28), offset: CGPointMake(0, 64 + 28))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if isSearchingAll {
            return 1
        }
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title: String = ""
        if isSearchingAll {
            title = ""
        } else {
            let count = resultDataSource[sectionFileds[section]]?.count ?? 0
            if count == 0 {
                title =  ""
            } else {
                title = "   " + sectionTitles[section]
            }
        }
        return title
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerLabel: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "", fontSize: 12, mutiLines: true)
        
        if isSearchingAll {
            headerLabel.text = "   显示全部内容"
        } else {
            headerLabel.text = "   " + sectionTitles[section]
        }
        return headerLabel
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /// 保存搜索记录
        if let svc = parentViewController as? SearchViewController {
            svc.saveRecord(filterString)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if isSearchingAll {
            if self.searchType == SearchType.City || self.searchType == SearchType.Sight {
                let rowData = normalData[indexPath.row]
                selectNormalCellAction(rowData)
                return
            } else if self.searchType == SearchType.Content {
                let content = contentData[indexPath.row]
                selectContentCellAction(content)
                return
            }
        } else {
            if let data = resultDataSource[sectionFileds[indexPath.section]] as? [SearchResult] {
                //点击查看更多
                if data.count == indexPath.row {
                    return
                }
                searchType = sectionTypes[indexPath.section]
                let rowData = data[indexPath.row]
                selectNormalCellAction(rowData)
            }
            if let data = resultDataSource[sectionFileds[indexPath.section]] as? [SearchContentResult] {
                if data.count == indexPath.row {
                    return
                }
                let rowData = data[indexPath.row]
                selectContentCellAction(rowData)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearchingAll {
            if searchType == SearchType.City || searchType == SearchType.Sight {
                return normalData.count
            } else if searchType == SearchType.Content {
                return contentData.count
            }
        } else {
            let num = Int(resultDataSource[sectionNumFileds[section]]?.intValue ?? 0)
            let resultCount = Int(resultDataSource[sectionFileds[section]]?.count ?? 0)
            if num > resultCount {
                return resultCount + 1
            }
            return resultCount
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if isSearchingAll {
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchResults_Cell", forIndexPath: indexPath) as! SearchResultsCell
            cell.searchCruxCharacter = filterString
            if searchType == SearchType.City || searchType == SearchType.Sight {
                cell.searchResult = normalData[indexPath.row]
            } else if searchType == SearchType.Content {
                cell.searchContent = contentData[indexPath.row]
            }
            if contentData.count - 1 == indexPath.row {
                requestMoreSearchingAll()
            }
            return cell
        } else {
            /// 显示更多内容标签视图
            let sectionData = resultDataSource[sectionFileds[indexPath.section]]
            if sectionData?.count == indexPath.row {
                let cell = tableView.dequeueReusableCellWithIdentifier("ShowMoreTableView_Cell", forIndexPath: indexPath) as! ShowMoreTableViewCell
                cell.showMore.addTarget(self, action: "searchingAllAction:", forControlEvents: UIControlEvents.TouchUpInside)
                cell.showMore.setTitle("显示全部" + sectionTitles[indexPath.section], forState: UIControlState.Normal)
                searchType = sectionTypes[indexPath.section]
                return cell
            }
            
            /// 数据视图
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchResults_Cell", forIndexPath: indexPath) as! SearchResultsCell
            cell.searchCruxCharacter = filterString
            if let data = sectionData as? [SearchContentResult] {
                cell.searchContent = data[indexPath.row]
            }
            if let data = sectionData as? [SearchResult] {
                cell.searchResult  = data[indexPath.row]
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //Apperance of cell
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if contentData.count != 0 {
            if contentData[indexPath.row].search_type == "book" {
                return SearchResultContant.BookCellHeight
            }
        }
        return SearchResultContant.NormalCellHeight
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SearchResultContant.NormalCellHeight
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        let vc = parentViewController as? SearchViewController
        vc?.searchBar.endEditing(true)
    }
    
    // MARK: UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searvc = parentViewController as? SearchViewController
        if searchController.searchBar.text != "" {
            tableView.hidden = false
            searvc?.locationButton.hidden = true
        } else {
            tableView.hidden = true
            searvc?.locationButton.hidden = false
        }
        if !searchController.active { return }
        filterString = searchController.searchBar.text ?? ""
    }
    
    // MARK: 自定义方法
    
    func updateNoResultHint() {
        let searvc = parentViewController as? SearchViewController
        if resultDataSource.count == 0 {
            searvc?.showNoResult()
        } else {
            searvc?.showNoResult(false)
        }
    }
    
    func showSearchResultController(vc: UIViewController) {
        //采用push可手势返回
        parentViewController?.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
    响应“显示全部内容”
    - parameter btn: sender
    */
    func searchingAllAction(btn: UIButton) {
        //进入“显示全部内容”
        isSearchingAll = true
        requestSearching()
    }
    
    func selectContentCellAction(content: SearchContentResult) {
        if content.isLandscape() || content.isVideo() {
            let vc = DetailWebViewController()
            vc.url = content.url
            showSearchResultController(vc)
        } else if content.isTopic() {
            let vc = TopicViewController()
            let topic = Topic()
            topic.id       = content.id
            topic.image    = content.image
            topic.title    = content.title
            vc.topicDataSource = topic
            showSearchResultController(vc)
        } else if content.isBook() {
            let vc = BookViewController()
            let book = Book(id: content.id)
            book.image = content.image
            book.title = content.title
            vc.bookDataSource = book
            showSearchResultController(vc)
        }
    }
    
    func selectNormalCellAction(rowData: SearchResult) {
        if searchType == SearchType.City {
            let vc = CityViewController()
            let city = City(id: rowData.id)
            vc.cityDataSource = city
            showSearchResultController(vc)
        } else if searchType == SearchType.Sight {
            let vc = SightViewController()
            let sight = Sight(id: rowData.id)
            sight.name = rowData.name
            vc.sightDataSource = sight
            showSearchResultController(vc)
        }
    }
    
    /**
    发送首次搜索请求
    */
    func requestSearching() {
        if isSearchingAll {
            SearchAllRequest.sharedInstance.vc = self
            SearchAllRequest.sharedInstance.searchType = searchType
            SearchAllRequest.sharedInstance.fetchFirstPageModels(filterString) { (result, status: Int) -> Void in
                if status == RetCode.SUCCESS {
                    //更新DataSource
                    if self.searchType == SearchType.City || self.searchType == SearchType.Sight {
                        var newNormalData = [SearchResult]()
                        for item in result?.arrayValue ?? [] {
                            if let item = item.dictionaryObject {
                                newNormalData.append(SearchResult(dict: item))
                            }
                        }
                        self.normalData = newNormalData
                    } else {
                        var newContentData = [SearchContentResult]()
                        for item in result?.arrayValue ?? [] {
                            if let item = item.dictionaryObject {
                                newContentData.append(SearchContentResult(dict: item))
                            }
                        }
                        self.contentData = newContentData
                    }
                    
                    //设置无内容
                    if self.normalData.count == 0 && self.contentData.count == 0 {
                        if let searvc = self.parentViewController as? SearchViewController {
                            searvc.showNoResult()
                        }
                    }
                    self.tableView.reloadData()
                } else {
                    ProgressHUD.showErrorHUD(self.view, text: "网络连接失败")
                }
            }
        } else {
            SearchRequest.sharedInstance.fetchFirstPageModels(filterString) { (rows, status) -> Void in
                if status == RetCode.SUCCESS {
                    self.resultDataSource = rows
                    self.tableView.reloadData()
                    if (rows["content_num"]?.intValue == 0) && (rows["city_num"]?.intValue == 0) && (rows["sight_num"]?.intValue == 0) {
                        if let searvc = self.parentViewController as? SearchViewController {
                            searvc.showNoResult()
                        }
                    }
                } else {
                    ProgressHUD.showErrorHUD(self.view, text: "网络连接失败")
                }
            }
        }
    }
    
    /**
    搜索全部内容的下一页数据
    */
    func requestMoreSearchingAll() {
        if !isSearchingAll {
            return
        }
        SearchAllRequest.sharedInstance.fetchNextPageModels(filterString) { (result, status: Int) -> Void in
            if status == RetCode.SUCCESS {
                if self.searchType == SearchType.City || self.searchType == SearchType.Sight {
                    for item in result?.arrayValue ?? [] {
                        if let item = item.dictionaryObject {
                            self.normalData.append(SearchResult(dict: item))
                        }
                    }
                } else {
                    for item in result?.arrayValue ?? [] {
                        if let item = item.dictionaryObject {
                            self.contentData.append(SearchContentResult(dict: item))
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
}
