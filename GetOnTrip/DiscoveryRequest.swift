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
            handler: {(respData: AnyObject) -> Void in
                
                var topics = [Topic]()
                for it  in respData as! NSArray {
                    let topic = Topic(dict: it as! [String : String])
//                    let topicId: Int  = (it["id"] as? Int)!
//                    let title: String = it["title"]! as! String
//                    let subtitle: String = it["subtitle"] as! String
                    
//                    let topic  = Topic(topicid: topicId, title: title, subtitle: subtitle)
//                    topic.desc      = it["desc"]!!.stringValue
//                    topic.favorites = it["collect"] as? Int
//                    topic.visits    = it["visit"] as? Int
//                    topic.imageUrl  = AppIni.BaseUri + String(it["image"])
//                    topic.from      = it["from"]! as? String
//                    topic.sight     = it["sight"]! as? String
//                    topic.city      = it["city"]! as? String
//                    topic.distance  = it["dist"]! as? String
//                    topic.commentCount = it["comment"]! as? Int
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
