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
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/city/topic", post: post) { (result, error) -> () in
            if error == nil {
                print(result)
                var topics = [BriefTopic]()
                
                for item in result!["data"] as! NSArray {
                    topics.append(BriefTopic(dict: item as! [String : String]))
                }
                // 回调
                handler(topics)
            }
        }
    }
}

/// 用位置换取城市
class LocateBarterCity: NSObject {
    
    /**
    * 接口5：/api/city/locate
    * 获取城市定位信息，判断是否开启，如果名称没错并已开启则返回城市ID，否则返回''
    * @param string city，城市名称可以是中文或英文
    * @return json
    */
    
    class func locateBarterCityAction(city: String, handler: AnyObject -> Void) {
        var post         = [String: String]()
        post["city"]     = String(city)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/city/locate", post: post) { (result, error) -> () in
            if error == nil {
                handler(result!)
            }
        }
    }
}
