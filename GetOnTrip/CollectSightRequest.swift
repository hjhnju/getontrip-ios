//
//  FavoriteRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/8.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class CollectSightRequest: NSObject {
   
    /**
    * 接口1：/api/collect/list
    * 获取收藏列表内容
    * @param integer type,1：话题;2：景点；3：城市
    * @param string  device,设备ID
    * @param integer page，页码
    * @param integer pageSize，页面大小
    * @return json
    */

    // 请求参数
    var type    :Int?
    var device  :String = appUUID!
    var page    : Int = 1
    var pageSize: Int = 6
    
    /// 将收藏景点数据回调外界
    func fetchCollectSightModels(handler: [CollectSight] -> Void) {
        fetchSightModels(handler)
    }
    
    /// 将收藏话题数据回调外界
    func fetchCollectTopicModels(handler: [CollectTopic] -> Void) {
        fetchTopicModels(handler)
    }
    
    /// 将收藏主题数据回调外界
    func fetchCollectMotifModels(handler: [CollectMotif] -> Void) {
        fetchMotifModels(handler)
    }
    // 异步加载景点获取数据
    func fetchSightModels(handler: [CollectSight] -> Void) {
        var post       = [String: String]()
        post["type"]   = String(2)
        post["device"] = String(self.device)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/collect/list",
            post: post,
            handler: {(respData: AnyObject) -> Void in

                var collectSightM = [CollectSight]()
                    for it in respData as! NSArray {
                        
                        let collectM = CollectSight(dict: it as! [String : String])

                        collectSightM.append(collectM)
                    }

                    // 回调
                    handler(collectSightM)
            }
        )
    }
    
    // 异步加载话题获取数据
    func fetchTopicModels(handler: [CollectTopic] -> Void) {
        var post       = [String: String]()
        post["type"]   = String(1)
        post["device"] = String(self.device)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/collect/list",
            post: post,
            handler: {(respData: AnyObject) -> Void in
                
                var collectSightM = [CollectTopic]()
                    for it in respData as! NSArray {
                        
                        let collectM = CollectTopic(dict: it as! [String : String])
//                        collectM.id = it["id"].intValue
//                        collectM.title = it["title"].stringValue
//                        collectM.collect = it["collect"].stringValue
//                        collectM.subtitle = it["subtitle"].stringValue
                        collectM.image = AppIni.BaseUri + String(it["image"])
                        collectSightM.append(collectM)
                    }
                    
                    // 回调
                    handler(collectSightM)
            }
        )
    }
    
    // 异步加载主题获取数据
    func fetchMotifModels(handler: [CollectMotif] -> Void) {
        var post       = [String: String]()
        post["type"]   = String(3)
        post["device"] = String(self.device)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/collect/list",
            post: post,
            handler: {(respData: AnyObject) -> Void in
                
                var collectSightM = [CollectMotif]()
                    for it in respData as! NSArray {
                        
                        let collectM = CollectMotif(dict: it as! [String : String])
//                        collectM.id = it["id"].intValue
//                        collectM.collect = it["collect"].stringValue
//                        collectM.name = it["name"].stringValue
//                        collectM.period = it["period"].stringValue
                        collectM.image = AppIni.BaseUri + String(it["image"])
                        
                        collectSightM.append(collectM)
                    }
                    
                    // 回调
                    handler(collectSightM)
            }
        )
    }
}


/// 景点
class CollectSight: NSObject {
    
    /// 收藏话题id
    var id: Int?
    /// 话题名
    var name: String?
    /// 话题图片
    var image: String?
    /// 共几个话题
    var topicNum: String?
    
    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

/// 话题
class CollectTopic: NSObject {
    /// 收藏话题id
    var id: Int?
    /// 标题
    var title: String?
    /// 收藏数
    var collect: String?
    /// 图片
    var image: String?
    /// 副标题
    var subtitle: String?
    
    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

class CollectMotif: NSObject {
    
    /// 收藏主题id
    var id: Int?
    /// 收藏数
    var collect: String?
    /// 图片
    var image: String?
    /// 主题名字
    var name: String?
    /// 第几期
    var period: String?
    
    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}