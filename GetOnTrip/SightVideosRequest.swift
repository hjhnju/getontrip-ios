//
//  SightVideosRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/19.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SightVideosRequest: NSObject {
    
    // 请求参数
    var sightId :String = ""
    var page    :Int = 1
    var pageSize:Int = 6
    
    func fetchNextPageModels(handler: ([Video]?, Int) -> Void) {
        page = page + 1
        return fetchVideoListModels(handler)
    }
    
    func fetchFirstPageModels(handler: ([Video]?, Int) -> Void) {
        page = 1
        return fetchVideoListModels(handler)
    }
    
    // 异步加载获取数据
    func fetchVideoListModels(handler: ([Video]?, Int) -> Void) {
        var post         = [String: String]()
        post["sightId"]  = sightId
        post["page"]     = String(self.page)
        post["pageSize"] = String(self.pageSize)
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/sight/video", post: post) { (result, status) -> () in
            
            if status == RetCode.SUCCESS {
                var sightVideo = [Video]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        sightVideo.append(Video(dict: item))
                    }
                }
                handler(sightVideo, status)
                return
            }
            handler(nil, status)
        }
    }
}
