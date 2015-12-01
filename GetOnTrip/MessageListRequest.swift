//
//  MessageListRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class MessageListRequest: NSObject {
    
    
    // 请求参数
    var pageSize :Int = 10
    var page     :Int = 1
    
    
    func fetchNextPageModels(handler: ([MessageList]?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: ([MessageList]?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }
    
    // 删除消息
    class func deleteMessage(mid: String, handler: (AnyObject?, Int) -> Void) {
        var post = [String : String]()
        post["mid"] = mid
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/msg/del", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                handler(result.object, status)
                return
            }
            handler(nil, status)
        }
    }
    
    // 异步加载获取数据
    private func fetchModels(handler: ([MessageList]?, Int) -> Void) {
        var post         = [String: String]()
        post["pageSize"] = String(self.pageSize)
        post["page"]     = String(self.page)
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/msg/list", post: post) { (result, status) -> () in
            
            if status == RetCode.SUCCESS {

                var messageLists = [MessageList]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        messageLists.append(MessageList(dict: item))
                    }
                }
                handler(messageLists, status)
                return
            }
            handler(nil, status)
        }
    }
}
