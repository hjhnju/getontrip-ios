//
//  Sight.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/16.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class Sight: NSObject {
    /// id
    var id: String = ""
    /// 景点名
    var name: String = ""
    /// 景点图片
    var image: String = "" {
        didSet {
            image = AppIni.BaseUri + image
        }
    }
    /// 景点内容
    var desc: String = ""
    /// 景点标签
    var tags: [Tag] = [Tag]()
    
    override init(){
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
        tags.removeAll()
        if let taglist = dict["tags"] as? NSArray {
            for item in taglist {
                if let dic = item as? [String : AnyObject] {
                    tags.append(Tag(dict: dic))
                }
            }
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}