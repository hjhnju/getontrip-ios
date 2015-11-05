//
//  TopicDetailRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit

class TopicRequest: NSObject {
    
    // 请求参数
    var topicId : String = ""
    var sightId : String = ""
    
    // 异步加载获取数据
    func fetchModels(handler: (result: Topic?, status: Int?) -> Void) {
        var post         = [String: String]()
        post["topicId"]  = String(topicId)
        post["sightId"]  = String(sightId)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/topic", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                if let dict = result.dictionaryObject {
                    handler(result: Topic(dict: dict), status: status)
                    return
                }
                handler(result: nil, status: status)
            }
        }
    }
}