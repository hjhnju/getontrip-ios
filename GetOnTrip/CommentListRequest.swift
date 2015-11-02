//
//  CommentListRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CommentListRequest: NSObject {
    
    /**
    * 接口1：/api/comment/list
    * 评论列表页
    * @param integer topicId，话题ID
    * @param integer page
    * @param integer pageSize
    * @return json
    */
    
    // 请求参数
    var topicId : String = ""
    var page    : Int = 1
    var pageSize: Int = 6
    
    // 将数据回调外界
    func fetchCommentListModels(handler: [CommentList] -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: [CommentList] -> Void) {
        var post         = [String: String]()
        post["topicId"]  = String(topicId)
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)

        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/comment/list", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var comment = [CommentList]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        comment.append(CommentList(dict: item))
                    }
                }
                print(result)
                handler(comment)
            }
        }
    }
    
}

class CommentList: NSObject {
    
    var id:        Int = 0
    
    var content:   String = ""
    
    var to_name:   String = ""
    
    var from_name: String = ""
    
    var create_time: String = ""
    
    var from_user_id: String = ""
    
    var avatar: String = "" {
        didSet {
            avatar = AppIni.BaseUri + avatar
        }
    }
    
    var sub_Comment: [CommentPersonContent] = [CommentPersonContent]()
    
    init(dict: [String: AnyObject]) {
        super.init()
        
//        setValuesForKeysWithDictionary(dict)
        id          = ((dict["id"])?.integerValue)!//         as! String
        avatar      = AppIni.BaseUri + String(dict["avatar"]!)//     as! String
        content     = String(dict["content"]!) //   as! String
        to_name     = String(dict["to_name"]!)//    as! String
        create_time = String(dict["create_time"]!)//as! String
        from_name   = String(dict["from_name"]!)
        from_user_id = String(dict["from_user_id"]!)

        for it in dict["subComment"] as! NSArray {
            sub_Comment.append(CommentPersonContent(dict: it as! [String : AnyObject]))
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}


class CommentPersonContent: NSObject {
    
    var id: String = ""
    
    var content: String = ""
    
    var from_name: String = ""
    
    var to_name: String = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        
//        setValuesForKeysWithDictionary(dict)
        
        id        = String(dict["id"]!)
        content   = String(dict["content"]!)
        from_name = String(dict["from_name"]!)
        to_name   = String(dict["to_name"]!)

    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
