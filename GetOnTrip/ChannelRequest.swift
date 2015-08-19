//
//  Channel.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/18.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class ChannelRequest: NSObject {


    
    // 话题ID
    var topicId:Int = 1

    // 用户的设备ID
    var deviceId:String = ""
    
    // 获取当前页的数据
    var curPage:Int = 1
    var pageSize:Int = 2
    
    // 景点ID
    var sight: Int = 1
    // 排序次序，1：热门，2：最近更新，默认可以不传
    var order: Int = 1
    // 标签ID串，逗号分隔
    var tags: String = ""

    
    
    
    
    
//    //默认城市：北京
//    var cityId:Int = 2
//    
//    var pageSize:Int = 2
//    
//    //获取当前页的数据
//    var curPage:Int = 1
//    
//    init(curLocation:CLLocation?){
//        
//        self.curLocation = curLocation
//    }
    
//    func fetchNextPageModels(handler: [Sight] -> Void) {
//        fetchModels(handler)
//    }
//    
//    func fetchFirstPageModels(handler:[Sight] -> Void) {
//        self.curPage = 1
//        fetchModels(handler)
//    }
    
    // 异步API，参数为回调函数
    // 返回NearbyModel的列表，e.g 附近3个景点
    //
//    private func fetchModels(handler: [Sight] -> Void){
//        var post     = [String:String]()
//        post["page"] = String(self.curPage)
//        post["pageSize"] = String(self.pageSize)
//        if curLocation != nil{
//            post["x"] = String(format: "%.f", Double(self.curLocation!.coordinate.latitude))
//            post["y"] = String(format: "%.f", Double(self.curLocation!.coordinate.longitude))
//        }
//        post["city"] = String(self.cityId)
    
//        HttpRequest.ajax(AppIni.BaseUri,
//            path: "/api/home",
//            post: post,
//            handler: {(respData: JSON) -> Void in
//                var sights = [Sight]()
//                for item in respData.arrayValue {
//                    let sightId = item["id"].intValue
//                    let name    = item["name"].stringValue
//                    var sight   = Sight(sightid: sightId, name: name)
//                    sight.city  = item["city"].stringValue
//                    sight.cityId = item["city_id"].intValue
//                    sight.desc  = item["describe"].stringValue
//                    sight.imageUrl = AppIni.BaseUri + item["image"].stringValue
//                    sight.distance = item["dis"].stringValue
//                    for it in item["topic"].arrayValue {
//                        let topicId = it["id"].intValue
//                        let title   = it["title"].stringValue
//                        let subtitle = it["subtitle"].stringValue
//                        var topic = Topic(topicid: topicId, title: title, subtitle: subtitle)
//                        topic.desc = it["desc"].stringValue
//                        topic.favorites = it["collect"].intValue
//                        topic.visits = it["visit"].intValue
//                        topic.imageUrl = AppIni.BaseUri + it["image"].stringValue
//                        topic.from = it["from"].stringValue
//                        topic.sight = name
//                        topic.distance = sight.distance
//                        sight.topics.append(topic)
//                    }
//                    sights.append(sight)
//                }
//                if sights.count > 0 {
//                    self.curPage = self.curPage + 1
//                }
//                handler(sights)
//            }
//        )
//    }

}



