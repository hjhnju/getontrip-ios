//
//  SightTopicsRequest.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/30.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

class SightTopicsRequest: NSObject {
    
    // 请求参数
    var sightId :String = ""
    var page    :Int = 1
    var pageSize:Int = 6
    var tag     :String = ""
    
    func fetchNextPageModels(handler: ([String : AnyObject]?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: ([String : AnyObject]?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }
    
    // 将数据回调外界
    func fetchModels(handler: ([String : AnyObject]?, Int) -> Void) {
        var post         = [String: String]()
        post["sightId"]  = sightId
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        post["tags"]     = String(tag)
        // 发送网络请求加载数据
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/sight/topic", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var dict = [String : AnyObject]()
                var sightTags = [Tag]()
                if result["tags"] != nil {
                    for item in result["tags"].arrayValue {
                        if let item = item.dictionaryObject {
                            sightTags.append(Tag(dict: item))
                        }
                    }
                }
                
                var sightData = [TopicCellData]()
                for item in result["list"].arrayValue {
                    if let item = item.dictionaryObject {
                        sightData.append(TopicCellData(dict: item))
                    }
                }
                dict["sightName"]  = result["name"].stringValue
                dict["sightTags"]  = sightTags
                dict["sightDatas"] = sightData
                handler(dict, status)
                return
            }
            handler(nil, status)
        }
    }
}