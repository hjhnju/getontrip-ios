//
//  UserUploadInfoRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/10.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class UserUploadInfoRequest: NSObject {
    
    /**
    * 接口4：/api/user/addinfo
    * 用户信息添加接口
    * @param integer userid，用户ID
    * @param integer type,第三方登录类型，1:qq,2:weixin,3:weibo
    * @param string  param,eg: param=nick_name:aa,type:jpg,image:bb,sex:1
    * @return json
    */
    
    // 请求参数
    var userid: Int?
    var type  : Int?
    var param : [[String: String]]?
    var image : String?
    
    init(userid: Int, type: Int, param: [[String: String]]?, image: String) {
        self.userid = userid
        self.type   = type
        self.param  = param
        self.image  = image
//        super.init()
    }
    
    // 将数据回调外界
//    func fetchAddInfoModels(handler: Topic -> Void) {
//        fetchModels(handler)
//    }
//    
//    // 异步加载获取数据
//    func fetchModels(handler: Topic -> Void) {
//        var post       = [String: String]()
//        post["userid"] = String(stringInterpolationSegment: self.userid)
//        post["type"]   = String(stringInterpolationSegment: self.type)
//        post["param"]   = String(stringInterpolationSegment: self.param)
//        post["image"]  = String(stringInterpolationSegment: self.image)
//        // 发送网络请求加载数据
//        HttpRequest.ajax(AppIniOnline.BaseUri,
//            path: "/api/user/addinfo",
//            post: post,
//            handler: {(respData: AnyObject) -> Void in
//
//                let topic = Topic(dict: ["" : ""])
//                // 转换话题详情
////                let id              = respData["id"].intValue
////                let title           = respData["title"].stringValue
////                //topic?.subtitle = respData[""].stringValue
////                topic = Topic(topicid: id, title: title, subtitle: "")
////                topic!.imageUrl     = AppIniOnline.BaseUri + respData["image"].stringValue
////
////                topic!.favorites    = respData["collect"].intValue
////                topic!.visits       = respData["visits"].intValue
////                topic!.desc         = respData["content"].stringValue
////                topic!.from         = respData["from"].stringValue
////                topic!.commentCount = respData["commentNum"].intValue
////                
////                var tags = [String]()
////                for it in respData["tags"].arrayValue {
////                    tags.append(it.stringValue)
////                }
////                topic!.tags = tags
//                // 回调
//                handler(topic)
//            }
//        )
//    }
    
}
