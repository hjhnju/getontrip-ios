//
//  SightTags.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/30.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 景点列表Tags
class Tag: NSObject {
    /// 话题tagid
    var id: String = ""
    /// 类型
    var type: String = ""
    /// 标签名字
    var name: String = ""
    
    /// 所属景点id
    var sightId: String = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
}