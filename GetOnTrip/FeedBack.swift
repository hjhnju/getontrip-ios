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
    var content: String?
    
    /// id
    var id: Int?
    
    /// 是否回复
    var type: Int?
    
    /// 创建时间
    var create_time: String?
    
    /// 图片
    var image: String?
    
    /// 是否显示时间
    var showTime: Bool = true
    
    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
