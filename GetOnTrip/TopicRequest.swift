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
    var pageSize:Int
    var page: Int
    var sightId: Int
    var order: Int?
    var tags: String?
    
    // 初始化方法
    init(pageSize: Int, page: Int, sightId: Int, order: Int?, tags: String?) {
        self.pageSize = pageSize
        self.page = page
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
        post["order"]    = String(stringInterpolationSegment: self.order)
        post["tags"]     = String(stringInterpolationSegment: self.tags)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/topic/list",
            post: post,
            handler: {(respData: JSON) -> Void in
                var topicDetails = [TopicDetails]()
                for item in respData.arrayValue {
                    // 转换话题详情元素
                    let from     = item["from"].stringValue
                    let subtitle = item["subtitle"].stringValue
                    let id       = item["id"].intValue
                    let title    = item["title"].stringValue
                    let collect  = item["collect"].intValue
                    let image    = item["image"].stringValue
                    let visit    = item["visit"].intValue
                    let desc     = item["desc"].stringValue
                    let tag      = item["tags"].intValue
                    
                    let topicDetail = TopicDetails(from: from, subtitle: subtitle, id: id, title: title, collect: collect, image: image, visit: visit, desc: desc, tags: tag)
                    topicDetails.append(topicDetail)
                }
                // 回调
                handler(topicDetails)
            }
        )
        
    }

    
    
    /**
    * 接口1：/api/topic/detail
    * 话题详情页接口
    * @param integer topicId，话题ID
    * @param string  deviceId，用户的设备ID（因为要统计UV）
    * @return json
    */
    
    
    /*   话题详情页
    var uuid = SSKeychain.passwordForService(NSBundle.mainBundle().bundleIdentifier, account: "uuid")
    
    print("---------\(uuid)------------")
    
    
    if (uuid == nil) {
    uuid = NSUUID().UUIDString
    SSKeychain.setPassword(uuid, forService: NSBundle.mainBundle().bundleIdentifier, account: "uuid")
    }
    
    print("---------\(NSUUID().UUIDString)------------")
    
    
    var post     = [String:String]()
    post["topicId"] = String(stringInterpolationSegment: sight.topics[indexPath.row].topicid)
    
    print("+++++++++++\(String(stringInterpolationSegment: sight.topics[indexPath.row].topicid))++++++++++++")
    
    
    post["deviceId"] = uuid
    HttpRequest.ajax(AppIni.BaseUri, path: "/api/topic/detail",
    post: post,
    handler: {(respData: JSON) -> Void in
    print("=================\n")
    print("\(respData)")
    print("=================\n")
    })
    */
}
