//
//  Cyclopaedic.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/18.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class Cyclopaedic: NSObject {
    
    // 百科状态
    var status: Int?
    
    // 百科内容
    var content: String?
    
    // 百科标题
    var title: String?
    
    // 百科图片
    var image: String?
    
    // 百科时间(和标签内的时间一致,目前看不出什么用法)
//    var create_time: Int
    
    // 百科标签
    var items:[CyclopaedicLabel]?
    
    // url路径
    var url: String?
    
    // 初始化方法
    init(dict: [String: String]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

}
