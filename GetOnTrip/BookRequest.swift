//
//  SightBookDetailRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/14.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class BookRequest: NSObject {
    
    /**
    * 接口2:/api/book/detail
    * 书籍详情接口
    * @param integer book,书籍ID
    * @return json
    */
    
    // 请求参数
    var book :String = ""
    
    // 将数据回调外界
    func fetchTopicDetailModels(handler: (BookDetail?, Int) -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: (BookDetail?, Int) -> Void) {
        var post         = [String: String]()
        post["book"]  = String(book)
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/book", post: post) { (result, status) -> Void in
            if status == RetCode.SUCCESS {
                handler(BookDetail(dict: result.dictionaryObject), status)
                return
            }
            handler(nil, status)
            
        }
    }
}

