//
//  SendCommentAddRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/7.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SendCommentAddRequest: NSObject {
    
    /**
    * 接口2：/api/comment/add
    * 添加评论页
    * @param integer topicId,话题ID
    * @param string  deviceId,设备ID
    * @param integer upId,上层评论ID，如果是顶级评论，则可以不传
    * @param integer toUserId,回复给的人。如果是对话题回复，则不传此值
    * @param string content,回复的内容
    * @return json
    */
    
    // 请求参数
    var topicId  :Int
    var deviceId :String = appUUID!
    var upId     :Int?
    var toUserId :Int?
    /// 回复内容
    var content  :String
    
    // 初始化方法
    init(topicId: Int, upId: Int?, toUserId: Int?, content: String) {
        self.topicId = topicId
        self.upId = upId
        self.toUserId = toUserId
        self.content = content
    }
    
    // 将数据回调外界
    func fetchCommentModels(handler: [SendComment] -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: [SendComment] -> Void) {
        var post         = [String: String]()
        post["topicId"]  = String(self.topicId)
        post["deviceId"] = String(self.deviceId)
        post["upId"]     = String(_cocoaString: self.upId! ?? "")
        post["toUserId"] = String(_cocoaString: self.toUserId! ?? "")
        post["content"]  = String(self.content)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/comment/add",
            post: post,
            handler: {(respData: JSON) -> Void in
                println(respData)
                var sendCommentM = [SendComment]()
                
                for item in respData.arrayValue {
                    let avatar  = AppIni.BaseUri + item["avatar"].stringValue
                    let content = item["content"].stringValue
                    let id      = item["id"].intValue
                    let to_name = item["to_name"].stringValue
                    let create_time = item["create_time"].stringValue
                    let from_name = item["from_name"].stringValue
                    
                    var it_subComment = [SendComment_SubComment]()
                    for it in item["subComment"].arrayValue {
                        let it_id = it["id"].intValue
                        let it_content = it["content"].stringValue
                        let it_from_name = it["from_name"].stringValue
                        let it_to_name = it["to_name"].stringValue
                        var itSubcomment = SendComment_SubComment(id: it_id, content: it_content, from_name: it_from_name, to_name: it_to_name)
                        it_subComment.append(itSubcomment)
                    }
                    let sendComment = SendComment(avatar: avatar, content: content, id: id, subComment: it_subComment, to_name: to_name, create_time: create_time, from_name: from_name)
                    sendCommentM.append(sendComment)
                }
                // 回调
                handler(sendCommentM)
            }
        )
    }
}
