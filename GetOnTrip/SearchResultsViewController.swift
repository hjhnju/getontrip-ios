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

class SearchResultsViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    /// 第一次搜索结果数据源
    var resultDataSource = [String : AnyObject]() {
        didSet {
            updateNoResultHint()
        }
    }
    
    /// 结果字段名
    var sectionFileds    = ["searchCitys", "searchSights", "searchContent", "searchLandscape", "searchBook", "searchVideo"]
    var sectionNumFileds = ["city_num", "sight_num", "content_num", "landscape_num", "book_num", "video_num"]
    var sectionTitles = ["城市", "景点", "内容","景观", "书籍", "视频"]
//    var sectionTypes  = [SearchType.City, SearchType.Sight, SearchType.Content]
    
    /// 是否在“显示全部内容”界面
    var isSearchingAll: Bool = false
    
    /// 显示全部内容的搜索类型
    var searchType: Int = SearchType.Content
    
    var dataSource: SearchInitData = SearchInitData()
    
    /// 搜索更多内容数据
//    var contentData = [SearchContentResult]() {
//        didSet {
//            updateNoResultHint()
//        }
//    }
//    
//    /// 搜索更多城市或者景点数据
//    var normalData  = [SearchResult]() {
//        didSet {
//            updateNoResultHint()
//        }
//    }
    
    var cityId = ""
    
    var tableView = UITableView()
    
    var filterString: String = "" {
        didSet {
            if filterString == "" {
                isSearchingAll = false
                resultDataSource.removeAll()
//                contentData.removeAll()
//                normalData.removeAll()
                tableView.reloadData()
                //不显示无内容
                if let searvc = parentViewController as? SearchViewController {
                    searvc.showNoResult(false)
                }
                return
            }
            /// 当搜索之后，发送第一次网络请求数据
            requestFisterSearchData()
//            requestSearching()
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
        tableView.separatorStyle  = .None
        tableView.backgroundColor = .clearColor()
        tableView.rowHeight       = SearchResultContant.NormalCellHeight
        tableView.sectionHeaderHeight = SearchResultContant.SectionHeaderHeight
        tableView.registerClass(SearchResultsCell.self, forCellReuseIdentifier: "SearchResultsCell")
    }
    
    private func setupAutoLayout() {
        tableView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - 64 - 28), offset: CGPointMake(0, 64 + 28))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: UITableViewDataSource
    var refreshRows = -1
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        print(refreshRows)
//        if refreshRows != -1 { return refreshRows }
        
//        if refreshRows != -1 {
            return dataSource.groupNum
