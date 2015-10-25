//
//  SearchResultsModel.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SearchResultsRequest: NSObject {
    
    static let sharedSearchResultRection = SearchResultsRequest()
    
    var sectionTypes = ["city", "sight", "content"]
    
    ///  搜索方法
    ///
    ///  - parameter page:         页面
    ///  - parameter pageSize:     页面大小
    ///  - parameter filterString: 搜索内容
    ///  - parameter handler:      回调
    func fetchSearchResultsModels(page: String, pageSize: String, filterString: String, handler: AnyObject -> Void) {
        
        var post         = [String: String]()
        post["query"]    = String(filterString)
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/search", post: post, handler: {(respData: AnyObject) -> Void in
            print(respData)
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
            handler(rows)
        })
    
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
    
    var id: String = ""
    
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
    
    var url: String?
    
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
    
    var url: String?
    
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