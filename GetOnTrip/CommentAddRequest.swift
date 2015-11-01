//
//  CommentAddRequest.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/30.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class CommentAddRequest: NSObject {
    
    // 将数据回调外界 handler: BookDetail -> Void   handler
    
    ///  发送添加评请求
    ///
    ///  - parameter topicId:  话题id
    ///  - parameter upId:     上层评论id,如果是顶级评论，则传""
    ///  - parameter toUserId: 回复给的人。如果是对话题回复，则不传此值
    ///  - parameter content:  回复的内容
    func fetchAddCommentModels(topicId: String, upId: String, toUserId: String, content: String, handler: AnyObject -> Void) {
        fetchModels(topicId, upId: upId, toUserId: toUserId, content: content, handler: handler)
        
    }
    
    // 异步加载获取数据
    private func fetchModels(topicId: String, upId: String, toUserId: String, content: String, handler: AnyObject -> Void) {
        var post         = [String: String]()
        post["topicId"]  = topicId
        post["upId"]     = upId
        post["toUserId"] = toUserId
        post["content"]  = content
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/comment/add", post: post) { (result, error) -> () in
            if error == nil {
                print(result)
                handler(result!)
            }
        }
    }
}