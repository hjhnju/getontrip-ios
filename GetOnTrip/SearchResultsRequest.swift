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
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/search", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {

                let data = result.dictionaryValue
                var rows = [String : AnyObject]()
                for section in self.sectionTypes {
                    switch section {
                    case "city":
                        var searchCitys = [SearchResult]()
                        for item in data["city"]!.arrayValue {
                            if let item = item.dictionaryObject {
                                searchCitys.append(SearchResult(dict: item))
                            }
                        }
                        rows["searchCitys"] = searchCitys
                        rows["city_num"]    = data["city_num"]?.stringValue
                    case "sight":
                        var searchSights = [SearchResult]()
                        for item in data["sight"]!.arrayValue {
                            if let item = item.dictionaryObject {
                                searchSights.append(SearchResult(dict: item))
                            }
                        }
                        rows["searchSights"] = searchSights
                        rows["sight_num"]    = data["sight_num"]?.stringValue
                    case "content":
                        var searchContent = [SearchContent]()
                        
                        for item in data["content"]!.arrayValue {
                            if let item = item.dictionaryObject {
                                searchContent.append(SearchContent(dict: item))
                            }
                        }
                        rows["searchContent"] = searchContent
                        rows["content_num"]    = data["content_num"]?.stringValue
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
        // book video keyword
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}