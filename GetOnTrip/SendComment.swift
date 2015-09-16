//
//  SendComment.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SendComment: NSObject {
   
    // 照片
    var avatar: String?
    // 内容
    var content: String?
    // id
    var id: Int?
    // 评论
    var subComment: [SendComment_SubComment]
    // 评论者
    var to_name: String?
    // 评论时间 
    var create_time: String?
    // 被评论者
    var from_name: String?
    
    init(avatar: String, content: String, id: Int, subComment: [SendComment_SubComment], to_name: String, create_time: String, from_name: String) {
        self.avatar      = avatar
        self.content     = content
        self.id          = id
        self.subComment  = subComment
        self.to_name     = to_name
        self.create_time = create_time
        self.from_name   = from_name
    }
    
}


class SendComment_SubComment: NSObject {
    
    // id
    var id: Int?
    // 内容
    var content: String?
    // 被评论者
    var from_name: String?
    // 评论者
    var to_name: String?
    
    init(id: Int, content: String, from_name: String, to_name: String) {
        self.id        = id
        self.content   = content
        self.from_name = from_name
        self.to_name   = to_name
    }
}