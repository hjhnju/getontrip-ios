//
//  CollectSight.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/8.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

/// 景点
class CollectSight: NSObject {
   
    /// 收藏话题id
    var id: Int?
    /// 话题名
    var name: String?
    /// 话题图片
    var image: String?
    /// 共几个话题
    var topicNum: String?
    
    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

/// 话题
class CollectTopic: NSObject {
    /// 收藏话题id
    var id: Int?
    /// 标题
    var title: String?
    /// 收藏数
    var collect: String?
    /// 图片
    var image: String?
    /// 副标题
    var subtitle: String?
    
    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

class CollectMotif: NSObject {
    
    /// 收藏主题id
    var id: Int?
    /// 收藏数
    var collect: String?
    /// 图片
    var image: String?
    /// 主题名字
    var name: String?
    /// 第几期
    var period: String?
    
    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
