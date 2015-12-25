
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
    
    lazy var nick_name: String = ""
    
    var image: String = "" {
        didSet {
            if image != "" {
                image = UIKitTools.sliceImageUrl(image, width: 200, height: 200)
            }
        }
    }
    
    lazy var sex: String = "0"
    
    lazy var city: String = ""
    
    var bakimg: String = "" {
        didSet {
            if bakimg != "" {
                bakimg = UIKitTools.sliceImageUrl(bakimg, width: Int(UIScreen.mainScreen().bounds.width), height: 212)
            }
        }
    }
    
    convenience init(dict: [String : AnyObject]) {
        self.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}