//
//  TopicDetail.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/1.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 话题详情
class Topic: NSObject {
    
    static func fromBrief(brief:TopicBrief) -> Topic {
        let topic:Topic = Topic()
        topic.id    = brief.id
        topic.image = brief.image
        topic.subtitle = brief.subtitle
        topic.sight = brief.sight
        topic.title  = brief.title
        topic.tagname = brief.tagname
        topic.visit = brief.visit
        topic.collect = brief.collect
        topic.sightid = brief.sightid
        topic.sight   = brief.sight
        return topic
    }
    
    /// id
    var id: String = ""
    /// 标题
    var title: String = ""
    /// 分享副标题
    var subtitle: String = ""
    /// 图片
    var image: String = "" {
        didSet{
            image = UIKitTools.sliceImageUrl(image, width: 414, height: 267)
        }
    }
    /// 访问数
    var visit: String = ""
    /// 收藏
    var collect: String = ""
    /// 标签
    var tagname: String = ""
    /// 景点ID
    var sightid: String = ""
    /// 景点
    var sight: String = ""

    /// 内容
    var content: String = ""
    /// 内容url
    var contenturl: String = ""
    /// 分享url
    var shareurl: String = ""
    /// 评论数
    var commentNum: String = ""
    //显示评论
    var comment:String {
        return self.commentNum + "条评论"
    }
    /// 当前用户是否已收藏
    var collected: String = ""
    
    /// 是否点过赞
    var praised: String = ""
    /// 点赞数量
    var praiseNum: String = ""
    
    var arrsight = [[String : String]]()
    
    override init(){
        
    }
    
    init(id: String){
        super.init()
        self.id = id
    }

    init(dict: [String: AnyObject]) {
        super.init()

        setValuesForKeysWithDictionary(dict)
        if dict["tags"] != nil {
            let lab = dict["tags"] as? NSArray
            tagname = (lab?.firstObject as? String) ?? ""
        }
        print(dict["arrsights"])
        if dict["arrsights"] != nil {
            if let dict = dict["arrsights"] {
                for item in dict as? [[String : String]] ?? [[String : String]]() {
                    arrsight.append(item)
                }
            }
           
        }
    }

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    /// 是否属于某个景点
    func isInSomeSight() -> Bool {
        if self.sightid == "" || self.sightid == "0" {
            return false
        }
        return true
    }
}
