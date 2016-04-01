//
//  CityBrowseRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CityBrowseRequest: NSObject {
    
    // 请求参数 1是国内， 0是海外
    var type  : String = "1"
    
    func fetchNextPageModels(handler: (CityList?, Int) -> Void) {
        return fetchModels(handler)
    }
    
    func fetchHotCityModels(handler: ([HotCity]?, Int) -> Void) {
        fetchHotCityModel(handler)
    }
    
    // 异步加载获取数据
    private func fetchModels(handler: (CityList?, Int) -> Void) {
        
        // 发送网络请求加载数据   
        
        var post = [String : String]()
        post["type"] = type
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/city/list", post: post) { (result, status) -> () in
            
            if status == RetCode.SUCCESS {
                // 回调
                let cityList = CityList()
                let data = result.dictionaryValue.sort({ (obj1, obj2) -> Bool in
                    obj1.0 < obj2.0
                })
                
                    for (k, v) in data {
                        var city = [CityContent]()
                        for item in v.arrayValue {
                            if let item = item.dictionaryObject {
                                city.append(CityContent(dict: item))
                            }
                        }
                        cityList.keys.append(k)
                        cityList.values.append(city)
                    }
                handler(cityList, status)
                return
            }
            handler(nil, status)
        }
    }
        
    private func fetchHotCityModel(handler: ([HotCity]?, Int) -> Void) {
        
        var post = [String : String]()
        post["type"] = type
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/city/hot", post: post) { (result, status) -> () in

            if RetCode.SUCCESS == status {
                let data = result.dictionaryValue
                
                var hotCitys = [HotCity]()
                for item in data["hot"]?.arrayValue ?? [] {
                    if let ite = item.dictionaryObject {
                        hotCitys.append(HotCity(dict: ite))
                    }
                }
                handler(hotCitys, status)
                return
            }
            handler(nil, status)
        }
    }
    
}


class CityList {
    
    var keys = [String]()
    
    var values = [[CityContent]]()
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
    /// 所在的key
    var key: String = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
