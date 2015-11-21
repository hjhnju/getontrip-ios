//
//  CommentListRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CommentListRequest: NSObject {
    
    /**
    * 接口1：/api/comment/list
    * 评论列表页
    * @param integer topicId，话题ID
    * @param integer page
    * @param integer pageSize
    * @return json
    */
    
    // 请求参数
    var topicId : String = ""
    var page    : Int = 1
    var pageSize: Int = 6
    
    func fetchNextPageModels(handler: ([Comment]?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: ([Comment]?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: ([Comment]?, Int) -> Void) {
        var post         = [String: String]()
        post["topicId"]  = String(topicId)
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)

        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/comment/list", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var comment = [Comment]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        comment.append(Comment(dict: item))
                    }
                }
                handler(comment, status)
                return
            }
            handler(nil, status)
        }
    }
    
}