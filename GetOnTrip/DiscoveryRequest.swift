//
//  DiscoveryRequest.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/22.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation

class DiscoveryRequest {
    
    var pageSize:Int = 8
    
    //获取当前页的数据
    var curPage:Int = 1
    
    func fetchNextPageModels(handler: [Topic] -> Void) {
        fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler:[Topic] -> Void) {
        self.curPage = 1
        fetchModels(handler)
    }
    
    // 异步API，参数为回调函数
    private func fetchModels(handler: [Topic] -> Void){
        var post         = [String:String]()
        post["page"]     = String(self.curPage)
        post["pageSize"] = String(self.pageSize)
        
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/find",
            post: post,
            handler: {(respData: JSON) -> Void in
                var topics = [Topic]()
                for it in respData.arrayValue {
                    let topicId  = it["id"].intValue
                    let title    = it["title"].stringValue
                    let subtitle = it["subtitle"].stringValue
                    
                    var topic  = Topic(topicid: topicId, title: title, subtitle: subtitle)
                    topic.desc      = it["desc"].stringValue
                    topic.favorites = it["collect"].intValue
                    topic.visits    = it["visit"].intValue
                    topic.imageUrl  = AppIni.BaseUri + it["image"].stringValue
                    topic.from      = it["from"].stringValue
                    topic.sight     = it["sight"].stringValue
                    topic.city      = it["city"].stringValue
                    topic.distance  = it["dist"].stringValue
                    topic.commentCount = it["comment"].intValue
                    topics.append(topic)
                }
                if topics.count > 0 {
                    self.curPage = self.curPage + 1
                }
                handler(topics)
            }
        )
    }
}
