//
//  SightPulsateRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/18.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class SightSpecialtyRequest: NSObject {
    // 请求参数
    var sightId :String = ""
    var page    :Int = 1
    var pageSize:Int = 10
    var enterInfo:String = "sight"
    
    func fetchNextPageModels(handler: (([Specialty]?, Int) -> Void)) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: (([Specialty]?, Int) -> Void)) {
        page = 1
        return fetchModels(handler)
    }
    
    // 将数据回调外界
    func fetchModels(handler: ([Specialty]?, Int) -> Void) {
        var post         = [String: String]()
        if enterInfo == "sight" {
            post["sightId"]  = sightId
        } else {
            post["cityId"]   = sightId
        }
        post["pageSize"] = String(pageSize)
        post["page"]     = String(page)
        // 发送网络请求加载数据
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/\(enterInfo)/specialty", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var topics = [Specialty]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        let topic = Specialty(dict: item)
                        topic.sightid = self.sightId
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