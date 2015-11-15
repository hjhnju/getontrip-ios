//
//  Book.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/4.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 书籍详情
class Book: NSObject {
    /// id
    var id: String = ""
    /// 标题
    var title: String = ""
    /// 图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 142, height: 181)
        }
    }
    /// 内容摘要
    var abstract: String = ""
    /// 内容
    var content_desc: String = ""
    /// 京东购买url
    var url: String = ""
    /// 作者
    var author: String = ""
    /// 作者加出版等信息，例：作者/出版社/等
    var info: String = ""
    /// 收藏数
    var collected: String = ""
    
    init(id: String){
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
