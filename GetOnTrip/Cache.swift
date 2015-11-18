//
//  Cache.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/17.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

struct CacheContant {
    static let table: String = "ApiCache"
}

/// 全局缓存类
class Cache: NSObject {
    
    static let shareInstance: Cache = Cache()
    
    var cachekeys: [String: NSTimeInterval] = [
        "/api/1.0/search/label?order=1&pageSize=15&page=1" : 600,
        "/api/1.0/search/label?order=2&pageSize=15&page=1" : 600,
        "/api/1.0/search/label?order=3&pageSize=15&page=1" : 600,
        "/api/1.0/search/label?order=4&pageSize=15&page=1" : 600,
        "/api/1.0/search/label?order=5&pageSize=15&page=1" : 600,
        "/api/1.0/search/label?order=6&pageSize=15&page=1" : 600,
        "/api/1.0/collect/list?page=1&pageSize=6&type=1"   : 60,
        "/api/1.0/collect/list?page=1&pageSize=6&type=2"   : 60,
        "/api/1.0/collect/list?page=1&pageSize=6&type=3"   : 60,
    ]
    
    /**
    获取缓存
    - parameter key: string
    - parameter expireValid: bool 是否有效期生效
    - returns: 不在配置内无缓存；
    默认expireValid=false即使过期也返回（用于初始有数据的体验）
    若设expireValid=true则超过时间的不返回（用于减少网络请求，但没有删除）
    */
    func getString(key: String, expireValid: Bool = true) -> String? {
        if let expire = cachekeys[key] {
            if !expireValid {
                let retString = globalKvStore?.getStringById(key, fromTable: CacheContant.table)
                return retString
            }
            
            if let item = globalKvStore?.getYTKKeyValueItemById(key, fromTable: CacheContant.table) {
                //TODO: not work yet
                let interval = NSDate().timeIntervalSinceDate(item.createdTime)
                if interval <= expire {
                    if let arrString = item.itemObject as? [String] {
                        if arrString.count > 0 {
                            return arrString[0]
                        }
                    }
                }
            }
        }
        return nil
    }
    
    /**
    获取缓存（用于初始有数据的体验）
    - parameter key: string
    - parameter expireValid: bool 是否有效期生效
    - returns: 不在配置内无缓存；
    默认expireValid=false即使过期也返回（用于初始有数据的体验）
    若设expireValid=true则超过时间的不返回（用于减少网络请求，但没有删除）
    */
    func getDisplayString(key: String) -> String? {
        return getString(key, expireValid: false)
    }
    
    /**
    设置缓存
    - parameter key:   string
    - parameter value: string
    - returns: 是否被缓存成功，不在配置内不缓存
    */
    func setString(key: String, value:String) -> Bool {
        if cachekeys.keys.contains(key) {
            globalKvStore?.putString(value, withId: key, intoTable: CacheContant.table)
            return true
        }
        return false
    }
}
