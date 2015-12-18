//
//  City.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/16.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class City: ModelObject {
    /// id
    var id: String = ""
    /// 城市名
    var name: String = ""
    /// 城市图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 414, height: 244)
        }
    }
    /// 是否已收藏
    var collected: String = ""
    
    init(id: String) {
        super.init()
        self.id = id
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}