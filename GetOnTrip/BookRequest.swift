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
    var pageSize:Int = 6
    var page    :Int = 1
    var sightId :Int
    
    // 初始化方法
    init(sightId: Int) {
        
        self.sightId = sightId
    }
    
    // 将数据回调外界
    func fetchBookModels(handler: [Book] -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: [Book] -> Void) {
        var post         = [String: String]()
//        post["page"]     = String(self.page)
//        post["pageSize"] = String(self.pageSize)
        post["sightId"]    = String(self.sightId)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIniOnline.BaseUri,
            path: "/api/book",
            post: post,
            handler: {(respData: JSON) -> Void in

                for item in respData.arrayValue {
                    var books = [Book]()
                    for it in respData.arrayValue {
                        // 转换书籍元素详情
                        let create_time = it["create_time"].stringValue
                        let author = it["author"].stringValue
                        let content_desc = it["content_desc"].stringValue
                        let price_mart = it["price_mart"].stringValue
                        let id = it["id"].stringValue
                        let press = it["press"].stringValue
                        let price_jd = it["price_jd"].stringValue
                        let title = it["title"].stringValue
                        let url = it["url"].stringValue
                        let isbn = it["isbn"].stringValue
                        let status = it["status"].stringValue
                        let pages = it["pages"].stringValue
                        let image = it["image"].stringValue
                        let totalNum = it["totalNum"].stringValue

                        let bookM = Book(create_time: create_time, author: author, content_desc: content_desc, price_mart: price_mart, id: id, press: press, price_jd: price_jd, title: title, url: url, isbn: isbn, status: status, pages: pages, image: image, totalNum: totalNum)
                        books.append(bookM)
                    }
                    
                    // 回调
                    handler(books)
                }
            }
        )
    }

}
