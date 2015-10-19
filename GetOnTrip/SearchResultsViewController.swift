//
//  SearchBaseViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/5.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit



class SearchResultsViewController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: Properties
    
    var resultData = NSMutableDictionary()
    
    var sectionTitle = [String]()
    
    var titleMap = ["sight":"景点", "city":"城市", "content":"内容"]
    
    var sectionTypes = ["city", "sight", "content"]
    
    var page    : Int = 1
    var pageSize: Int = 6
    
    var scrollLock:Bool = false
    
    var filterString: String? {
        didSet {
            if let query = filterString {
                if query.isEmpty {
                    return
                }
//                self.resultData.removeAll(keepCapacity: true)
//                self.sectionTitle.removeAll(keepCapacity: true)
                var post       = [String: String]()
                post["query"]  = String(query)
                post["page"]   = String(page)
                post["pageSize"] = String(pageSize)
                HttpRequest.ajax(AppIni.BaseUri, path: "/api/search", post: post, handler: {(respData: AnyObject) -> Void in
                    
                    let rows = NSMutableDictionary()
                    for section in self.sectionTypes {
                        
                        switch section {
                        case "city":
                            var searchCitys = [SearchCity]()
                            for item in respData["city"] as! NSArray {
                                searchCitys.append(SearchCity(dict: item as! [String : String]))
                            }
                            rows.setValue(searchCitys, forKey: "searchCitys")
                        case "sight":
                            var searchSights = [SearchSight]()
                            for item in respData["sight"] as! NSArray {
                                searchSights.append(SearchSight(dict: item as! [String : String]))
                            }
                            rows.setValue(searchSights, forKey: "searchSights")

                        case "content":
                           let searchContent = NSMutableArray()
                           
                           let content = respData["content"] as? NSDictionary
                           
                           for item in content?.objectForKey("topic") as! NSArray {
                            searchContent.addObject(SearchContentTopic(dict: item as! [String : AnyObject]))
                           }
                           
                           for item in content?.objectForKey("book") as! NSArray {
                            searchContent.addObject(SearchContentBook(dict: item as! [String : AnyObject]))
                           }
                           
                           for item in content?.objectForKey("video") as! NSArray {
                            searchContent.addObject(SearchContentVideo(dict: item as! [String : AnyObject]))
                           }
                           
                           for item in content?.objectForKey("wiki") as! NSArray {
                            searchContent.addObject(SearchContentWiki(dict: item as! [String : AnyObject]))
                           }
                            
                        rows.setValue(searchContent, forKey: "searchContent")

                        default:
                            break
                        }
                    }
                    self.resultData = rows 
                    self.tableView.reloadData()
                })
                
            }
        }
    }
    
    //MARK: View Life Circle
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.separatorColor  = UIColor.grayColor()
        tableView.rowHeight = 60
        tableView.backgroundView = UIImageView(image: UIImage(named: "search-bg0")!)
        tableView.registerClass(SearchResultsCell.self, forCellReuseIdentifier: "SearchResults_Cell")
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return resultData.count
    }
    
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            if resultData.objectForKey("searchCitys")?.count == 0 { return "" }
            return "城市"
        case 1:
            if resultData.objectForKey("searchSights")?.count == 0 { return "" }
            return "景点"
        default:
            if resultData.objectForKey("searchContent")?.count == 0 { return "" }
            return "内容"
        }
        
    }
    
    
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clearColor()
        let frame = CGRectMake(0, view.frame.size.height-1, view.frame.width, 0.5)
        let line  = UIView(frame: frame)
        line.backgroundColor = UIColor.grayColor()
        view.addSubview(line)
        
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.lightGrayColor()
        headerView.textLabel!.font = UIFont(name: "Helvetica Neue", size: 11)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return (resultData.objectForKey("searchCitys")?.count)!
        case 1:
            return (resultData.objectForKey("searchSights")?.count)!
        default:
            return (resultData.objectForKey("searchContent")?.count)!
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResults_Cell", forIndexPath: indexPath) as! SearchResultsCell
        
        
        switch indexPath.section {
        case 0:
            let data = resultData.objectForKey("searchCitys") as! [SearchCity]
            cell.searchCity = data[indexPath.row]
        case 1:
            let data = resultData.objectForKey("searchSights") as! [SearchSight]
            cell.searchSight = data[indexPath.row]
        case 2:
            let Contentdata = resultData.objectForKey("searchContent") as! NSArray

            let ContentType = Contentdata[indexPath.row]
            if ContentType.isKindOfClass(NSClassFromString("GetOnTrip.SearchContentTopic")!) {
                cell.searchContentTopic = ContentType as? SearchContentTopic
            } else if (ContentType.isKindOfClass(NSClassFromString("GetOnTrip.SearchContentBook")!)) {
                cell.searchContentBook = ContentType as? SearchContentBook
            } else if (ContentType.isKindOfClass(NSClassFromString("GetOnTrip.SearchContentVideo")!)) {
                cell.searchContentVideo = ContentType as? SearchContentVideo
            } else {
                cell.searchContentWiki = ContentType as? SearchContentWiki
            }

        default:
            break
        }

        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let searchResultsCell = cell as! SearchResultsCell
        //Apperance of cell
        searchResultsCell.separatorInset = UIEdgeInsetsZero
        searchResultsCell.preservesSuperviewLayoutMargins = false
        searchResultsCell.layoutMargins = UIEdgeInsetsZero
        searchResultsCell.backgroundColor = UIColor.clearColor()
        
//        searchResultsCell.resultTitleLabel.textColor = UIColor.whiteColor()
//        searchResultsCell.resultDescLabel.textColor = UIColor.lightGrayColor()
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // updateSearchResultsForSearchController(_:) is called when the controller is being dismissed to allow those who are using the controller they are search as the results controller a chance to reset their state. No need to update anything if we're being dismissed.
        if !searchController.active {
            return
        }
        
        filterString = searchController.searchBar.text
    }
}

// MARK: - 模型
class SearchCity: NSObject {
    
    var id: String?
    
    var name: String?
    
    var image: String? {
        didSet {
            image = AppIni.BaseUri + image!
        }
    }
    
    var desc: String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

class SearchSight: NSObject {
    
    var id: String?
    
    var name: String?
    
    var image: String? {
        didSet {
            image = AppIni.BaseUri + image!
        }
    }
    
    var desc: String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}


class SearchContentTopic: NSObject {
    
    var id: String?
    
    var title: String?
    
    var image: String? {
        didSet {
            image = AppIni.BaseUri + image!
        }
    }
    
    var subtitle: String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}


class SearchContentBook: NSObject {
    
    var id: String?
    
    var title: String?
    
    var image: String? {
        didSet {
            image = AppIni.BaseUri + image!
        }
    }
    
    var desc: String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}


class SearchContentVideo: NSObject {
    
    var id: String?
    
    var title: String?
    
    var image: String? {
        didSet {
            image = AppIni.BaseUri + image!
        }
    }
    
    var from: String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

class SearchContentWiki: NSObject {
    
    var id: String?
    
    var name: String?
    
    var image: String? {
        didSet {
            image = AppIni.BaseUri + image!
        }
    }
    
    var desc: String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}