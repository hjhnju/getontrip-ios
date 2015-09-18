//
//  CityCenter.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/9.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class CityCenter: NSObject {
    
    /// 城市id
    var id: Int?
    /// 话题数量
    var topics: String?
    /// 景点名字
    var name: String?
    /// 景点图片
    var image: String?
    /// 是否收藏
    var collect: String?
    
    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
