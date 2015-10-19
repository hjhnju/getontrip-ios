//
//  Topic.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/16.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class BriefTopic : NSObject {
    /// id
    var id: String = ""
    /// 标题
    var title: String = ""
    /// 副标题
    var subtitle: String = ""
    /// 访问数
    var visit: String = ""
    /// 收藏数
    var collect: String = ""
    /// 图片
    var image: String = "" {
        didSet {
            image = AppIni.BaseUri + image
        }
    }
    /// 标签
    var tag: String = ""
    //所属景点
    var sight: String = ""
    
    init(dict: [String: String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}