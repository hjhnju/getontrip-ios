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
    static let NormalCellHeight:CGFloat     = 64
    static let SectionHeaderHeight: CGFloat = 38
}

class SearchResultsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    /// 结果字段名
    var sectionFileds    = ["searchCitys", "searchSights", "searchContent", "searchLandscape", "searchBook", "searchVideo"]

    /// 显示全部内容的搜索类型
    var searchType = ContentType.city
    
    var dataSource = SearchInitData()
    
    var cityId = ""
    
    var tableView = UITableView()
    
    var lastSearchContent: String = ""
    
    var filterString: String = "" {
        didSet {
            if filterString == lastSearchContent { return }

            dataSource = SearchInitData()
            SearchAllRequest.sharedInstance.restoreDefaultData()
            tableView.reloadData()
            if let searvc = parentViewController as? SearchViewController {
                searvc.showNoResult(false)
            }
            
            /// 当搜索之后，发送第一次网络请求数据
            requestFisterSearchData()
            lastSearchContent = filterString
        }
    }
    
    //MARK: View Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }

    private func initView() {
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.separatorColor  = UIColor.grayColor()
        tableView.separatorStyle  = .None
        tableView.backgroundColor = .clearColor()
        tableView.rowHeight       = SearchResultContant.NormalCellHeight
        tableView.sectionHeaderHeight = SearchResultContant.SectionHeaderHeight
        tableView.registerClass(SearchResultsCell.self, forCellReuseIdentifier: "SearchResultsCell")
        tableView.registerClass(SearchHeaderView.self, forHeaderFooterViewReuseIdentifier: "SearchResultsViewController")
        tableView.clipsToBounds = true
        tableView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - 64 - 28), offset: CGPointMake(0, 90))
    }
    
    // MARK: UITableViewDataSource
    var refreshRows = -1

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /// 保存搜索记录
        if let svc = parentViewController as? SearchViewController {
            svc.saveRecord(filterString)
            svc.recordTableView.reloadData()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let data = getTableViewCellData(indexPath)
        
        switch data.search_type{
        case ContentType.city:
            searchType = ContentType.city
        case ContentType.sight:
            searchType = ContentType.sight
        case ContentType.Topic:
            searchType = ContentType.Topic
        case ContentType.Landscape:
            searchType = ContentType.Landscape
        case ContentType.Book:
            searchType = ContentType.Book
        case ContentType.Video:
            searchType = ContentType.Video
        default:
            return
        }
        selectNormalCellAction(data)
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getTableViewHeaderViewWith(section)
    }
    
    /// 共有几组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.typeCount.count
    }

    /// 每组有多少个
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = dataSource.typeCount[section].values.first ?? 0
        if count > 3 {
            return dataSource.iSunfold[section] ? count : 3
        } else {
            return count ?? 0
        }
    }
    
    /// 每个是什么
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultsCell", forIndexPath: indexPath) as! SearchResultsCell
        cell.searchCruxCharacter = filterString
        cell.dataSource = getTableViewCellData(indexPath)
        cell.section = indexPath.section
        
            if dataSource.sectionTag != -1 {
                if dataSource.iSunfold[dataSource.sectionTag] {
                    if indexPath.section == dataSource.sectionTag {
                        let index = dataSource.typeCount[indexPath.section].values.first ?? 0
                        if indexPath.row == index - 1 {
                            requestMoreSearchingAll(indexPath.section)
                        }
                    }
                }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //Apperance of cell
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        let vc = parentViewController as? SearchViewController
        vc?.searchBar.endEditing(true)
    }
    
    // MARK: 自定义方法
    
    func selectNormalCellAction(rowData: SearchContentResult) {
        
        switch searchType {
        case ContentType.city:
            let vc = CityViewController()
            let sight: Sight = Sight(id: "")
            sight.cityid = rowData.id
            sight.name = rowData.title ?? ""
            vc.sightDataSource = sight
            showSearchResultController(vc)
        case ContentType.sight:
            let vc = SightViewController()
            let sight = Sight(id: rowData.id)
            sight.name = rowData.title
            vc.sightDataSource = sight
            showSearchResultController(vc)
        case ContentType.Topic:
            let vc = TopicViewController()
            let topic = Topic()
            topic.id       = rowData.id
            topic.image    = rowData.image
            topic.title    = rowData.title
            vc.topicDataSource = topic
            showSearchResultController(vc)
        case ContentType.Landscape:
            let vc = DetailWebViewController()
            vc.url = rowData.url
            showSearchResultController(vc)
        case ContentType.Book:
            let vc = BookViewController()
            let book = Book(id: rowData.id)
            book.image = rowData.image
            book.title = rowData.title
            vc.bookDataSource = book
            showSearchResultController(vc)
        case ContentType.Video:
            let vc = DetailWebViewController()
            vc.url = rowData.url
            let video = Video()
            video.id = rowData.id
            vc.video = video
            showSearchResultController(vc)
        default:
            break
        }
    }
    
    func showSearchResultController(vc: UIViewController) {
        parentViewController?.parentViewController?.navigationController?.pushViewController(vc, animated: true)
        (parentViewController as? SearchViewController)?.isRefreshSearchBar = false
        (parentViewController?.parentViewController as? RecommendViewController)?.isRefreshNavBar = false
    }
    
    /**
    发送首次搜索请求
    */
    func requestFisterSearchData() {
        SearchRequest.sharedInstance.fetchFirstPageModels(filterString) { [weak self] (rows, status) -> Void in
            if status == RetCode.SUCCESS {
                if rows.typeCount.count > 0 {
                    self?.dataSource = rows
                    self?.tableView.reloadData()
                } else {
                    self?.dataSource = SearchInitData()
                    SearchAllRequest.sharedInstance.restoreDefaultData()
                    self?.tableView.reloadData()
                    if let searvc = self?.parentViewController as? SearchViewController {
                        searvc.showNoResult(true)
                    }
                }
            } else {
                ProgressHUD.showErrorHUD(self?.view, text: "网络连接失败")
            }
        }
    }

    
    /**
    搜索全部内容的下一页数据
    */
    func requestMoreSearchingAll(section: Int) {

        let index = dataSource.typeCount[section].keys.first ?? ""
        var searchTypeTemp: Int = -1
        switch index {
        case ContentType.city :
            searchTypeTemp = 2
        case ContentType.sight:
            searchTypeTemp = 1
        case ContentType.Topic:
            searchTypeTemp = 3
        case ContentType.Landscape:
            searchTypeTemp = 7
        case ContentType.Book:
            searchTypeTemp = 5
        case ContentType.Video:
            searchTypeTemp = 6
        default:
            break
        }
        
        
        if searchTypeTemp == -1 { return }
        SearchAllRequest.sharedInstance.fetchNextPageModels(filterString, searchType: searchTypeTemp) { [weak self] (result, status) -> Void in

            if status == RetCode.SUCCESS {
                
                var i = self?.dataSource.typeCount[section].values.first ?? 0
                var indexPath = [NSIndexPath]()
                
                if result?.arrayValue.count == 0 { return }
                for item in result?.arrayValue ?? [] {
                    
                    if let dict = item.dictionaryObject {
                        indexPath.append(NSIndexPath(forRow: i, inSection: self?.dataSource.sectionTag ?? 0))
                        
                        let index = self!.dataSource.typeCount[self!.dataSource.sectionTag].keys.first ?? ""
                        
                        switch index {
                        case ContentType.city :
                            let data = SearchContentResult(dict: dict)
                            data.search_type = ContentType.city
                            self?.dataSource.searchCitys.append(data)
                            self?.dataSource.typeCount[self!.dataSource.sectionTag] = [ContentType.city : self!.dataSource.searchCitys.count]
                        case ContentType.sight:
                            let data = SearchContentResult(dict: dict)
                            data.search_type = ContentType.sight
                            self?.dataSource.searchSights.append(data)
                            self?.dataSource.typeCount[self!.dataSource.sectionTag] = [ContentType.sight : self!.dataSource.searchSights.count]
                        case ContentType.Topic:
                            let data = SearchContentResult(dict: dict)
                            data.search_type = ContentType.Topic
                            self?.dataSource.searchContent.append(data)
                            self?.dataSource.typeCount[self!.dataSource.sectionTag] = [ContentType.Topic : self!.dataSource.searchContent.count]
                        case ContentType.Landscape:
                            let data = SearchContentResult(dict: dict)
                            data.search_type = ContentType.Landscape
                            self?.dataSource.searchLandscape.append(data)
                            self?.dataSource.typeCount[self!.dataSource.sectionTag] = [ContentType.Landscape : self!.dataSource.searchLandscape.count]
                        case ContentType.Book:
                            let data = SearchContentResult(dict: dict)
                            data.search_type = ContentType.Book
                            self?.dataSource.searchBook.append(data)
                            self?.dataSource.typeCount[self!.dataSource.sectionTag] = [ContentType.Book : self!.dataSource.searchBook.count]
                        case ContentType.Video:
                            let data = SearchContentResult(dict: dict)
                            data.search_type = ContentType.Video
                            self?.dataSource.searchVideo.append(data)
                            self?.dataSource.typeCount[self!.dataSource.sectionTag] = [ContentType.Video : self!.dataSource.searchVideo.count]
                        default:
                            break
                        }
                    }
                    i += 1
                }
                if self!.dataSource.iSunfold[self!.dataSource.sectionTag] {
                    self?.tableView.insertRowsAtIndexPaths(indexPath, withRowAnimation: .None)
                }
            }
        }
    }
    
    /// 获取数据源组对象
    private func getDataSourceSectionObject() -> [SearchContentResult] {
        
        var insertData: [SearchContentResult]?
        switch dataSource.sectionTag {
        case 0 :
            insertData = dataSource.searchCitys
        case 1:
            insertData = dataSource.searchSights
        case 2:
            insertData = dataSource.searchContent
        case 3:
            insertData = dataSource.searchLandscape
        case 4:
            insertData = dataSource.searchBook
        case 5:
            insertData = dataSource.searchVideo
        default:
            insertData = [SearchContentResult]()
            break
        }
        return insertData!
    }
    
    /// 组标题方法
    func groupTitleWithText(text: String, allHidden: Bool, group: Int) -> SearchHeaderView {
        
        let groupTitle = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SearchResultsViewController") as! SearchHeaderView
        groupTitle.backgroundView?.alpha = 0.0
        groupTitle.recordLabel.text = text
        groupTitle.recordDelButton.setTitle(dataSource.iSunfold[group] ? "    收起" : "展开全部" , forState: .Normal)
        groupTitle.recordDelButton.addTarget(self, action: #selector(SearchResultsViewController.refreshGroupContentAction(_:)), forControlEvents: .TouchUpInside)
        groupTitle.recordDelButton.tag = group
        groupTitle.recordDelButton.hidden = allHidden
        return groupTitle
    }
    
    private func getTableViewHeaderViewWith(section: Int) -> SearchHeaderView {
        
        let text = dataSource.groupTitleName[section]
        let count = dataSource.typeCount[section].values.first ?? 0
        switch section {
        case 0 :
            return groupTitleWithText(text, allHidden: count > 3 ? false : true, group: section)
        case 1:
            return groupTitleWithText(text, allHidden: count > 3 ? false : true, group: section)
        case 2:
            return groupTitleWithText(text, allHidden: count > 3 ? false : true, group: section)
        case 3:
            return groupTitleWithText(text, allHidden: count > 3 ? false : true, group: section)
        case 4:
            return groupTitleWithText(text, allHidden: count > 3 ? false : true, group: section)
        case 5:
            return groupTitleWithText(text, allHidden: count > 3 ? false : true, group: section)
        default:
            break
        }
        return SearchHeaderView()
    }
    
    private func getTableViewCellData(indexPath: NSIndexPath) -> SearchContentResult {
        
        let index = dataSource.typeCount[indexPath.section].keys.first ?? ""
        switch index {
        case ContentType.city :
            return dataSource.searchCitys[indexPath.row]
        case ContentType.sight:
            return dataSource.searchSights[indexPath.row]
        case ContentType.Topic:
            return dataSource.searchContent[indexPath.row]
        case ContentType.Landscape:
            return dataSource.searchLandscape[indexPath.row]
        case ContentType.Book:
            return dataSource.searchBook[indexPath.row]
        case ContentType.Video:
            return dataSource.searchVideo[indexPath.row]
        default:
            break
        }
        return SearchContentResult(dict: [String : AnyObject]())
    }
    
    /// 刷新对应组方法
    func refreshGroupContentAction(btn: UIButton) {
        dataSource.sectionTag = btn.tag
        dataSource.iSunfold[btn.tag] = !dataSource.iSunfold[btn.tag]
        tableView.reloadSections(NSIndexSet(index: btn.tag), withRowAnimation: .Fade)
        scrollViewDidScroll(self.tableView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let hv1 = tableView.headerViewForSection(1) as? SearchHeaderView
        hv1?.backgroundView?.alpha = 0
        let hv2 = tableView.headerViewForSection(2) as? SearchHeaderView
        hv2?.backgroundView?.alpha = 0
        let hv3 = tableView.headerViewForSection(3) as? SearchHeaderView
        hv3?.backgroundView?.alpha = 0
        let hv4 = tableView.headerViewForSection(4) as? SearchHeaderView
        hv4?.backgroundView?.alpha = 0
        let hv5 = tableView.headerViewForSection(5) as? SearchHeaderView
        hv5?.backgroundView?.alpha = 0
        
        let cell = tableView.visibleCells.first as? SearchResultsCell
        let headerView = tableView.headerViewForSection(cell?.section ?? 0) as? SearchHeaderView
        headerView?.backgroundView?.alpha = 1
    }
}
