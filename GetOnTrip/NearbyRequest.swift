//
//  SightAndTopTopics.swift
//  Smashtag
//
//  Created by 何俊华 on 15/7/22.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation

class NearbyRequest {
    
    init(gps:Int, count:Int){
        
    }
    
    // 异步API，参数为回调函数
    // 返回NearbyModel的列表，e.g 附近3个景点
    //
    func fetchModels(handler: [NearbySight] -> Void){
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            //mock
            var result = [NearbySight]()
            let beginIndex = Int(arc4random_uniform(123) % 100)
            let endIndex = beginIndex + 1
            for i in beginIndex...endIndex {
                var sight = NearbySight(sightid:i,name: "sight\(i)")
                sight.topics.append(Topic(topicid:i+100, title:"sight\(i)-话题\(i+100)", subtitle:"sight\(i)-副标题"))
                sight.topics.append(Topic(topicid:i+200, title:"sight\(i)-话题\(i+200)", subtitle:"sight\(i)-副标题"))
                result.append(sight)
            }
            handler(result)
        }
    }
}
