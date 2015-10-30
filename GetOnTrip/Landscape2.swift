//
//  Landscape2.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/30.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 景点景观Cell数据
class Landscape: NSObject {
    /// id
    var id: String = ""
    ///  标题名称
    var name: String = ""
    ///  副标题内容
    var content: String = ""
    ///  url
    var url: String = ""
    /// 图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 119, height: 84)
        }
    }
    /// 目录
    var catalogs: NSMutableArray?
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        catalogs = NSMutableArray()
        for item in dict["catalog"] as! NSArray {
            
            var text = NSString(string: item["name"] as! String).substringWithRange(NSMakeRange(0, 4))
            if text.containsString("\r\n") {
                let range = text.rangeOfString("\r\n")
                text.removeRange(range!)
            }
            catalogs!.addObject(text)
        }
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}