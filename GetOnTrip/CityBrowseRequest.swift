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
    
    func fetchNextPageModels(handler: (CityList?, Int) -> Void) {
        return fetchModels(handler)
    }
    
    // 异步加载获取数据
    private func fetchModels(handler: (CityList?, Int) -> Void) {
        
        // 发送网络请求加载数据                      /api/city/list
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/city/list", post: [String: String]()) { (result, status) -> () in

            if status == RetCode.SUCCESS {
                // 回调
                let cityList = CityList()
                    for (k, v) in result.dictionaryValue {
                        var city = [CityContent]()
                        for item in v.arrayValue {
                            if let item = item.dictionaryObject {
                                city.append(CityContent(dict: item))
                            }
                        }
                        cityList.cityArray[k] = city
                    }
                handler(cityList, status)
                return
            }
            handler(nil, status)
        }
    }
}


class CityList {
    
    static let letterArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "M", "L", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    /// 城市列表
    var cityArray = [String : [CityContent]]()
}

class CityContent: NSObject {
    /// 城市id
    var id: String = ""
    /// 城市名
    var name: String = ""
    /// 城市景点数量
    var sight: String = ""
    /// 城市话题数量
    var topic: String = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}