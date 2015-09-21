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
    var id: String?
    
    //标题
    var title: String?
    
    //副标题
    var subtitle: String?
    
    //图片
    var image: String?
    
    //收藏
//    var favorites:Int?
    var collect: Int?
    
    //浏览
    var visit: Int?
    
    //描述
    var desc:String?
    
    //来自
    var from:String?
    
    //景点名
    var sight:String?
    
    //景点所属城市
    var city:String?
    
    //距离
    var dist:String?
    
    // 评论个数
    var comment: String?
    
    // 标签
    var tags: NSArray?

    init(dict: [String : AnyObject]) {
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