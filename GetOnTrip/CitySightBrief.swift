//
//  CitySightBrief.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/5.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 城市的景点
class CitySightBrief: NSObject {
    
    /// 收藏话题id
    var id: String = ""
    /// 话题名
    var name: String = ""
    /// 话题图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 133, height: 84)
        }
    }
    
    /// 共几个话题
    var topics: String = ""
    /// 是否收藏
    var collected: String = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
