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
    static let Sight    :Int = 1
    static let City     :Int = 2
    static let Content  :Int = 3
    static let Book     :Int = 5
    static let Video    :Int = 6
    static let Landscape:Int = 7
}

class SearchAllRequest: NSObject {
    
    static let sharedInstance = SearchAllRequest()
    
    var vc: SearchResultsViewController?
    
    var pageSize: Int = 6
//    var searchType: Int = SearchType.Content
    /// 城市页数
    var cityPage: Int = 1
    /// 景点页数
    var sightPage:Int = 1
    /// 内容页数
    var contentPage:Int = 1
    /// 景观页数
    var landscapePage:Int = 1
    /// 书籍页数
    var bookPage:Int = 1
    /// 视频页数
    var videoPage:Int = 1
    
    /// 纪录有无更多数据
    var hasMoreData: Bool = true // 未使用
    
    var isLoadData: Bool = false
    
    /// 还原默认数据
    func restoreDefaultData() {
        cityPage = 1
        sightPage = 1
        contentPage = 1
        landscapePage = 1
        bookPage = 1
        videoPage = 1
    }
    
    func fetchNextPageModels(filter: String, searchType: Int, handler: (JSON?, Int) -> Void) {
        
        var page: Int = 0
        switch searchType {
        case 2:
            cityPage = cityPage + 1
            page = cityPage
        case 1:
            sightPage = sightPage + 1
            page = sightPage
        case 3:
            contentPage = contentPage + 1
            page = contentPage
        case 7:
            landscapePage = landscapePage + 1
            page = landscapePage
        case 5:
            bookPage = bookPage + 1
            page = bookPage
        case 6:
            videoPage = videoPage + 1
            page = videoPage
        default:
            break
        }
        
        if isLoadData == true { return }
        isLoadData = true
        return fetchModels(searchType, page: page, pageSize: pageSize, query: filter, handler: handler)
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
            self.isLoadData = false
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
