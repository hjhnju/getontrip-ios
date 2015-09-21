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
            handler: {(respData: NSArray) -> Void in

                    var videos = [Video]()
                    for it in respData {
                        print(it)
                        // 转换视频属性
                        let video = Video(dict: it as! [String : AnyObject])

                        videos.append(video)
                    }
                
                    // 回调
                    handler(videos)
                }
        )


    }
    
}
