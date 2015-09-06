//
//  FeedBack.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class FeedBack: NSObject {
    
    /// 内容
    var content: String
    
    /// id
    var id: Int
    
    /// 是否回复
    var type: Int
    
    /// 创建时间
    var create_time: String
    
    /// 图片
    var image: String
    
    /// 是否显示时间
    var showTime: Bool = true
    
    init(content: String, id: Int, type: Int, image: String, create_time: String) {
        self.content = content
        self.id     = id
        self.create_time = create_time
        self.image = image
        self.type   = type
    }
}
