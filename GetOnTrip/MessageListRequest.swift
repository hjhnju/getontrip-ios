//
//  MessageListRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class MessageListRequest: NSObject {
    
    /**
    * 接口1：/api/msg/list
    * 查询消息
    * @param integer page，页码
    * @param integer pageSize，页面大小
    * @param string deviceId,设备ID
    * @return json
    */
    
    // 请求参数
    var deviceId :String = appUUID!
    var pageSize :Int = 6
    var curPage  :Int = 1
    
    // 将数据回调外界
    func fetchFeedBackModels(handler: [MessageList] -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: [MessageList] -> Void) {
        var post         = [String: String]()
        post["deviceId"] = appUUID
        post["pageSize"] = String(self.pageSize)
        post["page"]     = String(self.curPage)
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri, path: "api/msg/list", post: post) { (result, error) -> () in
            if error == nil {
                print(result)
                var messageLists = [MessageList]()
                for item in result as! NSArray {
                    
                    messageLists.append(MessageList(dict: item as! [String : AnyObject]))
                }
                
                // 回调
                handler(messageLists)
            }
        }
    }
}


class MessageList: NSObject {
    
    /// 内容
    var content: String?
    
    /// 头像
    var avatar: String? {
        didSet {
            avatar = AppIni.BaseUri + avatar!
        }
    }
    
    /// 标题
    var title: String?
    
    /// 图片
    var image: String? {
        didSet {
            image = AppIni.BaseUri + image!
        }
    }
    
    /// 创建时间
    var create_time: String?
    
    /// 回复/提问
    var type: String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        
        // TODO: 因为type不是String类型
//        setValuesForKeysWithDictionary(dict)
        content = dict["content"] as? String
        avatar  = dict["avatar"]  as? String
        title   = dict["title"]   as? String
        image   = dict["image"]   as? String
        type    = dict["type"]    as? String
        create_time = dict["create_time"] as? String
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
