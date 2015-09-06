//
//  TopicDetailRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/26.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import SSKeychain

class TopicDetailRequest: NSObject {
   /**
    * 接口1：/api/topic/detail
    * 话题详情页接口
    * @param integer topicId，话题ID
    * @param string  deviceId，用户的设备ID（因为要统计UV）
    * @return json
    */
    
    // 请求参数
    var topicId  :Int
    var deviceId :String
    var pageSize:Int = 6
    
    //获取当前页的数据
    var curPage:Int = 1

    // 初始化方法
    init(topicId: Int) {
        self.topicId = topicId
        
        self.deviceId = appUUID!
    }
    
    // 将数据回调外界
    func fetchBookModels(handler: Topic -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: Topic -> Void) {
        var post         = [String: String]()
        post["topicId"]  = String(self.topicId)
        post["deviceId"] = String(self.deviceId)
        post["page"]     = String(self.curPage)
        post["pageSize"] = String(self.pageSize)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIniOnline.BaseUri,
            path: "/api/topic/detail",
            post: post,
            handler: {(respData: JSON) -> Void in
                println(respData)
                var topic: Topic?
                // 转换话题详情
                let id              = respData["id"].intValue
                let title           = respData["title"].stringValue
                //topic?.subtitle = respData[""].stringValue
                topic = Topic(topicid: id, title: title, subtitle: "")
                topic!.imageUrl     = AppIniOnline.BaseUri + respData["image"].stringValue
                
                topic!.favorites    = respData["collect"].intValue
                topic!.visits       = respData["visits"].intValue
                topic!.desc         = respData["content"].stringValue
                topic!.from         = respData["from"].stringValue
                topic!.commentCount = respData["commentNum"].intValue
                
                    var tags = [String]()
                    for it in respData["tags"].arrayValue {
                        tags.append(it.stringValue)
//                        tags.addObject(it.stringValue)
                    }
                topic!.tags = tags
                    // 回调
                handler(topic!)
            }
        )
    }
}
