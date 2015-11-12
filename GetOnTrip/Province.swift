//
//  Province.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/24.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

// MARK: - 省市模型
class Province : NSObject {
    
    var name: String = ""
    var city: NSArray = NSArray()
    
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) { }
}