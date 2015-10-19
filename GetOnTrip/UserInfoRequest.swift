//
//  UserInfoRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/10.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class UserInfoRequest: NSObject {
    /**
    * 接口4：/api/user/info
    * 用户信息获取接口
    * @param integer deviceId
    * @return json
    */
    
    // 请求参数
//    var deviceId = appUUID!
//    
//    // 将数据回调外界
//    func fetchBookModels(handler: Topic -> Void) {
//        fetchModels(handler)
//    }
//    
//    // 异步加载获取数据
//    func fetchModels(handler: Topic -> Void) {
//        var post         = [String: String]()
//        post["deviceId"]  = String(self.deviceId)
//        
//        // 发送网络请求加载数据
//        HttpRequest.ajax(AppIni.BaseUri,
//            path: "/api/user/info",
//            post: post,
//            handler: {(respData: AnyObject) -> Void in
//
//                let topic = Topic(dict: respData[0] as! [String : String])
//                // 转换话题详情
////                let id              = respData["id"].intValue
////                let title           = respData["title"].stringValue
//                //topic?.subtitle = respData[""].stringValue
////                topic = Topic(topicid: id, title: title, subtitle: "")
//                topic.image     = AppIni.BaseUri + String(respData[0]["image"])
//                
////                topic!.favorites    = respData["collect"].intValue
////                topic!.visits       = respData["visits"].intValue
////                topic!.desc         = respData["content"].stringValue
////                topic!.from         = respData["from"].stringValue
////                topic!.commentCount = respData["commentNum"].intValue
//                
////                var tags = [String]()
////                for it in respData[0]["tags"] {
////                    tags.append(it.stringValue)
////                }
////                topic!.tags = tags
//                // 回调
//                handler(topic)
//            }
//        )
//    }
}
