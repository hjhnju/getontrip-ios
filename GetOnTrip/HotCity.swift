//
//  HotCity.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/19.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class HotCity: NSObject {
    
    /// 城市id
    lazy var id    = ""
    /// 城市景点
    lazy var sight = ""
    /// 城市话题数量
    lazy var topic = ""
    /// 城市名
    lazy var name  = ""
    /// 城市图片
    lazy var image = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
