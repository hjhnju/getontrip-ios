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
    var pageSize:Int
    var page: Int
    var sightId: Int
    
    // 初始化方法
    init(pageSize: Int, page: Int, sightId: Int) {
        self.pageSize = pageSize
        self.page = page
        self.sightId = sightId
    }
    
    // 将数据回调外界
    func fetchTopicPageModels(handler:[TopicDetails] -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: [TopicDetails] -> Void) {
        var post         = [String: String]()
        post["page"]     = String(self.page)
        post["pageSize"] = String(self.pageSize)
        post["sight"]    = String(self.sightId)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/topic/list",
            post: post,
            handler: {(respData: JSON) -> Void in
                var topicDetails = [TopicDetails]()
                for item in respData.arrayValue {
                    // 转换话题详情元素
                    let from     = item["from"].stringValue
                    let subtitle = item["subtitle"].stringValue
                    let id       = item["id"].intValue
                    let title    = item["title"].stringValue
                    let collect  = item["collect"].intValue
                    let image    = item["image"].stringValue
                    let visit    = item["visit"].intValue
                    
//                    let topicDetail = TopicDetails(from: from, subtitle: subtitle, id: id, title: title, collect: collect, image: image, visit: visit, desc: desc, tags: tag)
//                    topicDetails.append(topicDetail)
                }
                // 回调
                handler(topicDetails)
            }
        )
    }

}
