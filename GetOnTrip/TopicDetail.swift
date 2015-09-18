//
//  TopicDetail.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/26.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class TopicDetail: NSObject {
   
    // 来源
    var from: String?
    
    var content: String?
    
    var id: Int?
    
    var title: String?
    
    var image: String?
    
    var dis: String?
    
    var collect: String?
    
    var visit: String?
    
    var commentNum: String?
    
    var tags: [String]?
    
    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
//    init(from: String, content: String, id: Int, title: String, image:String, dis: String, collect: String, visit: String, commentNum: String, tags: [String]) {
//        
//        self.from       = from
//        self.content    = content
//        self.id         = id
//        self.title      = title
//        self.image      = image
//        self.dis        = dis
//        self.collect    = collect
//        self.visit      = visit
//        self.commentNum = commentNum
//        self.tags       = tags
//    }
    
}
