
//
//  UserInfo.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/3.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 用户信息类
class UserInfo : NSObject {
    
    var nick_name: String = ""
    
    var image: String = "" {
        didSet {
            image = AppIni.BaseUri + image
        }
    }
    
    var sex: String = ""
    
    /// 自己添加的不是后端返回的数据，用于判断此用户是否是后台记录在册的用户,记录在册为1
    var type: String = "1"
    
    var city: String = ""
    
    convenience init(dict: [String : AnyObject]) {
        self.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}