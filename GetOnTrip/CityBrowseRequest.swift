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
    
    func fetchHotCityModels(handler: (HotCityAndCurrentCity?, Int) -> Void) {
        fetchHotCityModel(handler)
    }
    
    // 异步加载获取数据
    private func fetchModels(handler: (CityList?, Int) -> Void) {
        
        // 发送网络请求加载数据                      /api/city/list
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/city/list", post: [String: String]()) { (result, status) -> () in

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
        
    private func fetchHotCityModel(handler: (HotCityAndCurrentCity?, Int) -> Void) {
        
        var post = [String : String]()
        post["cityid"] = currentCityId
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/city/hot", post: [String : String]()) { (result, status) -> () in

            if RetCode.SUCCESS == status {
                let hotCity = HotCityAndCurrentCity()
                let data = result.dictionaryValue
                
                if let item = data["cityInfo"]?.dictionaryObject {
                    hotCity.currentCity = CityContent(dict: item)
                }
                
                var hotCitys = [HotCity]()
                for item in data["hot"]?.arrayValue ?? [] {
                    if let item = item.dictionaryObject {
                        hotCitys.append(HotCity(dict: item))
                    }
                }
                hotCity.hotCity = hotCitys
                handler(hotCity, status)
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

class HotCityAndCurrentCity {
    
    /// 当前城市信息
    var currentCity: CityContent?
    /// 热门城市
    var hotCity = [HotCity]()
}