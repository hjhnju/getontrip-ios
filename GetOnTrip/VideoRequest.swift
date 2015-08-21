//
//  VideoRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/19.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class VideoRequest: NSObject {
   /**
    * 接口1：/api/video
    * 视频详情接口
    * @param integer page
    * @param integer pageSize
    * @param integer sightId,景点ID
    * @return json
    */
    
    // 请求参数
    var pageSize:Int = 2
    var page    :Int = 1
    var sightId :Int
    
    // 初始化方法
    init(sightId: Int) {
        
        self.sightId = sightId
    }
    
    // 将数据回调外界
    func fetchVideoModels(handler: [Video] -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: [Video] -> Void) {
        var post         = [String: String]()
        post["page"]     = String(self.page)
        post["pageSize"] = String(self.pageSize)
        post["sightId"]  = String(self.sightId)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIniOnline.BaseUri,
            path: "/api/video",
            post: post,
            handler: {(respData: JSON) -> Void in

                    var videos = [Video]()
                    for it in respData.arrayValue {
                        // 转换视频属性
                        let from     = it["from"].stringValue
                        let status   = it["status"].stringValue
                        let totalNum = it["totalNum"].stringValue
                        let id       = it["id"].stringValue
                        let len      = it["len"].stringValue
                        let title    = it["title"].stringValue
                        let image    = it["image"].stringValue
                        let create_time = it["create_time"].stringValue
                        let type     = it["type"].stringValue
                        let url      = it["url"].stringValue

                        let video = Video(from: from, status: status, totalNum: totalNum, id: id, len: len, title: title, image: image, create_time: create_time, type: type, url: url)
                        videos.append(video)
                    }
                
                    // 回调
                    handler(videos)
                }
        )


    }
    
}
