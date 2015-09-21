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
    var id: Int?
    // 价格京东现价
    var price_jd: String?
    // 页数
    var pages: Int?
    // 作者
    var author: String?
    // 描述
    var content_desc: String?
    // 原价
    var price_mart: Double?
    // 购买网络路径
    var url: String?
    // 图书编号
    var isbn: Int?
    // 标题
    var title: String?
    // 图片
    var image: String?
    // 出版社
    var press: String?
    // 所有图书
    var totalNum: Int?
    // 创建时间
    var create_time: Int?
    // 图书状态
    var status: Int?

    
    // 初始化方法
    init(dict: [String : AnyObject]) {
        super.init()
        print(dict)
        
        setValuesForKeysWithDictionary(dict)
        
        create_time = Int(dict["create_time"] as! String)!
        id = Int(dict["id"] as! String)!
        isbn = Int(dict["isbn"] as! String)!
        pages = dict["pages"] as? Int
        price_mart = dict["price_mart"]! as? Double
        url = String(dict["url"])
        totalNum = dict["totalNum"]! as? Int
        status = Int(dict["status"] as! String)!
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}
