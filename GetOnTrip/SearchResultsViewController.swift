//
//  SearchBaseViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/5.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

public let SearchContentKeyWordType: String = "keyword"
public let SearchContentTopicType  : String = "topic"
public let SearchContentBookType   : String = "book"
public let SearchContentVideoType   : String = "video"

class SearchResultsViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    var resultData = [String : AnyObject]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    /// 搜索更多内容
    var contentData = [SearchContent]()
    /// 搜索更多城市
    var resultMuchData  = [SearchResult]()
    
    var sectionTitle = [String]()
    
    var titleMap = ["sight":"景点", "city":"城市", "content":"内容"]
        
    var page    : String = "1"
    
    let pageSize: String = "4"
    
    var cityId = ""
    
    var scrollLock:Bool = false
    
    var tableView = UITableView()
    
    var pageNum = 1
    
    var cityNum = 1
    
    var citySightType: Int?
    
    var recordLoadButton: UIButton?
    
    var filterString: String = "" {
        didSet {

            if self.filterString == "" {
                self.resultData.removeAll()
                self.contentData.removeAll()
                self.resultMuchData.removeAll()
                pageNum = 1
                cityNum = 1
                self.tableView.reloadData()
                SearchViewController.searchVC.searchResultLabel.hidden = true
                return
            }
            
            SearchResultsRequest.sharedSearchResultRection.fetchSearchResultsModels(page, pageSize: pageSize, filterString: filterString) { (rows) -> Void in
                if self.filterString != "" {
                    self.resultData = rows as! [String : AnyObject]
                    if (rows["content_num"]??.intValue == 0) && (rows["city_num"]??.intValue == 0) && (rows["sight_num"]??.intValue == 0) {
                        SearchViewController.searchVC.searchResultLabel.hidden = false
                    }
                }
            }
        }
    }
    
    //MARK: View Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddProperty()
        setupAutoLayout()
    }

    private func setupAddProperty() {
        
        view.addSubview(tableView)
//        view.addSubview()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.separatorColor  = UIColor.grayColor()
        tableView.rowHeight = 60
        tableView.separatorStyle = .None
        tableView.backgroundView = UIImageView(image: UIImage(named: "search-bg0")!)
        tableView.registerClass(SearchResultsCell.self, forCellReuseIdentifier: "SearchResults_Cell")
        tableView.registerClass(ShowMoreTableViewCell.self, forCellReuseIdentifier: "ShowMoreTableView_Cell")
    }
    

    
    private func setupAutoLayout() {
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        tableView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height), offset: CGPointMake(0, 0))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if contentData.count != 0 || resultMuchData.count != 0 { return 1 }
        return resultData.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if contentData.count != 0 || resultMuchData.count != 0 { return "" }
        switch section {
        case 0:
            if resultData["searchCitys"]!.count == 0 { return "" }
            return "城市"
        case 1:
            if resultData["searchSights"]!.count == 0 { return "" }
            return "景点"
        case 2:
            if resultData["searchContent"]!.count == 0 { return "" }
            return "内容"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /// 保存搜索记录
        let sc = parentViewController as! SearchViewController

        if filterString != sc.recordData.first {
            sc.recordData.insert(filterString, atIndex: 0)
            if sc.recordData.count >= 6 {
                sc.recordData.removeLast()
            }
        }
        
        
        if resultMuchData.count != 0 {
            let data = resultMuchData[indexPath.row]
            if citySightType == 0 {
                
                let vc = CityViewController()
                let city = City(id: data.id)
                vc.cityDataSource = city
                showSearchResultController(vc)
                return
                
            } else {
                let vc = SightViewController()
                let sight = Sight(id: data.id)
                sight.name = data.name
                vc.sightDataSource = sight
                showSearchResultController(vc)
                return
            }
        }

        if contentData.count != 0 {
            let content = contentData[indexPath.row]
            if content.search_type == SearchContentKeyWordType || content.search_type == SearchContentVideoType {
                let vc = DetailWebViewController()
                vc.url = content.url
                showSearchResultController(vc)

                return
            } else if content.search_type == SearchContentTopicType {
                let vc = TopicViewController()
                let topic = Topic()
                topic.id       = content.id
                topic.image    = content.image
                topic.title    = content.title
                vc.topicDataSource = topic
                showSearchResultController(vc)
                return
            } else if content.search_type ==  SearchContentBookType {
                let vc = BookViewController()
                vc.bookId = content.id
                showSearchResultController(vc)

                return
            }
            return
        }
    

        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0:
            let data = resultData["searchCitys"] as! [SearchResult]
            if data.count == indexPath.row { return }
        case 1:
            let data = resultData["searchSights"] as! [SearchResult]
            if data.count == indexPath.row { return }
        case 2:
            let Contentdata = resultData["searchContent"] as! [SearchContent]
            if Contentdata.count == indexPath.row { return }
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if let searchCity = resultData["searchCitys"] {
                let vc = CityViewController()
                let searchC = searchCity[indexPath.row] as! SearchResult
                let city = City(id: searchC.id)
                city.name = searchC.name
                city.image = searchC.image
                vc.cityDataSource = city
                showSearchResultController(vc)
            }
        case 1:
            if let searchSight = resultData["searchSights"] {
                
                let vc = SightViewController()
                let searchC = searchSight[indexPath.row] as! SearchResult
                let sight = Sight(id: searchC.id)
                sight.name = searchC.name
                sight.image = searchC.image
                vc.sightDataSource = sight
                showSearchResultController(vc)
            }
        default:
            if let searchContent = resultData["searchContent"] as? [SearchContent] {
                
                let searchType = searchContent[indexPath.row]
                if searchType.search_type == SearchContentKeyWordType || searchType.search_type == SearchContentVideoType {
                    let vc = DetailWebViewController()
                    vc.url = searchType.url
                    showSearchResultController(vc)
                } else if searchType.search_type == SearchContentTopicType {
                    let vc = TopicViewController()
                    let topic = Topic()
                    topic.id       = searchType.id
                    topic.image    = searchType.image
                    topic.title    = searchType.title
                    vc.topicDataSource = topic
                    showSearchResultController(vc)
                } else if searchType.search_type ==  SearchContentBookType {
                    let vc = BookViewController()
                    vc.bookId = searchType.id
                    showSearchResultController(vc)
                }
            }
            break
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clearColor()
        
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.lightGrayColor()
        headerView.textLabel!.font = UIFont.systemFontOfSize(11)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if contentData.count != 0 { return contentData.count }
        if resultMuchData.count != 0 { return resultMuchData.count }
        switch section {
        case 0:
            let num = resultData["city_num"]?.intValue
                let resultCount = (resultData["searchCitys"]!.count)!
                if Int(num!) <= resultCount {
                    return resultCount
                } else {
                    return resultCount + 1
                }
            
        case 1:
             let num = resultData["sight_num"]?.intValue
                let resultCount = (resultData["searchSights"]!.count)!
                if Int(num!) <= resultCount {
                    return resultCount
                } else {
                    return resultCount + 1
            }
            
        case 2:
             let num = resultData["content_num"]?.intValue
                let resultCount = (resultData["searchContent"]!.count)!
                if Int(num!) <= resultCount {
                    return resultCount
                } else {
                    return resultCount + 1
            }
            
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if resultMuchData.count != 0 {
            let muchCell = tableView.dequeueReusableCellWithIdentifier("SearchResults_Cell", forIndexPath: indexPath) as! SearchResultsCell
            muchCell.searchCruxCharacter = filterString
            muchCell.searchResult = resultMuchData[indexPath.row]
            if resultMuchData.count - 1 == indexPath.row {
                if cityNum != -1 {
                    cityNum++
                    loadMoreAction(recordLoadButton!)
                }
            }
            return muchCell
        }
        
        if contentData.count != 0 {
            let muchCell = tableView.dequeueReusableCellWithIdentifier("SearchResults_Cell", forIndexPath: indexPath) as! SearchResultsCell
            muchCell.searchCruxCharacter = filterString
            muchCell.searchContent = contentData[indexPath.row]
            if contentData.count - 1 == indexPath.row {
                
                if pageNum != -1 {
                    pageNum++
                    loadMoreAction(recordLoadButton!)
                }
            }
            return muchCell
        }

        switch indexPath.section {
        case 0:
            let data = resultData["searchCitys"]! as! [SearchResult]
            if data.count == indexPath.row {
                let cellMore = tableView.dequeueReusableCellWithIdentifier("ShowMoreTableView_Cell", forIndexPath: indexPath) as! ShowMoreTableViewCell
                cellMore.showMore.addTarget(self, action: "loadMoreAction:", forControlEvents: UIControlEvents.TouchUpInside)
                cellMore.showMore.setTitle("显示全部城市", forState: UIControlState.Normal)
                cellMore.showMore.tag = 2
                return cellMore
            }
        case 1:
            let data = resultData["searchSights"] as! [SearchResult]
            if data.count == indexPath.row {
                let cellMore = tableView.dequeueReusableCellWithIdentifier("ShowMoreTableView_Cell", forIndexPath: indexPath) as! ShowMoreTableViewCell
                cellMore.showMore.addTarget(self, action: "loadMoreAction:", forControlEvents: UIControlEvents.TouchUpInside)
                cellMore.showMore.setTitle("显示全部景点", forState: UIControlState.Normal)
                cellMore.showMore.tag = 1
                return cellMore
            }
        case 2:
            let Contentdata = resultData["searchContent"] as! [SearchContent]
            if Contentdata.count == indexPath.row {
                let cellMore = tableView.dequeueReusableCellWithIdentifier("ShowMoreTableView_Cell", forIndexPath: indexPath) as! ShowMoreTableViewCell
                cellMore.showMore.addTarget(self, action: "loadMoreAction:", forControlEvents: UIControlEvents.TouchUpInside)
                cellMore.showMore.setTitle("显示全部内容", forState: UIControlState.Normal)
                cellMore.showMore.tag = 3
                return cellMore
            }
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResults_Cell", forIndexPath: indexPath) as! SearchResultsCell
        cell.searchCruxCharacter = filterString
        switch indexPath.section {
        case 0:
            let data = resultData["searchCitys"] as! [SearchResult]
            cell.searchResult = data[indexPath.row]
        case 1:
            let data = resultData["searchSights"] as! [SearchResult]
            cell.searchResult = data[indexPath.row]
        case 2:
            let Contentdata = resultData["searchContent"] as! [SearchContent]

            let ContentType = Contentdata[indexPath.row]
                cell.searchContent = ContentType
        default:
            break
        }

        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //Apperance of cell
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        let vc = parentViewController as? SearchViewController
        vc?.searchBar.endEditing(true)
    }
    
    // MARK: UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {

        if !searchController.active { return }
        
        filterString = searchController.searchBar.text!
        
        if searchController.searchBar.text != "" {
            SearchViewController.searchVC.locationCity.hidden = true
        } else {
            SearchViewController.searchVC.locationCity.hidden = false
        }
    }
    
    // MARK: 自定义方法
    
    func showSearchResultController(vc: UIViewController) {
        //采用push可手势返回
        parentViewController?.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadMoreAction(btn: UIButton) {
        recordLoadButton = btn
        SearchMoreRequest.fetchMoreResult(btn.tag, page: pageNum, pageSize: 15, query: filterString) { (result) -> Void in
            let data = result["data"] as! [String : AnyObject]
            
            if btn.tag == 1 || btn.tag == 2 {
                self.citySightType = btn.tag
                for item in data ["data"] as! [[String : AnyObject]] {
                    self.resultMuchData.append(SearchResult(dict: item))
                }
                if let pageN = data["num"]?.intValue {
                    if Int(pageN / 15) <= self.cityNum {
                        self.cityNum = -1
                    }
                }
            } else {
                for item in data["data"] as! [[String : AnyObject]] {
                    self.contentData.append(SearchContent(dict: item))
                }
                if let pageN = data["num"]?.intValue {
                    if Int(pageN / 15) <= self.pageNum {
                        self.pageNum = -1
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
}
