//
//  SendCommentRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SendCommentRequest: NSObject {
    /**
    * 接口1：/api/comment/list
    * 评论列表页
    * @param integer topicId，话题ID
    * @param integer page
    * @param integer pageSize
    * @return json
    */
    
    // 请求参数
    var topicId  :Int
    var pageSize:Int = 6
    var curPage:Int = 1
    
    // 初始化方法
    init(topicId: Int) {
        self.topicId = topicId
        
    }
    
    // 将数据回调外界
    func fetchCommentModels(handler: [SendComment] -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: [SendComment] -> Void) {
        var post         = [String: String]()
        post["topicId"]  = String(self.topicId)
        post["page"]     = String(self.curPage)
        post["pageSize"] = String(self.pageSize)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/comment/list",
            post: post,
            handler: {(respData: AnyObject) -> Void in

                var sendCommentM = [SendComment]()
               
                for item in respData as! NSArray {
                    let sendComment = SendComment(dict: item as! [String : String])
                    sendComment.avatar  = AppIni.BaseUri + String(item["avatar"])

                    var it_subComment = [SendComment_SubComment]()
                    for it in (item["subComment"] as? NSArray)! {
                        
                        let itSubcomment = SendComment_SubComment(dict: it as! [String : String])
                        it_subComment.append(itSubcomment)

                    }
                    sendCommentM.append(sendComment)
                }
                // 回调
                handler(sendCommentM)
            }
        )
    }
}
