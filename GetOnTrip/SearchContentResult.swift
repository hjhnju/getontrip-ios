//
//  SearchContent.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

struct ContentType {
    static let Landscape: String = "keyword"
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
        // book video keyword
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
//    func isLandscape() -> Bool {
//        if self.search_type == ContentType.Landscape {
//            return true
//        }
//        return false
//    }
//    
//    func isVideo() -> Bool {
//        if self.search_type == ContentType.Video {
//            return true
//        }
//        return false
//    }
//    
//    func isBook() -> Bool {
//        if self.search_type == ContentType.Book {
//            return true
//        }
//        return false
//    }
//    
//    func isTopic() -> Bool {
//        if self.search_type == ContentType.Topic {
//            return true
//        }
//        return false
//    }

}