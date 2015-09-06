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
    func fetchFeedBackModels(handler: String -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: String -> Void) {
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
                "\(respData)".writeToFile("/Users/zk-pro/Desktop/111", atomically: true, encoding: NSUTF8StringEncoding, error: nil)
                var reversion: AnyObject?
                reversion = respData.object
                
                // 回调
                handler(reversion as! String)
            }
        )
    }
}
