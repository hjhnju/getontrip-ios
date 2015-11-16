//
//  SearchMoreRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/27.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import SwiftyJSON

struct SearchType {
    static let Sight:Int = 1
    static let City:Int  = 2
    static let Content:Int = 3
}

class SearchAllRequest: NSObject {
    
    static let sharedInstance = SearchAllRequest()
    
    var vc: SearchResultsViewController?
    
    var page    : Int = 0
    var pageSize: Int = 15
    var searchType: Int = SearchType.Content
    
    /// 纪录有无更多数据
    var hasMoreData: Bool = true
    
    func fetchNextPageModels(filter: String, handler: (JSON?, Int) -> Void) {
        if !hasMoreData {
            return
        }
        page = page + 1
        return fetchModels(self.searchType, page: page, pageSize: pageSize, query: filter, handler: handler)
    }
    
    func fetchFirstPageModels(filter: String, handler: (JSON?, Int) -> Void) {
        page = 1
        hasMoreData = true
        return fetchModels(self.searchType, page: page, pageSize: pageSize, query: filter, handler: handler)
    }
    
    ///  搜索更多
    ///
    ///  - parameter type:     搜索类型 1:景点,2:城市,3:内容
    ///  - parameter page:     页
    ///  - parameter pageSize: 页面大小
    ///  - parameter query:    查询词
    ///  - parameter handler:  回调数据
    private func fetchModels(type: Int, page: Int, pageSize: Int, query: String, handler: (result: JSON?, status: Int) -> Void) {
        
        var post      = [String: String]()
        post["type"]  = String(type)
        post["page"]  = String(page)
        post["query"] = String(query)
        post["pageSize"] = String(pageSize)
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/search", post: post) { (data, status) -> () in
            if status == RetCode.SUCCESS {
                if data.arrayValue.count == 0 {
                    self.hasMoreData = false
                }
                handler(result: data, status: status)
                return
            } else {
                handler(result: nil, status: status)
            }
        }
        
    }
}
