//
//  FoodRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/19.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class FoodRequest: NSObject {
    
    // 请求参数
    var foodId       : String = ""
    var shopPage     :Int = 1
    var shopPageSize :Int = 4
    var topicPage    :Int = 1
    var topicPageSize:Int = 4
    
    // 异步加载获取数据
    func fetchModels(handler: (result: FoodDetail?, status: Int?) -> Void) {
        var post         = [String: String]()
        post["id"]  = String(foodId)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/food", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                if let dict = result.dictionaryObject {
                    handler(result: FoodDetail(dict: dict), status: status)
                    return
                }
                handler(result: nil, status: status)
            }
        }
    }

    
    func foodFetchNextPageModels(handler: (([ShopDetail]?, Int) -> Void)) {
        shopPage = shopPage + 1
        return foodFetchModels(handler)
    }
    
    func foodFetchFirstPageModels(handler: (([ShopDetail]?, Int) -> Void)) {
        shopPage = 1
        return foodFetchModels(handler)
    }
    
    // 将数据回调外界
    func foodFetchModels(handler: ([ShopDetail]?, Int) -> Void) {
        var post         = [String: String]()
        post["id"]       = String(foodId)
        post["pageSize"] = String(shopPageSize)
        post["page"]     = String(shopPage)
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/food/shop", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var topics = [ShopDetail]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        let topic = ShopDetail(dict: item)
                        topics.append(topic)
                    }
                }
                handler(topics, status)
                return
            }
            handler(nil, status)
        }
    }
    
    func topicFetchNextPageModels(handler: (([FoodTopicDetail]?, Int) -> Void)) {
        topicPage = topicPage + 1
        return topicFetchModels(handler)
    }
    
    func topicFetchFirstPageModels(handler: (([FoodTopicDetail]?, Int) -> Void)) {
        topicPage = 1
        return topicFetchModels(handler)
    }
    
    // 将数据回调外界
    func topicFetchModels(handler: ([FoodTopicDetail]?, Int) -> Void) {
        var post         = [String: String]()
        post["id"]       = String(foodId)
        post["pageSize"] = String(topicPageSize)
        post["page"]     = String(topicPage)
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/food/topic", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var topics = [FoodTopicDetail]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        let topic = FoodTopicDetail(dict: item)
                        topics.append(topic)
                    }
                }
                handler(topics, status)
                return
            }
            handler(nil, status)
        }
    }
}
