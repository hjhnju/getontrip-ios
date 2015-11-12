//
//  TopicRefreshRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

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
    func fetchModels(handler: [TopicBrief] -> Void) {
        var post         = [String: String]()
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        post["city"]     = String(city!)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/city/topic", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var topics = [TopicBrief]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        topics.append(TopicBrief(dict: item))
                    }
                    handler(topics)
                }
                return
            }
        }
    }
}