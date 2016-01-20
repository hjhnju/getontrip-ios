//
//  SightTopicsRequest.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/30.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class SightTopicsRequest: NSObject {
    
    // 请求参数
    var sightId :String = ""
    var page    :Int = 1
    var pageSize:Int = 10
    var tagId   :String = ""
    
    func fetchNextPageModels(handler: (([TopicBrief]?, Int) -> Void)) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: (([TopicBrief]?, Int) -> Void)) {
        page = 1
        return fetchModels(handler)
    }
    
    // 将数据回调外界
    func fetchModels(handler: ([TopicBrief]?, Int) -> Void) {
        var post         = [String: String]()
        post["sightId"]  = sightId
        post["tags"]     = String(tagId)
        post["pageSize"] = String(pageSize)
        post["page"]     = String(page)
        // 发送网络请求加载数据
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/sight/topic", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var topics = [TopicBrief]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        let topic = TopicBrief(dict: item)
                        topic.sightid = self.sightId
                        topics.append(topic)
                    }
                }
                handler(topics, status)
                return
            }
            handler(nil, status)
        }
    }
}