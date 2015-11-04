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
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/search", post: post) { (result, error) -> () in
            if error == nil {
                let data = result!["data"]
                var rows = [String : AnyObject]()
                for section in self.sectionTypes {
                    switch section {
                    case "city":
                        var searchCitys = [SearchResult]()
                        for item in data!!["city"] as! NSArray {
                            searchCitys.append(SearchResult(dict: item as! [String : String]))
                        }
                        rows["searchCitys"] = searchCitys
                        rows["city_num"]    = data!!["city_num"]
                    case "sight":
                        var searchSights = [SearchResult]()
                        for item in data!!["sight"] as! NSArray {
                            searchSights.append(SearchResult(dict: item as! [String : String]))
                        }
                        rows["searchSights"] = searchSights
                        rows["sight_num"]    = data!!["sight_num"]
                    case "content":
                        var searchContent = [SearchContent]()
                        
                        for item in data!!["content"] as! NSArray {
                            searchContent.append(SearchContent(dict: item as! [String : AnyObject]))
                        }
                        rows["searchContent"] = searchContent
                        rows["content_num"]    = data!!["content_num"]
                    default:
                        break
                    }
                }
                handler(rows)

            }
        }
    }
}



// MARK: - 模型
/// 搜索城市
class SearchResult: NSObject {
    
    var id: String = ""
    
    var name: String = ""
    
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 52, height: 38)
        }
    }
    
    var desc: String = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

/// 搜索内容
class SearchContent: NSObject {
    
    var search_type: String = ""
    
    var id: String = ""
    
    var title: String = ""
    
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 52, height: 38)
        }
    }
    
    var content: String = ""
    
    var url: String = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}