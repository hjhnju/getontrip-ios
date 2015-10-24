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
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/city",

            post: post,
            handler: {(respData: AnyObject) -> Void in
                

                let homeModel = NSMutableDictionary()
                
                let city   = City(dict: respData["city"] as! [String : AnyObject])
                var sights = [Sight]()
                var topics = [BriefTopic]()
                
                for item in respData["sight"] as! NSArray {
                    sights.append(Sight(dict: item as! [String : String]))
                }
                
                for item in respData["topic"] as! NSArray {
                    topics.append(BriefTopic(dict: item as! [String : String]))
                }
                
                homeModel.setValue(city, forKey: "city")
                homeModel.setValue(sights, forKey: "sights")
                homeModel.setValue(topics, forKey: "topics")
                homeModel.setValue(respData["page_num"], forKey: "pageNum")
                
                // 回调
                handler(homeModel)
            }
        )
    }
}
