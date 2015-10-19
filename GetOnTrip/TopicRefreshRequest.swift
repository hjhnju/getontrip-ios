//
//  TopicRefreshRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class TopicRefreshRequest: NSObject {
    
    /**
    * 接口4：/api/city/topic
    * 获取城市话题,定位了城市后刷新话题时使用
    * @param integer page,页码
    * @param integer pageSize,页面大小
    * @return json
    */
    
    // 请求参数
    var page    : Int    = 2
    var pageSize: String = "4"
    var city    : String?
    
    // 异步加载获取数据
    func fetchModels(handler: [BriefTopic] -> Void) {
        var post         = [String: String]()
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        post["city"]     = String(city!)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIniDev.BaseUri,
            path: "/api/city/topic",
            
            post: post,
            handler: {(respData: AnyObject) -> Void in
                
                var topics = [BriefTopic]()

                for item in respData as! NSArray {
                    topics.append(BriefTopic(dict: item as! [String : String]))
                }
                // 回调
                handler(topics)
            }
        )
    }
}
