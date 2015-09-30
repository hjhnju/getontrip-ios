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
            handler: {(respData: AnyObject) -> Void in

                var topic: Topic?
                for item in respData as! NSArray {
                    topic = Topic(dict: item as! [String : String])
                    
                    var tags = [String]()
                    for it in item as! NSArray {
                        tags.append(it as! String)
                    }
                    topic?.tags = tags
                }

                    // 回调
                handler(topic!)
            }
        )
    }
}
