//
//  TopicCommentRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/13.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class TopicCommentRequest: NSObject {
    
    /**
    * 接口1：/api/comment/list
    * 评论列表页
    * @param integer topicId，话题ID
    * @param integer page
    * @param integer pageSize
    * @return json
    */
    
    // 请求参数
    var topicId :String?
    var page    :Int = 1
    var pageSize:Int = 6
    
    // 将数据回调外界
    func fetchTopicCommentModels(handler: TopicDetail -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: TopicDetail -> Void) {
        var post         = [String: String]()
        post["topicId"]  = String(topicId!)
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/topic/detail", post: post) { (result, error) -> () in
            
            if error == nil {
                handler(TopicDetail(dict: result as! [String : AnyObject]))
            }
        }
        
//        HttpRequest.ajax(AppIni.BaseUri,
//            path: "/api/topic/detail",
//            post: post,
//            handler: {(respData: AnyObject) -> Void in
//                print(respData)
//                // 回调  http://123.57.46.229:8301/api/topic/detail?topicId=54&pageSize=6&page=1
////                handler(TopicDetail(dict: respData as! [String : AnyObject]))
//            }
//        )
    }
}

/// 景点列表Tags
//class TopicDetail: NSObject {
//    /// id
//    var id: String?
//    /// 标题
//    var title: String?
//    /// 内容
//    var content: String?
//    /// 图片
//    var image: String? {
//        didSet {
//            image = AppIni.BaseUri + image!
//        }
//    }
//    /// 评论数
//    var commentNum: String?
//    /// 访问数
//    var visit: String?
//    /// 收藏
//    var collect: String?
//    /// 标签
//    var label: String?
//    /// 标题
//    var sight_name: String?
//    
//    init(dict: [String: AnyObject]) {
//        super.init()
//        
//        setValuesForKeysWithDictionary(dict)
//        if dict["tags"] != nil {
//            let lab = dict["tags"] as! NSArray
//            label = lab.firstObject as? String
//        }
//    }
//    
//    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
//        
//    }
//}

