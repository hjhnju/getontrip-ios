//
//  CityBrowseRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CityBrowseRequest: NSObject {
    
    // 请求参数
    var order   : String = "1"
    
    func fetchNextPageModels(handler: (NSDictionary?, Int) -> Void) {
        return fetchModels(handler)
    }
    
    // 异步加载获取数据
    private func fetchModels(handler: (NSDictionary?, Int) -> Void) {
        var post         = [String: String]()
//        post["order"]    = String(order)
        
        // 发送网络请求加载数据                      /api/city/list
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/city/list", post: post) { (result, status) -> () in
            print(result)
            if status == RetCode.SUCCESS {
                // 回调
//                handler(self.dataWithModel(data), status)
                var data = [[String : AnyObject]]()
                for item in result.dictionaryObject! {
                    print(item)
                }
                
                
                return
            }
            handler(nil, status)
        }
    }
}
