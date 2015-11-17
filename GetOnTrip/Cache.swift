//
//  Cache.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/17.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 全局缓存类
class Cache: NSObject {
    
    static let shareInstance: Cache = Cache()
    
    var cachekeys: [String: NSTimeInterval] = [
        "/api/1.0/search/label?label=&pageSize=15&page=1" : 10
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
                return globalKvStore?.getStringById(key, fromTable: "ApiCache")
            }
            
            if let item = globalKvStore?.getYTKKeyValueItemById(key, fromTable: "ApiCache") {
                //TODO: NOT Work yet
                let interval = NSDate().timeIntervalSinceDate(item.createdTime)
                print("interval=\(interval)")
                if interval <= expire {
                    if let str = item.itemObject as? String {
                        return str
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
            globalKvStore?.putString(key, withId: value, intoTable: "ApiCache")
            return true
        }
        return false
    }
}
