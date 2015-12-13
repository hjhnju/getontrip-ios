//
//  SearchContent.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

struct ContentType {
    static let city: String      = "city"
    static let sight: String     = "sight"
    static let Landscape: String = "landscape"
    static let Topic: String     = "topic"
    static let Book: String      = "book"
    static let Video: String     = "video"
}

/// 搜索结果的内容数据
class SearchContentResult: NSObject {
    
    var search_type: String = ""//ContentType.Topic
    
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

        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}