//
//  RecommendLabel.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/5.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 搜索标签
class RecommendLabel: NSObject {
    /// id
    var id: String = ""
    /// order
    var order: String = ""
    /// 标签名
    var name: String = ""
    /// 数字
    var num: String = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    func toString() -> String {
        return self.name + "    " + self.num
    }
}