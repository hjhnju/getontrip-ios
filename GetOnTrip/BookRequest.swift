//
//  BookRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/19.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class BookRequest: NSObject {
    
    /**
    * 接口1：/api/book
    * 书籍详情接口
    * @param integer page
    * @param integer pageSize
    * @param integer sightId,景点ID
    * @return json
    */
    
    
    // 请求参数
    var sightId :String = ""
    var page    :Int = 1
    var pageSize:Int = 6
    
    // 将数据回调外界
    func fetchNextPageModels(handler: (NSArray?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: (NSArray?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: (NSArray?, Int) -> Void) {
        var post         = [String: String]()
        post["sightId"]  = sightId
        post["page"]     = String(self.page)
        post["pageSize"] = String(self.pageSize)
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/book", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var sightBook = [SightBook]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        sightBook.append(SightBook(dict: item))
                    }
                }
                handler(sightBook, status)
                return
            }
            handler(nil, status)
        }
    }
}

/// 景点列表Tags
class SightBook: NSObject {
    /// id
    var id: String?
    /// 标题
    var title: String?
    /// url
    var url: String?
    /// 图片
    var image: String? {
        didSet {
            image = AppIni.BaseUri + image!
        }
    }
    /// 内容
    var content_desc: String?
    /// 作者
    var author: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
    
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
