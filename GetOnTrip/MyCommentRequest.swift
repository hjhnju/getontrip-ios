//
//  MyCommentRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class MyCommentRequest: NSObject {
    // 请求参数
    var page    : Int = 1
    var pageSize: Int = 6
        
    func fetchNextPageModels(handler: ([MyComment]?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: ([MyComment]?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }
    
    /**
     * 接口4：/api/1.0/comment/my
     * 查询我的评论接口
     * @param integer page
     * @param integer pageSize
     * @return json
     */
     
     // 异步加载话题获取数据
    func fetchModels(handler: ([MyComment]?, Int) -> Void) {
        var post         = [String: String]()
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/comment/my", post: post) { (result, status) -> () in

            if status == RetCode.SUCCESS {
                var myComments = [MyComment]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        myComments.append(MyComment(dict: item))
                    }
                }
                handler(myComments, status)
                return
            }
            handler(nil, status)
        }
    }
}

class MyComment: NSObject {
    
    /// 评论id
    var id = ""
    /// 标题
    var title = ""
    /// 来源
    var from = ""
    /// 时间
    var time = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}