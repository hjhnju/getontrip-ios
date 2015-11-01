//
//  SightListRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/28.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SightRequest: NSObject {
    
    // 请求参数
    var sightId :String = ""
    var page    :Int = 1
    var pageSize:Int = 6
    var tag     :String = ""
    
    func fetchNextPageModels(handler: (Sight?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: (Sight?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }
    
    // 将数据回调外界
    func fetchModels(handler: (Sight?, Int) -> Void) {
        var post         = [String: String]()
        post["sightId"]  = sightId
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        post["tags"]     = String(tag)
        // 发送网络请求加载数据
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/sight", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                if let dict = result.dictionaryObject {
                    let sight = Sight(dict: dict)
                    handler(sight, status)
                }
                
//                var dict = [String : AnyObject]()
//                var sightTags = [Tag]()
//                if result["tags"] != nil {
//                    for item in result["tags"].arrayValue {
//                        if let item = item.dictionaryObject {
//                            sightTags.append(Tag(dict: item))
//                        }
//                    }
//                }
//                sight.tags = sightTags
                
                return
            }
            handler(nil, status)
        }
    }
}