//
//  MessageListRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class MessageListRequest: NSObject {
    
    /**
    * 接口1：/api/msg/list
    * 查询消息
    * @param integer page，页码
    * @param integer pageSize，页面大小
    * @param string deviceId,设备ID
    * @return json
    */
    
    // 请求参数
    var deviceId :String = appUUID!
    var pageSize :Int = 6
    var curPage  :Int = 1
    
    // 将数据回调外界
    func fetchFeedBackModels(handler: [MessageList] -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: [MessageList] -> Void) {
        var post         = [String: String]()
        post["deviceId"] = appUUID
        post["pageSize"] = String(self.pageSize)
        post["page"]     = String(self.curPage)
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIniDev.BaseUri,
            path: "/api/msg/list",
            post: post,
            handler: {(respData: NSArray) -> Void in

                var messageLists = [MessageList]()
                for item in respData {
                    let messageListM = MessageList()
                    messageListM.attach  = item["attach"] as? String
                    messageListM.content = item["content"] as? String
                    messageListM.avatar  = AppIni.BaseUri + String(item["avatar"])
                    messageListM.mid     = item["mid"] as? Int
                    messageListM.title   = item["title"] as? String
                    messageListM.image   = AppIni.BaseUri + String(item["image"])
                    messageListM.create_time = item["create_time"] as? String
                    messageListM.type    = item["type"] as? String
                    messageLists.append(messageListM)
                }
                
                // 回调
                handler(messageLists)
            }
        )
    }
}
