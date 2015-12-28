//
//  MyPraiseRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class MyPraiseRequest: NSObject {
    
    // 请求参数
    var page    : Int = 1
    var pageSize: Int = 6
    
    func fetchNextPageModels(handler: ([CollectContent]?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: ([CollectContent]?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }
    
    // 异步加载话题获取数据
    func fetchModels(handler: ([CollectContent]?, Int) -> Void) {
        var post       = [String: String]()
        post["page"]   = String(page)
        post["pageSize"] = String(pageSize)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/praise/list", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {

                var praises = [CollectContent]()
                for it in result.arrayValue {
                    if let item = it.dictionaryObject {
                        let col = CollectContent(dict: item)
                        praises.append(col)
                        col.praise = item["praisenum"] as? String ?? ""
                        col.visit = item["visitnum"] as? String ?? ""
                    }
                }
                handler(praises, status)
            } else {
                handler(nil, status)
            }
        }
    }
    
}
