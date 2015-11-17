//
//  SearchResultsModel.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SearchRequest: NSObject {
    
    static let sharedInstance = SearchRequest()
    
    var sectionTypes = ["city", "sight", "content"]
    
    var page    : Int = 1
    var pageSize: Int = 4
    
    func fetchNextPageModels(filter: String, handler: ([String : AnyObject], Int) -> Void) {
        page = page + 1
        return fetchModels(String(page), pageSize: String(pageSize), filterString: filter, handler: handler)
    }
    
    func fetchFirstPageModels(filter: String, handler: ([String : AnyObject], Int) -> Void) {
        page = 1
        return fetchModels(String(page), pageSize: String(pageSize), filterString: filter, handler: handler)
    }
    
    ///  搜索方法
    ///
    ///  - parameter page:         页面
    ///  - parameter pageSize:     页面大小
    ///  - parameter filterString: 搜索内容
    ///  - parameter handler:      回调
    func fetchModels(page: String, pageSize: String, filterString: String, handler: ([String : AnyObject], Int) -> Void) {
        if filterString == "" {
            return
        }
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
                        if let citys = data["city"]?.arrayValue {
                            for item in citys {
                                if let item = item.dictionaryObject {
                                    searchCitys.append(SearchResult(dict: item))
                                }
                            }
                        }
                        let num = data["city_num"]?.intValue ?? 0
                        //if num > 0 {
                            rows["searchCitys"]    = searchCitys
                            rows["city_num"] = num
                        //}
                    case "sight":
                        var searchSights = [SearchResult]()
                        if let sights = data["sight"]?.arrayValue {
                            for item in sights {
                                if let item = item.dictionaryObject {
                                    searchSights.append(SearchResult(dict: item))
                                }
                            }
                        }
                        rows["searchSights"] = searchSights
                        rows["sight_num"]    = data["sight_num"]?.stringValue
                    case "content":
                        var searchContent = [SearchContentResult]()
                        if let cons = data["content"]?.arrayValue {
                            for item in cons {
                                if let item = item.dictionaryObject {
                                    searchContent.append(SearchContentResult(dict: item))
                                }
                            }
                        }
                        rows["searchContent"] = searchContent
                        rows["content_num"]   = data["content_num"]?.stringValue
                    default:
                        break
                    }
                }
                handler(rows, status)
            
            }
        }
    }
    
    /**
    * 接口3：/api/search/hotWord
    * 热门搜索词接口
    * @param integer size,条数，默认是10
    */
    func fetchHotWords(handler: ([String]?, Int) -> Void){
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/search/hotWord", post: [String: String]()) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var data = [String]()
                for it in result.arrayValue {
                    data.append(it.stringValue)
                }
                handler(data, status)
                return
            }
            handler(nil, status)
        }
    }
}