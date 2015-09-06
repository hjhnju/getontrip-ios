//
//  FeedBackRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class FeedBackRequest: NSObject {
    /**
    * 接口1：/api/advise/list
    * 查询反馈意见接口
    * @param string deviceId，设备ID
    * @return json
    */
    
    // 请求参数
    var deviceId :String
    
    // 初始化方法
    init(deviceId: String) {
        self.deviceId = appUUID!
    }
    
    // 将数据回调外界
    func fetchFeedBackModels(handler: [FeedBack] -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: [FeedBack] -> Void) {
        var post         = [String: String]()
        post["deviceId"]  = String(self.deviceId)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIniDev.BaseUri,
            path: "/api/advise/list",
            post: post,
            handler: {(respData: JSON) -> Void in
                println(respData)
                
                var feedBackList = [FeedBack]()
                for feedBack in respData.arrayValue {
                    
                    var feedBackM: FeedBack?
                    let id          = feedBack["id"].intValue
                    let content     = feedBack["content"].stringValue
                    let type        = feedBack["type"].intValue
                    let image       = feedBack["image"].stringValue
                    let create_time = feedBack["create_time"].stringValue
                    feedBackM = FeedBack(content: content, id: id, type: type, image: image, create_time: create_time)
                    feedBackList.append(feedBackM!)
                }
                // 回调
                handler(feedBackList)
            }
        )
    }
}
