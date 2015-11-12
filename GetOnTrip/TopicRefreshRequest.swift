//
//  TopicRefreshRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class TopicRefreshRequest: NSObject {
    
    /**
    * 接口4：/api/city/topic
    * 获取城市话题,定位了城市后刷新话题时使用
    * @param integer page,页码
    * @param integer pageSize,页面大小
    * @return json
    */
    
    // 请求参数
    var page    : Int    = 2
    var pageSize: String = "4"
    var city    : String?
    
    // 异步加载获取数据
    func fetchModels(handler: [TopicBrief] -> Void) {
        var post         = [String: String]()
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        post["city"]     = String(city!)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/city/topic", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var topics = [TopicBrief]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        topics.append(TopicBrief(dict: item))
                    }
                    handler(topics)
                }
                return
            }
        }
    }
}

/// 用位置换取城市
class LocateBarterCity: NSObject {
    
    /**
    * 接口5：/api/city/locate
    * 获取城市定位信息，判断是否开启，如果名称没错并已开启则返回城市ID，否则返回''
    * @param string city，城市名称可以是中文或英文
    * @return json
    */
    
    class func locateBarterCityAction(city: String, handler: (result: AnyObject?, status: Int) -> Void) {
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


