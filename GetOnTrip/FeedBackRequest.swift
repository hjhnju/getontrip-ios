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
            handler: {(respData: NSArray) -> Void in

                var feedBackList = [FeedBack]()
                for feedBack in respData {
                    
                    let feedBackM = FeedBack(dict: feedBack as! [String : String])
                    feedBackList.append(feedBackM)
                }
                // 回调
                handler(feedBackList)
            }
        )
    }
}
