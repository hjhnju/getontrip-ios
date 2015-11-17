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
    var pageSize :Int = 6
    var page  :Int = 1
    
    
    func fetchNextPageModels(handler: ([MessageList]?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: ([MessageList]?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }
    
    
    // 将数据回调外界
//    func fetchFeedBackModels(handler: [MessageList] -> Void) {
//        fetchModels(handler)
//    }
    
    // 异步加载获取数据
    func fetchModels(handler: ([MessageList]?, Int) -> Void) {
        var post         = [String: String]()
        post["pageSize"] = String(self.pageSize)
        post["page"]     = String(self.page)
        // 发送网络请求加载数据
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/msg/list", post: post) { (result, status) -> () in
            
            if status == RetCode.SUCCESS {
                print(result)
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
