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
    
    /// 显示全部内容的搜索类型
    var searchType = ContentType.city
    
    var dataSource: SearchInitData = SearchInitData()
    
    var cityId = ""
    
    var tableView = UITableView()
    
    var filterString: String = "" {
        didSet {
            if filterString == "" {
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
        return dataSource.groupNum
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /// 保存搜索记录
        if let svc = parentViewController as? SearchViewController {
            svc.saveRecord(filterString)
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
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.sectionNum[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultsCell", forIndexPath: indexPath) as! SearchResultsCell
        cell.searchCruxCharacter = filterString
        cell.dataSource = getTableViewCellData(indexPath)
        
        if dataSource.sectionTag != -1 {
            if dataSource.iSunfold[dataSource.sectionTag] {
                if indexPath.section == dataSource.sectionTag {
                    if indexPath.row == dataSource.sectionNum[indexPath.section] - 1 {
                        requestMoreSearchingAll()
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
    
    func updateNoResultHint() {
        let searvc = parentViewController as? SearchViewController
        if resultDataSource.count == 0 {
            searvc?.showNoResult()
        } else {
            searvc?.showNoResult(false)
        }
    }
    
    func selectNormalCellAction(rowData: SearchContentResult) {
        
        
        switch searchType {
        case ContentType.city:
            let vc = CityViewController()
            let city = City(id: rowData.id)
            vc.cityDataSource = city
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
        parentViewController?.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
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

    
    /**
    搜索全部内容的下一页数据
    */
    func requestMoreSearchingAll() {
        
        var searchTypeTemp: Int = -1
        switch dataSource.sectionTag {
        case 0:
            searchTypeTemp = 2
        case 1:
            searchTypeTemp = 1
        case 2:
            searchTypeTemp = 3
        case 3:
            searchTypeTemp = 7
        case 4:
            searchTypeTemp = 5
        case 5:
            searchTypeTemp = 6
        default:
            break
        }
        if searchTypeTemp == -1 { return }
        
        SearchAllRequest.sharedInstance.fetchNextPageModels(filterString, searchType: searchTypeTemp) { [weak self] (result, status) -> Void in
            if status == RetCode.SUCCESS {
                print(result)
                var i = self?.getDataSourceSectionObject().count ?? 0
                var indexPath = [NSIndexPath]()
                var count: Int = 0
                if result?.arrayValue.count == 0 { return }
                for item in result?.arrayValue ?? [] {
                    
                    if let dict = item.dictionaryObject {
                        indexPath.append(NSIndexPath(forRow: i, inSection: self?.dataSource.sectionTag ?? 0))
                        switch self!.dataSource.sectionTag {
                        case 0 :
                            self?.dataSource.searchCitys.append(SearchContentResult(dict: dict))
                            count = self?.dataSource.searchCitys.count ?? 0
                        case 1:
                            self?.dataSource.searchSights.append(SearchContentResult(dict: dict))
                            count = self?.dataSource.searchSights.count ?? 0
                        case 2:
                            self?.dataSource.searchContent.append(SearchContentResult(dict: dict))
                            count = self?.dataSource.searchContent.count ?? 0
                        case 3:
                            self?.dataSource.searchLandscape.append(SearchContentResult(dict: dict))
                            count = self?.dataSource.searchLandscape.count ?? 0
                        case 4:
                            self?.dataSource.searchBook.append(SearchContentResult(dict: dict))
                            count = self?.dataSource.searchBook.count ?? 0
                        case 5:
                            self?.dataSource.searchVideo.append(SearchContentResult(dict: dict))
                            count = self?.dataSource.searchVideo.count ?? 0
                        default:
                            break
                        }
                    }
                    i++
                }
                self?.dataSource.sectionNum[self!.dataSource.sectionTag] = count
                self?.dataSource.sectionRowsCount[self!.dataSource.sectionTag] = count
                self?.tableView.insertRowsAtIndexPaths(indexPath, withRowAnimation: .Fade)
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
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if searchController.searchBar.text != "" {
            filterString = searchController.searchBar.text ?? ""
        }
    }
    
    /// 组标题方法
    func groupTitleWithText(text: String, allHidden: Bool, group: Int) -> UIView {
        let groupTitle = GroupTitleView()
        groupTitle.recordLabel.text = text
        groupTitle.recordDelButton.setTitle(dataSource.iSunfold[group] ? "收起" : "是否展开" , forState: UIControlState.Normal)
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
        dataSource.iSunfold[btn.tag] = !dataSource.iSunfold[btn.tag]
        tableView.reloadSections(NSIndexSet(index: btn.tag), withRowAnimation: UITableViewRowAnimation.Fade)
    }
}
