//
//  Book.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/20.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class Book: NSObject {
    
    // 图书id
    var id: String?
    // 价格京东现价
    var price_jd: String?
    // 页数
    var pages: String?
    // 作者
    var author: String?
    // 描述
    var content_desc: String?
    // 原价
    var price_mart: String?
    // 购买网络路径
    var url: String?
    // 图书编号
    var isbn: String?
    // 标题
    var title: String?
    // 图片
    var image: String?
    // 出版社
    var press: String?
    // 所有图书
    var totalNum: String?
    // 创建时间
    var create_time: String?
    // 图书状态
    var status: String?

    
    // 初始化方法
    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}
