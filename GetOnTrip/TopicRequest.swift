//
//  TopicDetailRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit

class TopicRequest: NSObject {

    /**
    * 接口1：/api/topic/detail
    * 话题详情页接口
    * @param integer topicId，话题ID
    * @param string deviceId，用户的设备ID（因为要统计UV）
    * @return json
    */
    
    // 请求参数
    var topicId :String?
    
    // 将数据回调外界
    func fetchTopicDetailModels(handler: TopicDetail -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: TopicDetail -> Void) {
        var post         = [String: String]()
        post["topicId"]  = String(topicId!)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/topic", post: post) { (result, error) -> () in
            if error == nil {
                if let data = result!["data"] as? [String : AnyObject] {
                    handler(TopicDetail(dict: data))
                }
            }
        }
    }
}