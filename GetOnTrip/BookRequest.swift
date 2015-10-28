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
    
    //    http://123.57.67.165:8301/api/sight/detail?tags
    // 将数据回调外界
    func fetchSightListModels(handler: NSArray -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: NSArray -> Void) {
        var post         = [String: String]()
        post["sightId"]  = sightId
        post["page"]     = String(self.page)
        post["pageSize"] = String(self.pageSize)
        
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/book", post: post) { (result, error) -> () in
            if error == nil {
                let sightBook = NSMutableArray() // [SightBook]()
                for item in result!["data"] as! NSArray {
                    sightBook.addObject(SightBook(dict: item as! [String : AnyObject]))
                }
                
                // 回调
                handler(sightBook)
            }
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
