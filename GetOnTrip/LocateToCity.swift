//
//  LocateToCity.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/12.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 用位置换取城市
class LocateToCity: NSObject {
    
    /**
    * 接口5：/api/city/locate
    * 获取城市定位信息，判断是否开启，如果名称没错并已开启则返回城市ID，否则返回''
    * @param string city，城市名称可以是中文或英文
    * @return json
    */
    
    class func locate(city: String, handler: (result: AnyObject?, status: Int) -> Void) {
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
    
    /**
    * 接口6：/api/city/province
    * 获取省份下面的城市信息
    * @return json
    */
    class func getCityProvinceInfo(handler:(result: [Province]?, status: Int) -> Void) {
        
        fetchProvince(handler)
    }
    
    // MARK: - coredata 数据库处理，读取数据
    class func fetchProvince(handler:(result: [Province]?, status: Int) -> Void) {
        
        var province = [Province]()
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("province") {
            
            for item in data as! NSArray {
                if let it: [String : AnyObject] = item as? [String : AnyObject] {
                    province.append(Province(dict: it))
                }
            }
            handler(result: province, status: 0)
            return
            
        } else {
            HttpRequest.ajax2(AppIni.BaseUri, path: "/api/city/province", post: [String: String]()) { (result, status) -> () in
                if status == RetCode.SUCCESS {
                    NSUserDefaults.standardUserDefaults().setObject(result.arrayObject, forKey: "province")
                    
                    for item in result.arrayValue {
                        if let item = item.dictionaryObject {
                            province.append(Province(dict: item))
                        }
                    }
                    
                    handler(result: province, status: status)
                    return
                }
                handler(result: nil, status: status)
            }
        }
    }
}


