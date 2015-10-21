//
//  SightBookDetailRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/14.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SightBookDetailRequest: NSObject {
    
    /**
    * 接口2:/api/book/detail
    * 书籍详情接口
    * @param integer book,书籍ID
    * @return json
    */
    
    // 请求参数
    var book :String?
    
    // 将数据回调外界
    func fetchTopicDetailModels(handler: BookDetail -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: BookDetail -> Void) {
        var post         = [String: String]()
        post["book"]  = String(book!)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/book/detail",
            post: post,
            handler: {(respData: AnyObject) -> Void in
                // 回调
                handler(BookDetail(dict: respData as! [String : AnyObject]))
            }
        )
    }
}

/// 书籍详情
class BookDetail: NSObject {
    /// id
    var id: String?
    /// 标题
    var title: String?
    /// 内容
    var content_desc: String?
    /// 图片
    var image: String? {
        didSet {
            image = AppIni.BaseUri + image!
        }
    }
    /// 京东购买url
    var url: String?
    /// 书籍信息例：作者
    var info: String?
    /// 收藏数
    var collected: String?
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