//        } else {
//            return 1
//        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /// 保存搜索记录
        if let svc = parentViewController as? SearchViewController {
            svc.saveRecord(filterString)
        }
        
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        
//        if isSearchingAll {
//            if self.searchType == SearchType.City || self.searchType == SearchType.Sight {
//                let rowData = normalData[indexPath.row]
//                selectNormalCellAction(rowData)
//                return
//            } else if self.searchType == SearchType.Content {
//                let content = contentData[indexPath.row]
//                selectContentCellAction(content)
//                return
//            }
//        } else {
//            if let data = resultDataSource[sectionFileds[indexPath.section]] as? [SearchResult] {
//                //点击查看更多
//                if data.count == indexPath.row {
//                    return
//                }
//                searchType = sectionTypes[indexPath.section]
//                let rowData = data[indexPath.row]
//                selectNormalCellAction(rowData)
//            }
//            if let data = resultDataSource[sectionFileds[indexPath.section]] as? [SearchContentResult] {
//                if data.count == indexPath.row {
//                    return
//                }
//                let rowData = data[indexPath.row]
//                selectContentCellAction(rowData)
//            }
//        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getTableViewHeaderViewWith(section)
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.sectionNum[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultsCell", forIndexPath: indexPath) as! SearchResultsCell
        cell.searchCruxCharacter = filterString
        cell.dataSource = getTableViewCellData(indexPath)
        
        if dataSource.sectionTag != -1 {
            if indexPath.section == dataSource.sectionTag {
                if indexPath.row == dataSource.sectionNum[indexPath.section] - 1 {
                    requestMoreSearchingAll()
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
    
    func updateNoResultHint() {
        let searvc = parentViewController as? SearchViewController
        if resultDataSource.count == 0 {
            searvc?.showNoResult()
        } else {
            searvc?.showNoResult(false)
        }
    }
    
    func showSearchResultController(vc: UIViewController) {
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
//        if content.isLandscape() || content.isVideo() {
//            let vc = DetailWebViewController()
//            vc.url = content.url
//            showSearchResultController(vc)
//        } else if content.isTopic() {
//            let vc = TopicViewController()
//            let topic = Topic()
//            topic.id       = content.id
//            topic.image    = content.image
//            topic.title    = content.title
//            vc.topicDataSource = topic
//            showSearchResultController(vc)
//        } else if content.isBook() {
//            let vc = BookViewController()
//            let book = Book(id: content.id)
//            book.image = content.image
//            book.title = content.title
//            vc.bookDataSource = book
//            showSearchResultController(vc)
//        }
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
//        } else if searchType == SearchType.Landscape {
//            let vc = DetailWebViewController()
//            vc.url = rowData
        }
    }
    
    /**
    发送首次搜索请求
    */
    func requestFisterSearchData() {
        SearchRequest.sharedInstance.fetchFirstPageModels(filterString) { (rows, status) -> Void in
            if status == RetCode.SUCCESS {
                self.dataSource = rows
                self.tableView.reloadData()
            } else {
                ProgressHUD.showErrorHUD(self.view, text: "网络连接失败")
            }
        }
    }
    
    
    func requestSearching() {
//        if isSearchingAll {
//            SearchAllRequest.sharedInstance.vc = self
//            SearchAllRequest.sharedInstance.searchType = searchType
//            SearchAllRequest.sharedInstance.fetchFirstPageModels(filterString) { (result, status: Int) -> Void in
////                if status == RetCode.SUCCESS {
////                    //更新DataSource
////                    if self.searchType == SearchType.City || self.searchType == SearchType.Sight {
////                        var newNormalData = [SearchResult]()
////                        for item in result?.arrayValue ?? [] {
////                            if let item = item.dictionaryObject {
////                                newNormalData.append(SearchResult(dict: item))
////                            }
////                        }
//////                        self.normalData = newNormalData
////                    } else {
////                        var newContentData = [SearchContentResult]()
////                        for item in result?.arrayValue ?? [] {
////                            if let item = item.dictionaryObject {
////                                newContentData.append(SearchContentResult(dict: item))
////                            }
////                        }
//////                        self.contentData = newContentData
////                    }
////                    
////                    //设置无内容
////                    if self.normalData.count == 0 && self.contentData.count == 0 {
////                        if let searvc = self.parentViewController as? SearchViewController {
////                            searvc.showNoResult()
////                        }
////                    }
////                    self.tableView.reloadData()
////                } else {
////                    ProgressHUD.showErrorHUD(self.view, text: "网络连接失败")
////                }
//            }
//        } else {
//            SearchRequest.sharedInstance.fetchFirstPageModels(filterString) { (rows, status) -> Void in
//                if status == RetCode.SUCCESS {
//                    
//                    self.dataSource = rows
//                    self.tableView.reloadData()
//                    
////                    if (rows["content_num"]?.intValue == 0) && (rows["city_num"]?.intValue == 0) && (rows["sight_num"]?.intValue == 0) {
////                        if let searvc = self.parentViewController as? SearchViewController {
////                            searvc.showNoResult()
////                        }
////                    }
//                } else {
//                    ProgressHUD.showErrorHUD(self.view, text: "网络连接失败")
//                }
//            }
//        }
    }
    
    /**
    搜索全部内容的下一页数据
    */
    func requestMoreSearchingAll() {
//        if !isSearchingAll {
//            return
//        }
        
        SearchAllRequest.sharedInstance.fetchNextPageModels(filterString, searchType: dataSource.sectionTag) { [weak self] (result, status) -> Void in
            if status == RetCode.SUCCESS {
//                for item in result?.arrayValue ?? [] {
                
                    var i = self?.getDataSourceSectionObject().count ?? 0
                    var indexPath = [NSIndexPath]()
                    for _ in i...(result?.arrayValue.count ?? i) {
                        indexPath.append(NSIndexPath(forRow: i, inSection: self?.dataSource.sectionTag ?? 0))
                        if let dict = result?.dictionaryObject {
                            switch self?.dataSource.sectionTag ?? 0 {
                            case 0 :
                                self?.dataSource.searchCitys.append(SearchContentResult(dict: dict))
                            case 1:
                                self?.dataSource.searchSights.append(SearchContentResult(dict: dict))
                            case 2:
                                self?.dataSource.searchContent.append(SearchContentResult(dict: dict))
                            case 3:
                                self?.dataSource.searchLandscape.append(SearchContentResult(dict: dict))
                            case 4:
                                self?.dataSource.searchBook.append(SearchContentResult(dict: dict))
                            case 5:
                                self?.dataSource.searchVideo.append(SearchContentResult(dict: dict))
                            default:
                                break
                            }
                        }
                        i++
                    }
                    self?.tableView.insertRowsAtIndexPaths(indexPath, withRowAnimation: .Fade)
//                }
            }
        }
//        SearchAllRequest.sharedInstance.fetchNextPageModels(filterString) { (result, status: Int) -> Void in
//            if status == RetCode.SUCCESS {
//                if self.searchType == SearchType.City || self.searchType == SearchType.Sight {
//                    for item in result?.arrayValue ?? [] {
//                        if let item = item.dictionaryObject {
//                            self.normalData.append(SearchResult(dict: item))
//                        }
//                    }
//                } else {
//                    for item in result?.arrayValue ?? [] {
//                        if let item = item.dictionaryObject {
//                            self.contentData.append(SearchContentResult(dict: item))
//                        }
//                    }
//                }
//                self.tableView.reloadData()
//            }
//        }
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
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if searchController.searchBar.text != "" {
            filterString = searchController.searchBar.text ?? ""
        }
    }
    
    /// 组标题方法
    func groupTitleWithText(text: String, allHidden: Bool, group: Int) -> UIView {
        let groupTitle = GroupTitleView()
        groupTitle.recordLabel.text = text
        groupTitle.recordDelButton.setTitle("展开全部", forState: UIControlState.Normal)
        groupTitle.recordDelButton.addTarget(self, action: "refreshGroupContentAction:", forControlEvents: .TouchUpInside)
        groupTitle.recordDelButton.tag = group
        groupTitle.recordDelButton.hidden = allHidden
        return groupTitle
    }
    
    private func getTableViewHeaderViewWith(section: Int) -> UIView {
        
        let text = dataSource.groupTitleName[section]
        switch section {
        case 0 :
            return groupTitleWithText(text, allHidden: dataSource.city_num > 3 ? false : true, group: section)
        case 1:
            return groupTitleWithText(text, allHidden: dataSource.sight_num > 3 ? false : true, group: section)
        case 2:
            return groupTitleWithText(text, allHidden: dataSource.content_num > 3 ? false : true, group: section)
        case 3:
            return groupTitleWithText(text, allHidden: dataSource.landscape_num > 3 ? false : true, group: section)
        case 4:
            return groupTitleWithText(text, allHidden: dataSource.book_num > 3 ? false : true, group: section)
        case 5:
            return groupTitleWithText(text, allHidden: dataSource.video_num > 3 ? false : true, group: section)
        default:
            break
        }
        return UIView()
    }
    
    private func getTableViewCellData(indexPath: NSIndexPath) -> SearchContentResult {
        
        switch indexPath.section {
        case 0 :
            return dataSource.searchCitys[indexPath.row]
        case 1:
            return dataSource.searchSights[indexPath.row]
        case 2:
            return dataSource.searchContent[indexPath.row]
        case 3:
            return dataSource.searchLandscape[indexPath.row]
        case 4:
            return dataSource.searchBook[indexPath.row]
        case 5:
            return dataSource.searchVideo[indexPath.row]
        default:
            break
        }
        return SearchContentResult(dict: [String : AnyObject]())
    }
    
    /// 刷新对应组方法
    func refreshGroupContentAction(btn: UIButton) {
        
        dataSource.sectionTag = btn.tag
        
        
        
//        var indexPath = [NSIndexPath]()
//        let indexPath1 = NSIndexPath(forRow: 1, inSection: 3)
//        indexPath.append(indexPath1)
//        let indexPath2 = NSIndexPath(forRow: 1, inSection: 3)
//        indexPath.append(indexPath2)
//        self.tableView.beginUpdates()
//        print(indexPath)
//        self.tableView.reloadRowsAtIndexPaths(indexPath, withRowAnimation: UITableViewRowAnimation.Automatic)
//        self.tableView.endUpdates()
        
//        if insertData == nil { return }
        
//        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:currentTask.taskList.count];
//        NSInteger currentItem = self.taskList.count;
//        for (NSInteger i = currentItem; i < currentTask.taskList.count + currentItem ; ++i) {
//            NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
//            [arrayM addObject:path];
//        }
//        [self.taskList addObjectsFromArray:currentTask.taskList];
//        [self.tableView insertRowsAtIndexPaths:arrayM withRowAnimation:UITableViewRowAnimationFade];
        
//        var indexPath = [NSIndexPath]()
        tableView.reloadSections(NSIndexSet(index: btn.tag), withRowAnimation: UITableViewRowAnimation.Fade)
        
//        tableView.reloadSections(NSIndexSet(index: btn.tag), withRowAnimation: UITableViewRowAnimation.Fade)
//        print(indexPath)
//        tableView.beginUpdates()
        
//        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
        
//        let indexPathForRemoval = NSIndexPath(forRow: 3, inSection: 0)
//        tableView.deleteRowsAtIndexPaths([indexPathForRemoval], withRowAnimation: .Fade)
//        
//        let insertedIndexPathRange = 0..<1
//        
//        let insertedIndexPaths = insertedIndexPathRange.map { NSIndexPath(forRow: $0, inSection: 0) }
//        
//        tableView.insertRowsAtIndexPaths(insertedIndexPaths, withRowAnimation: .Fade)
        
//        tableView.endUpdates()
    }
    
    
}
