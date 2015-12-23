//
//  FeedbackListRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/1.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class FeedbackRequest: NSObject {
    
    // 请求参数
    var page    : Int = 1
    var pageSize: Int = 6
    
    func fetchListNextPageModels(handler: ([Feedback]?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchListFirstPageModels(handler: ([Feedback]?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }
    
    func fetchModels(handler: ([Feedback]?, Int) -> Void) {
        var post = [String : String]()
        post["page"] = String(page)
        post["pageSize"] = String(pageSize)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/advise/list", post: [String: String]()) { (result, status) -> () in
            if status == RetCode.SUCCESS {
               print(result)
                var feedbacks = [Feedback]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        feedbacks.append(Feedback(dict: item))
                    }
                }
                handler(feedbacks, status)
                return
            }
            handler(nil, status)
        }
        
    }
    
    func fetchSendModels(advise: String, handler:(String?, Int) -> Void) {
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/advise/add", post: ["advise" : advise]) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                if let data = result.string {
                    handler(data, status)
                }
                return
            }
            handler(nil, status)
        }
    }
}

class Feedback: NSObject {
    
    /// id
    lazy var id = ""
    /// 内容
    lazy var content = ""
    /// 类型
    lazy var type = ""
    /// 图片
    var image = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 35, height: 35)
        }
    }
    /// 创建时间
    lazy var create_time = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}