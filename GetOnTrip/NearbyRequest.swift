//
//  SightAndTopTopics.swift
//  Smashtag
//
//  Created by 何俊华 on 15/7/22.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

class NearbyRequest {
    
    var curLocation:CLLocation?
    
    var cityId:Int?
    
    var pageSize:Int = 3
    
    var page:Int
    
    init(curLocation:CLLocation?, page:Int){
        
        self.curLocation = curLocation
        self.cityId = 0 //北京cityid
        self.page = page
    }
    
    init(cityId:Int, page:Int){
        self.cityId = cityId
        self.page = page
    }
    
    // 异步API，参数为回调函数
    // 返回NearbyModel的列表，e.g 附近3个景点
    //
    func fetchModels(handler: [NearbySight] -> Void){
        Alamofire.request(.GET, "http://alex.ichajia.com/phpinfo.php").responseJSON { _, _, data, _ in
            var scenics:[NearbySight] = []
            var topics:[Topic] = []
            var json = data as! NSDictionary
            for (key, value) in json{
                topics = []
                for(key, valueInside) in value["topic"] as! NSDictionary{
                    var topic = Topic(
                        topicid: valueInside["id"] as! Int,
                        title: valueInside["title"] as! String,
                        subtitle: valueInside["subtitle"] as! String
                    )
                    if let favorites = valueInside["collect"] as? String{
                        topic.favorites = favorites
                    }
                    if let scan = valueInside["scan"] as? String{
                        topic.scan = scan
                    }
                    if let desc = valueInside["brief"] as? String{
                        topic.desc = desc
                    }
                    if let image = valueInside["image"] as? String{
                        topic.imageUrl = image
                    }
                    topics.append(topic)
                }
                var sight = NearbySight(
                    sightid: value["id"] as! Int,
                    name: value["name"] as! String,
                    topics: topics
                )
                if let distance = value["distance"] as? String{
                    sight.distance = distance
                }
                if let city = value["address"] as? String{
                    sight.city = city
                }
                if let desc = value["brief"] as? String{
                    sight.desc = desc
                }
                if let image = value["image"] as? String{
                    sight.imageUrl = image
                }
                scenics.append(sight)
            }
            handler(scenics)
        }
    }
}
