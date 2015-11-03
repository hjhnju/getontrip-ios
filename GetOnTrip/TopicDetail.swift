//
//  TopicDetail.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/1.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 话题详情
class TopicDetail: NSObject {
    /// id
    var id: String = ""
    /// 标题
    var title: String = ""
    /// 内容
    var content: String = ""
    /// 图片
    var image: String = "" {
        didSet {
            image = AppIni.BaseUri + image
        }
    }
    /// 评论数
    var commentNum: String = ""
    //显示评论
    var comment:String {
        return self.commentNum + "条评论"
    }
    
    /// 访问数
    var visit: String = ""
    /// 收藏
    var collect: String = ""
    /// 标签
    var label: String = ""
    /// 景点
    var sight_name: String = ""
    /// 当前用户是否已收藏
    var collected: String = ""
    /// 分享副标题
    var subtitle: String = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        if dict["tags"] != nil {
            let lab = dict["tags"] as? NSArray
            label = (lab?.firstObject as? String) ?? ""
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
