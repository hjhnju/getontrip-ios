//
//  Sight.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/16.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class Sight: NSObject {
    /// id
    var id: String = ""
    /// 景点名
    var name: String = ""
    /// 景点图片
    var image: String = "" {
        didSet {
            image = AppIni.BaseUri + image
        }
    }
    /// 景点内容
    var desc: String = ""
    
    init(dict: [String: String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}