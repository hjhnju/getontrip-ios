//
//  LocateToCity.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/12.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import CoreLocation

/// 用位置换取城市
class LocateToCity: NSObject {
    
    /**
    * 接口5：/api/city/locate
    * 获取城市定位信息，判断是否开启，如果名称没错并已开启则返回城市ID，否则返回''
    * @param string city，城市名称可以是中文或英文
    * @return json
    */
    
    static let sharedLocateToCity = LocateToCity()
    
    var x: String = "0" {
        didSet {
           location = CLLocation(latitude: CLLocationDegrees(x) ?? 0, longitude: CLLocationDegrees(y) ?? 0)
        }
    }
    var y: String = "0" {
        didSet {
            location = CLLocation(latitude: CLLocationDegrees(x) ?? 0, longitude: CLLocationDegrees(y) ?? 0)
        }
    }
    
    dynamic var location: CLLocation?
    
    func locate(city: String, handler: (result: String?, status: Int) -> Void) {
        var post         = [String: String]()
        post["city"]     = String(city)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/city/locate", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                handler(result: result.stringValue, status: status)
                return
            }
            handler(result: nil, status: status)
        }
    }
}

