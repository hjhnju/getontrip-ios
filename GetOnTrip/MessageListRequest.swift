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
    var curPage  :Int = 1
    
    
//    func fetchNextPageModels(handler: ([MessageList]?, Int) -> Void) {
//        page = page + 1
//        return fetchModels(handler)
//    }
//    
//    func fetchFirstPageModels(handler: ([MessageList]?, Int) -> Void) {
//        page = 1
//        return fetchModels(handler)
//    }
    
    
    // 将数据回调外界
    func fetchFeedBackModels(handler: [MessageList] -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: [MessageList] -> Void) {
        var post         = [String: String]()
        post["pageSize"] = String(self.pageSize)
        post["page"]     = String(self.curPage)
        // 发送网络请求加载数据
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/msg/list", post: post) { (result, status) -> () in

            if status == RetCode.SUCCESS {
                if let data = result.array {
                    print(result)
                    var messageLists = [MessageList]()
                    for item in data {
                        if let item = item.dictionaryObject {
                            messageLists.append(MessageList(dict: item))
                        }
                    }
                    handler(messageLists)
                }
            }
            
        }
    }
}


class MessageList: NSObject {
    
    /// 内容
    var content: String = ""
    
    /// 头像
    var avatar: String = "" {
        didSet {
            avatar = UIKitTools.sliceImageUrl(image, width: 35, height: 35)
        }
    }
    
    /// 标题
    var title: String = ""
    
    /// 图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 77, height: 58)
        }
    }
    
    /// 创建时间
    var create_time: String = ""
    
    /// 回复/提问
    var type: String = ""
    
    ///  话题id
    var topicId: String = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
