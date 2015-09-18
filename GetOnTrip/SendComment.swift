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
    var subComment: [SendComment_SubComment]?
    // 评论者
    var to_name: String?
    // 评论时间 
    var create_time: String?
    // 被评论者
    var from_name: String?
    
    init(dict: [String: String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
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
    
    init(dict: [String: String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}