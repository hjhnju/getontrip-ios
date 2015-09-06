//
//  FeedBackSendRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class FeedBackSendRequest: NSObject {
    /**
    * 接口2：/api/advise/add
    * 添加反馈意见接口
    * @param string deviceId，设备ID
    * @param string advise，意见信息
    * @return json
    */
    
    // 请求参数
    var deviceId :String
    /// 意见信息
    var advise   : String
    
    // 初始化方法
    init(deviceId: String, advise: String) {
        self.deviceId = appUUID!
        self.advise   = advise
    }
    
    // 将数据回调外界
    func fetchFeedBackModels(handler: String -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: String -> Void) {
        var post         = [String: String]()
        post["deviceId"] = String(self.deviceId)
        post["advise"]   = String(self.advise)
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIniDev.BaseUri,
            path: "/api/advise/add",
            post: post,
            handler: {(respData: JSON) -> Void in
                println(respData)
                
                var reversion: AnyObject?
                reversion = respData.object
                
                // 回调
                handler(reversion as! String)
            }
        )
    }
}
