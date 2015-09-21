//
//  TopicRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/19.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class TopicRequest: NSObject {
    
    /**
    * 接口2：获取话题列表 /api/topic/list
    * @param integer page
    * @param integer pageSize
    * @param integer sight，景点ID
    * @param integer order，排序次序，1：热门，2：最近更新，默认可以不传
    * @param string  tags，标签ID串，逗号分隔
    * @return json
    */
    
    // 请求参数
    var pageSize:Int = 6
    var page: Int = 1
    var sightId: Int
    var order: Int?
    var tags: String?
    
    // 初始化方法
    init(sightId: Int, order: Int?, tags: String?) {
        self.sightId = sightId
        self.order = order
        self.tags = tags
    }
    
    // 将数据回调外界
    func fetchTopicPageModels(handler:[TopicDetails] -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: [TopicDetails] -> Void) {
        var post         = [String: String]()
        post["page"]     = String(self.page)
        post["pageSize"] = String(self.pageSize)
        post["sight"]    = String(self.sightId)

        // 发送网络请求加载数据 http://123.57.67.165:8301/api/topic/list?sight=4
        HttpRequest.ajax(AppIniOnline.BaseUri,
            path: "/api/topic/list",
            post: post,
            handler: {(respData: AnyObject) -> Void in

                var topicDetails = [TopicDetails]()
                for item in respData as! NSArray {
                    print(item)
                    let td = TopicDetails(dict: item as! [String : AnyObject])
                    // 转换话题详情元素

                    
//                    let tags = NSMutableArray()
//                    for it in item["tags"] as! NSArray {
//                        tags.addObject(it)
//                    }
//                    td.tags = tags
                    topicDetails.append(td)
                }
                // 回调
                handler(topicDetails)
            }
        )
    }
}
