//
//  City.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/16.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class City: NSObject {
    /// id
    var id: String = ""
    /// 城市名
    var name: String = ""
    /// 城市图片
    var image: String = "" {
        didSet {
            image = AppIni.BaseUri + image
        }
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}