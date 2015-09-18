//
//  Topic.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/24.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation

//话题类
// TODO: class Topic :Printable
class Topic : NSObject {
    
    //话题ID
    var topicid:Int?
    
    //标题
    var title:String?
    
    //副标题
    var subtitle:String?
    
    //图片
    var imageUrl:String?
    
    //收藏
    var favorites:Int?
    
    //浏览
    var visits:Int?
    
    //描述
    var desc:String?
    
    //来自
    var from:String?
    
    //景点名
    var sight:String?
    
    //景点所属城市
    var city:String?
    
    //距离
    var distance:String?
    
    var commentCount:Int?
    
    // 标签
    var tags: NSArray?

    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
//    override var description : String {
//        get{
//            return "Topic(\(topicid)"
//        }
//    }
}