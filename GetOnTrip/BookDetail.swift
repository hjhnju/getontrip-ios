//
//  BookDetail.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/4.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 书籍详情
class BookDetail: NSObject {
    /// id
    var id: String = ""
    /// 标题
    var title: String = ""
    /// 内容
    var content_desc: String = ""
    /// 图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 142, height: 181)
        }
    }
    /// 京东购买url
    var url: String = ""
    /// 书籍信息例：作者
    var info: String = ""
    /// 收藏数
    var collected: String = ""
    
    init(dict: [String: AnyObject]?) {
        super.init()
        if let dict = dict {
            setValuesForKeysWithDictionary(dict)
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
