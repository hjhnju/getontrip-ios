//
//  SightBooksRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/19.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SightBooksRequest: NSObject {
    
    /**
    * 接口1：/api/book
    * 书籍列表接口
    * @param integer page
    * @param integer pageSize
    * @param integer sightId,景点ID
    * @return json
    */
    
    // 请求参数
    var sightId :String = ""
    var page    :Int = 1
    var pageSize:Int = 10
    
    // 将数据回调外界
    func fetchNextPageModels(handler: ([Book]?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: ([Book]?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: ([Book]?, Int) -> Void) {
        var post         = [String: String]()
        post["sightId"]  = sightId
        post["page"]     = String(self.page)
        post["pageSize"] = String(self.pageSize)
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/sight/book", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var sightBook = [Book]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        sightBook.append(Book(dict: item))
                    }
                }
                handler(sightBook, status)
                return
            }
            handler(nil, status)
        }
    }
}
