//
//  Video.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/21.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class Video: NSObject {
   
    // 视频来源
    var from: String?
    // 状况
    var status: String?
    // 所有视频？
    var totalNum: String?
    // 视频id
    var id: String?
    // 视频长度
    var len: String?
    // 视频标题
    var title: String?
    // 视频图片
    var image: String?
    // 创建时间
    var create_time: String?
    // 类型
    var type: String?
    // 路径
    var url: String?
    
    // 初始化
    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
