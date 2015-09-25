//
//  HomeCityCenterRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class HomeCityCenterRequest {
    /**
    * 接口1：/api/home
    * 城市中间页   首页入口一
    * @param string deviceId，设备ID
    * @param string city,城市名称，如果不能给出城市名称，默认是北京
    * @return json
    */
    
    // 请求参数
    var deviceId :String = appUUID!
    var city: String     = "北京"
    
    // 将数据回调外界
    func fetchFeedBackModels(handler: NSDictionary -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: NSDictionary -> Void) {
        var post         = [String: String]()
        post["deviceId"] = appUUID
        post["city"]     = String(city)

        // 发送网络请求加载数据
        HttpRequest.ajax(AppIniDev.BaseUri,
            path: "/api/home",
            post: post,
            handler: {(respData: AnyObject) -> Void in
                
                var homeModel = NSDictionary()
                
                var city   = HomeCity(dict: respData["city"] as! [String : AnyObject])
                var sights = [HomeSight]()
                var topics = [HomeTopic]()
                
                for item in respData["sight"] as! NSArray {
                    sights.append(HomeSight(dict: item as! [String : String]))
                }
                
                for item in respData["topic"] as! NSArray {
                    topics.append(HomeTopic(dict: item as! [String : String]))
                }
                
                homeModel.setValue(city, forKey: "city")
                homeModel.setValue(sights, forKey: "sights")
                homeModel.setValue(topics, forKey: "topics")
                
                // 回调
                handler(homeModel)
            }
        )
    }
}

class HomeCity : NSObject {
     /// id
    var id: String?
     /// 城市名
    var name: String?
    /// 城市图片
    var image: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

class HomeSight : NSObject {
    /// id
    var id: String?
    /// 景点名
    var name: String?
    /// 景点图片
    var image: String?
    /// 景点内容
    var desc: String?
    
    init(dict: [String: String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

class HomeTopic : NSObject {
    /// id
    var id: String?
    /// 城市名
    var title: String?
    /// 副标题
    var subtitle: String?
    /// 话题内容(可能不需要)
    var desc: String?
    /// 访问数
    var visit: String?
    /// 收藏数
    var collect: String?
    /// 来自（可能不要）
    var from: String?
    /// 图片
    var image: String?
    /// 景点（可能不要）
    var sight: String?
    /// 标签
    var tag: String?
    
    
    init(dict: [String: String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
