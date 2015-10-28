//
//  TopicDetailRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit

class TopicDetailRequest: NSObject {

    /**
    * 接口1：/api/topic/detail
    * 话题详情页接口
    * @param integer topicId，话题ID
    * @param string deviceId，用户的设备ID（因为要统计UV）
    * @return json
    */
    
    // 请求参数
    var topicId :String?
    
    // 将数据回调外界
    func fetchTopicDetailModels(handler: TopicDetail -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: TopicDetail -> Void) {
        var post         = [String: String]()
        post["topicId"]  = String(topicId!)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/topic/detail", post: post) { (result, error) -> () in
            if error == nil {
                if let data = result!["data"] as? [String : AnyObject] {
                    handler(TopicDetail(dict: data))
                }
            }
        }
    }
}

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
    
    init(dict: [String: AnyObject]) {
        super.init()
        
       setValuesForKeysWithDictionary(dict)
        if dict["tags"] != nil {
            let lab = dict["tags"] as! NSArray
            label = (lab.firstObject as? String) ?? ""
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
