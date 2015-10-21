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
    var cityId  :String?
    var page    : Int = 1
    var pageSize: Int = 6
    
    /// 将收藏景点数据回调外界
    func fetchSightCityModels(handler: [CitySightBrief] -> Void) {
        fetchSightModels(handler)
    }

    // 异步加载景点获取数据
    func fetchSightModels(handler: [CitySightBrief] -> Void) {
        var post       = [String: String]()
        post["page"]   = String(page)
        post["pageSize"]=String(pageSize)
        post["cityId"] = String(cityId!)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/city/sight",
            post: post,
            handler: {(respData: AnyObject) -> Void in
                
                var sightCityListM = [CitySightBrief]()
                for it in respData as! NSArray {
                    
                    let sightM = CitySightBrief(dict: it as! [String : String])
                    
                    sightCityListM.append(sightM)
                }
                
                // 回调
                handler(sightCityListM)
            }
        )
    }

}


/// 城市的景点
class CitySightBrief: NSObject {
    
    /// 收藏话题id
    var id: String = ""
    /// 话题名
    var name: String = ""
    /// 话题图片
    var image: String = "" {
        didSet {
            let mp = AppIni.ImageSliceMultipler
            image = AppIni.BaseUri + image + "@\(133*mp)w_\(84*mp)h"
        }
    }
    
    /// 共几个话题
    var topics: String = ""
    /// 是否收藏
    var collected: String = ""
    
    init(dict: [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
