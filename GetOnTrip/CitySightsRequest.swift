//
//  CitySightsRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CitySightsRequest: NSObject {
    
    /**
    * 接口3：/api/city/detail
    * 获取城市信息,供城市中间页使用
    * @param integer cityId,城市ID
    * @param integer page,页码
    * @param integer pageSize,页面大小
    * @return json
    */
    
    // 请求参数
    var cityId  : String = ""
    var page    : Int = 1
    var pageSize: Int = 6
    
    /// 将收藏景点数据回调外界
//    func fetchSightCityModels(handler: ([CitySightBrief], Int) -> Void) {
//        fetchSightModels(handler)
//    }
    
    func fetchNextPageModels(handler: ([CitySightBrief]?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: ([CitySightBrief]?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }

    // 异步加载景点获取数据
    func fetchModels(handler: ([CitySightBrief]?, Int) -> Void) {
        var post       = [String: String]()
        post["page"]   = String(page)
        post["pageSize"]=String(pageSize)
        post["cityId"] = String(cityId)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/city/sight", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var sightCityListM = [CitySightBrief]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        let sightM = CitySightBrief(dict: item)
                        sightCityListM.append(sightM)
                    }
                }
                handler(sightCityListM, status)
                return
            }
            handler(nil, status)
        }
    }
}