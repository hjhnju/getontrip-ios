//
//  HomeCityCenterRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CityRequest {
    /**
    * 接口1：/api/home
    * 城市中间页   首页入口一
    * @param string deviceId，设备ID
    * @param string city,城市ID
    * @return json
    */
    
    // 请求参数
    var deviceId :String = appUUID!
    var city: String     = ""
    
    // 异步加载获取数据
    func fetchModels(handler: NSDictionary -> Void) {
        var post         = [String: String]()
        post["city"]     = String(city)

        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/city", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                let dictData = NSMutableDictionary()
                if let item = result["city"].dictionaryObject {
                    let city   = City(dict: item)
                    dictData.setValue(city, forKey: "city")
                }
                var sights = [Sight]()
                var topics = [TopicBrief]()
                for item in result["sight"].arrayValue {
                    if let dict = item.dictionaryObject {
                        sights.append(Sight(dict: dict))
                    }
                }
                for item in result["topic"].arrayValue {
                    if let dict = item.dictionaryObject {
                        topics.append(TopicBrief(dict: dict))
                    }
                }
                dictData.setValue(sights, forKey: "sights")
                dictData.setValue(topics, forKey: "topics")
                dictData.setValue(result["page_num"].intValue, forKey: "pageNum")
                // 回调
                handler(dictData)
            }
        }
    }
}
