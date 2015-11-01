//
//  SightBookDetailRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/14.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class BookRequest: NSObject {
    
    /**
    * 接口2:/api/book/detail
    * 书籍详情接口
    * @param integer book,书籍ID
    * @return json
    */
    
    // 请求参数
    var book :String?
    
    // 将数据回调外界
    func fetchTopicDetailModels(handler: (BookDetail?, Int) -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: (BookDetail?, Int) -> Void) {
        var post         = [String: String]()
        post["book"]  = String(book!)
        
        // 发送网络请求加载数据
        /*HttpRequest.ajax(AppIni.BaseUri, path: "/api/book/detail", post: post) { (result, error) -> () in
            if error == nil {
                handler(BookDetail(dict: result!["data"] as! [String : AnyObject]))
            }
        }*/
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/book", post: post) { (result, status) -> Void in
            if status == RetCode.SUCCESS {
                handler(BookDetail(dict: result.dictionaryObject), status)
                return
            }
            handler(nil, status)
            
        }
    }
}

/// 书籍详情
class BookDetail: NSObject {
    /// id
    var id: String = ""
    /// 标题
    var title: String = ""
    /// 内容
    var content_desc: String = ""
    /// 图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 142, height: 181)
        }
    }
    /// 京东购买url
    var url: String = ""
    /// 书籍信息例：作者
    var info: String = ""
    /// 收藏数
    var collected: String = ""
    
    init(dict: [String: AnyObject]?) {
        super.init()
        if let dict = dict {
            setValuesForKeysWithDictionary(dict)
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
