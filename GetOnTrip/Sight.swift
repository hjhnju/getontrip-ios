//
//  Sight.swift
//  Smashtag
//
//  Created by 何俊华 on 15/7/22.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation

/*
包含一个section的数据：景点介绍 ＋ 2个话题
*/
class Sight : NSObject {
    
    //景点id
    var id:Int?
    
    //景点名称
    var name:String?
    
    //景点图片url
    var image:String?
    
    //景点距离
    var dis:String?
    
    //描述
    var describe:String?
    
    //城市
    var city: String? {
        didSet {
            if city != nil {
                city = "All" + city!
            }
        }
    }
    
    //城市id
    var city_id: Int?
    
    //话题
    var topics: [Topic]?
    
    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
//    init(sightid:Int, name:String){
//        self.sightid = sightid
//        self.name = name
//    }
}