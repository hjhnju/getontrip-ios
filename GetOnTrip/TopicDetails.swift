//
//  TopicDetails.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/19.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class TopicDetails : NSObject {
   
    /// 话题详情来源
    var from: String?
    
    /// 子标题
    var subtitle: String?
    
    /// id
    var id: Int?
    
    /// 标题
    var title: String?
    
    /// 收集
    var collect: String?
    
    /// 图片
    var image: String?
    
    /// 访问
    var visit: Int?
    
    /// 描述
    var desc: String?
    
    /// 标签
    var tags: NSArray?
    
    /// 初始化
    init(dict: [String : AnyObject]) {
       super.init()
        setValuesForKeysWithDictionary(dict)
        visit = Int(dict["visit"] as! String)
        // TODO: ----- 标签未加
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
//    init(from: String, subtitle: String, id: Int, title: String, collect: String, image: String, visit: Int, desc: String, tags: NSArray) {
//        
//        self.from     = from
//        self.subtitle = subtitle
//        self.id       = id
//        self.title    = title
//        self.collect  = collect
//        self.image    = image
//        self.visit    = visit
//        self.desc     = desc
//        self.tags     = tags
//    }
    
}
