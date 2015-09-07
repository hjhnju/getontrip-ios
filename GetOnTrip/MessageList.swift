//
//  MessageList.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class MessageList: NSObject {
   
    /// 附加？
    var attach: String?
    
    /// 内容
    var content: String?
    
    /// 头像
    var avatar: String?
    
    /// mid
    var mid: Int
    
    /// 标题
    var title: String?
    
    /// 图片
    var image: String?
    
    /// 创建时间
    var create_time: String?
    
    /// 回复/提问
    var type: String?
    
    init(attach: String, content: String, avatar: String, mid: Int, title: String, image: String, create_time: String, type: String) {
        self.attach = attach
        self.content = content
        self.avatar = avatar
        self.mid = mid
        self.title = title
        self.image = image
        self.create_time = create_time
        self.type = type
    }
}
