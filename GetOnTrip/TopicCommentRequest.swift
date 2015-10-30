//
//  TopicCommentRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/13.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class TopicCommentRequest: NSObject {
    
    /**
    * 接口1：/api/comment/list
    * 评论列表页
    * @param integer topicId，话题ID
    * @param integer page
    * @param integer pageSize
    * @return json
    */
    
    // 请求参数
    var topicId :String?
    var page    :Int = 1
    var pageSize:Int = 6
    
    // 将数据回调外界
    func fetchTopicCommentModels(handler: TopicDetail -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: TopicDetail -> Void) {
        var post         = [String: String]()
        post["topicId"]  = String(topicId!)
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/topic/detail", post: post) { (result, error) -> () in
            
            if error == nil {
                handler(TopicDetail(dict: result as! [String : AnyObject]))
            }
        }
    }
}
