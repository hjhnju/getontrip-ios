//
//  CyclopaedicLabel.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/19.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class CyclopaedicLabel: NSObject {
    
    // 标签位置
    var id: Int?
    
    // 标签名称
    var name: String?
    
    // 标签路径
    var url: String?
    
    // 标签时间(暂未使用)
    var create_time: Int?
    
    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
