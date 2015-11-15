//
//  SearchContent.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 搜索结果的内容数据
class SearchContent: NSObject {
    
    var search_type: String = ""
    
    var id: String = ""
    
    var title: String = ""
    
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 52, height: 38)
        }
    }
    
    var content: String = ""
    
    var url: String = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        // book video keyword
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}