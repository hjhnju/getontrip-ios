//
//  Search.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 搜索结果的城市和景点书籍
class SearchResult: NSObject {
    
    var id: String = ""
    
    var name: String = ""
    
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 52, height: 38)
        }
    }
    
    var desc: String = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
