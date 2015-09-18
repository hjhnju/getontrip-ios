
//
//  CityCenterRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/9.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class CityCenterRequest: NSObject {
    /**
    * 接口2：/api/city/detail
    * 获取城市信息，供城市中间页使用
    * @param integer cityId,城市ID
    * @return json
    */
    
    // 请求参数
    var cityId : Int
    
    init(cityId: Int) {
        self.cityId = cityId
    }
    
    /// 将收藏景点数据回调外界
    func fetchCityCenterModels(handler: [CityCenter] -> Void) {
        fetchSightModels(handler)
    }

    // 异步加载景点获取数据
    func fetchSightModels(handler: [CityCenter] -> Void) {
        var post       = [String: String]()
        post["cityId"] = String(2)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/city/detail",
            post: post,
            handler: {(respData: NSArray) -> Void in

                var collectSightM = [CityCenter]()
                    for it in respData {
                        
                        let collectM = CityCenter(dict: it as! [String : String])
//                        collectM.id = it["id"].intValue
//                        collectM.name = it["name"].stringValue
//                        collectM.topics = it["topics"].stringValue
//                        collectM.collect = it["collect"].stringValue
                        collectM.image = AppIni.BaseUri + String(it["image"])
                        collectSightM.append(collectM)
                    }
                    
                    // 回调
                    handler(collectSightM)
            }
        )
    }
}

