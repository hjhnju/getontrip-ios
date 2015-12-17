//
//  Landscape.swift
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
            imageHeader = UIKitTools.sliceImageUrl(image, width: Int(UIScreen.mainScreen().bounds.width), height: 140)
        }
    }
    
    var imageHeader: String = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}