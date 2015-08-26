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
    
    // 初始化方法
    init(topicId: Int) {
        self.topicId = topicId
        
        // 获取uuid
        var uuid = SSKeychain.passwordForService(NSBundle.mainBundle().bundleIdentifier, account: "uuid")
        if (uuid == nil) {
            uuid = NSUUID().UUIDString
            SSKeychain.setPassword(uuid, forService: NSBundle.mainBundle().bundleIdentifier, account: "uuid")
        }
        self.deviceId = uuid
    }
    
    // 将数据回调外界
    func fetchBookModels(handler: TopicDetail -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: TopicDetail -> Void) {
        var post         = [String: String]()
        post["topicId"]  = String(self.topicId)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/topic/detail",
            post: post,
            handler: {(respData: JSON) -> Void in
                
                var topicDetail: TopicDetail?
                // 转换话题详情
                let from = respData["from"].stringValue
                let content = respData["content"].stringValue
                let id = respData["id"].intValue
                let title = respData["title"].stringValue
                let image = respData["image"].stringValue
                let dis = respData["dis"].stringValue
                let collect = respData["collect"].stringValue
                let visit = respData["visit"].stringValue
                let commentNum = respData["commentNum"].stringValue
                
                var tags = NSMutableArray()
                for it in respData["tags"].arrayValue {
                    tags.addObject(it.stringValue)
                }
                
                let topicDetailM = TopicDetail(from: from, content: content, id: id, title: title, image: image, dis: dis, collect: collect, visit: visit, commentNum: commentNum, tags: tags)
                
                    // 回调
                    handler(topicDetailM)
            }
        )
    }
}
