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
    var id: Int?
    
    //景点名称
    var name:String?
    
    //景点图片url
    var image:String?
    
    //景点距离
    var dis: String?
    
    //描述
    var describe: String?
    
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
    var topic: [Topic]?
    
    init(dict: [String : AnyObject]) {
        super.init()

        setValuesForKeysWithDictionary(dict)
        
        id = dict["id"] as? Int
        city_id = dict["city_id"] as? Int
        
        topic = [Topic]()
        for tp in dict["topic"] as! NSArray {
            topic?.append(Topic(dict: tp as! [String : AnyObject]))
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
//    init(sightid:Int, name:String){
//        self.sightid = sightid
//        self.name = name
//    }
}