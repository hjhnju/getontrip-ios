//
//  HomeCityCenterRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CityRequest {
    
    // 请求参数
    var cityId: String     = ""
    
    // 将数据回调外界
    func fetchModels(handler: (Sight?, Int) -> Void) {
        var post      = [String: String]()
        post["city"]  = cityId
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/city", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                if let dict = result.dictionaryObject {
                    let sight = Sight(dict: dict)
                    print(result)
                    handler(sight, status)
                }
                return
            }
            handler(nil, status)
        }
    }
}
