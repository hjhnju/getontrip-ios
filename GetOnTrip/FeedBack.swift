//
//  FeedBack.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class FeedBack: NSObject {
   
    /// 用户id
    var userid: String
    
    /// 内容
    var content: String
    
    /// 状态
    var status: String
    
    /// id
    var id: String
    
    /// 更新时间
    var update_time: String
    
    /// 处理时间
    var deal_time: String
    
    /// 创建时间
    var create_time: String
    
    /// 是否显示时间
    var showTime: Bool = true
    
    init(userid: String, content: String, status: String, id: String, update_time: String, deal_time: String, create_time: String) {
        self.userid = userid
        self.content = content
        self.status = status
        self.id     = id
        self.update_time = update_time
        self.deal_time   = deal_time
        self.create_time = create_time
    }
}
