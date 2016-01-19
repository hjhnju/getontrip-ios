//
//  FoodRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/19.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class FoodRequest: NSObject {
    
    // 请求参数
    var foodId : String = ""
    
    // 异步加载获取数据
    func fetchModels(handler: (result: FoodDetail?, status: Int?) -> Void) {
        var post         = [String: String]()
        post["id"]  = String(foodId)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/food", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                if let dict = result.dictionaryObject {
                    handler(result: FoodDetail(dict: dict), status: status)
                    return
                }
                handler(result: nil, status: status)
            }
        }
    }
}
