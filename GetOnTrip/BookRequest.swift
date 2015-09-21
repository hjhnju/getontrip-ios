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
        post["sightId"]    = String(self.sightId)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIniOnline.BaseUri,
            path: "/api/book",
            post: post,
            handler: {(respData: AnyObject) -> Void in

                    var books = [Book]()
                    for it in respData as! NSArray {
                        print(it)
                        // 转换书籍元素详情
                        let bookM = Book(dict: it as! [String : AnyObject])
//                        http://123.57.67.165:8301/api/book?sightId=1

                        books.append(bookM)
                    }
                    
                    // 回调
                    handler(books)
            }
        )
    }

}
