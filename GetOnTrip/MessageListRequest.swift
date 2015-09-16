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
            handler: {(respData: JSON) -> Void in
                println(respData)
               var messageLists = [MessageList]()
                for item in respData.arrayValue {
                    let attach = item["attach"].stringValue
                    let content = item["content"].stringValue
                    let avatar  = AppIni.BaseUri + item["avatar"].stringValue
                    let mid     = item["mid"].intValue
                    let title   = item["title"].stringValue
                    let image   = AppIni.BaseUri + item["image"].stringValue
                    println(image)
                    let cTime   = item["create_time"].stringValue
                    let type    = item["type"].stringValue
                    var messageListM = MessageList(attach: attach, content: content, avatar: avatar, mid: mid, title: title, image: image, create_time: cTime, type: type)
                    messageLists.append(messageListM)
                }
                
                // 回调
                handler(messageLists)
            }
        )
    }
}
