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

/// 缓存的应用类型，可以跟进该类型清除相应缓存
enum CacheType {
    case Sight
    case City
    case SightTopics
    case Topic
}

/// 全局缓存类
class Cache: NSObject {
    
    static let shareInstance: Cache = Cache()
    
    static let cacheCityListTime: NSTimeInterval = 60 * 60

    /// 用户当前的地理位置
    var cachekeys: [String: NSTimeInterval] = [
        "/api/1.1/city/list?type=0" : Cache.cacheCityListTime,
        "/api/1.1/city/list?type=1" : Cache.cacheCityListTime,
        "/api/1.1/city/hot?type=0"  : Cache.cacheCityListTime,
        "/api/1.1/city/hot?type=1"  : Cache.cacheCityListTime,
        //一秒的有效缓存，主要用于显示
        "/api/1.1/collect/list?page=1&pageSize=6&type=1"   : 1,
        "/api/1.1/collect/list?page=1&pageSize=6&type=2"   : 1,
        "/api/1.1/collect/list?page=1&pageSize=6&type=3"   : 1,
        "/api/1.1/msg/list?pageSize=10&page=1"             : 1,
    ]
    
    /// 正则缓存配置 name:config
    var cacheRegexConfs: [String: CacheRegexConfig] = [
        //城市页缓存
        "city": CacheRegexConfig(expr: "^/api/1\\.0/city\\?city=([0-9]+)$", buffer: 10, expire: 1),
        //景点缓存（标签等信息）
        "sight": CacheRegexConfig(expr: "^/api/1\\.1/sight\\?sightId=([0-9]+)$", buffer: 50, expire: 1),
        //景点话题列表缓存
        "sight_topics": CacheRegexConfig(expr: "^/api/1\\.1/sight/topic\\?tags=([0-9]+)&page=1&sightId=([0-9]+)&pageSize=10$", buffer: 100, expire: 1),
        //景观列表缓存
        "sight_landscapes": CacheRegexConfig(expr: "^/api/1\\.1/sight/landscape\\?sightId=([0-9]+)&pageSize=10&page=1$", buffer: 50, expire: 1),
        //书籍列表缓存
        "sight_books": CacheRegexConfig(expr: "^/api/1\\.1/sight/book\\?sightId=([0-9]+)&pageSize=10&page=1$", buffer: 50, expire: 1),
        //视频列表缓存
        "sight_vedios":CacheRegexConfig(expr: "^/api/1\\.1/sight/video\\?sightId=([0-9]+)&pageSize=10&page=1$", buffer: 50, expire: 1),
        //美食列表缓存
        "sight_foods": CacheRegexConfig(expr: "^/api/1\\.1/sight/food\\?sightId=([0-9]+)&pageSize=10&page=1$", buffer: 50, expire: 1),
        //美食商店缓存
        "sight_foods_shop": CacheRegexConfig(expr: "^/api/1\\.1/food/shop\\?id=([0-9]+)&pageSize=10&page=1$", buffer: 50, expire: 1),
        //美食详情缓存
        "sight_foods_topic": CacheRegexConfig(expr: "^/api/1\\.1/food/topic\\?id=([0-9]+)&pageSize=10&page=1$", buffer: 50, expire: 1),
        //特产列表缓存
        "sight_specialty": CacheRegexConfig(expr: "^/api/1\\.1/sight/specialty\\?sightId=([0-9]+)&pageSize=10&page=1$", buffer: 50, expire: 1),
        //特产名品缓存
        "sight_specialty_product": CacheRegexConfig(expr: "^/api/1\\.1/specialty/product\\?id=([0-9]+)&pageSize=10&page=1$", buffer: 50, expire: 1),
        //特产详情缓存
        "sight_specialty_topic": CacheRegexConfig(expr: "^/api/1\\.1/specialty/topic\\?id=([0-9]+)&pageSize=10&page=1$", buffer: 50, expire: 1),
        // 首页缓存
        "recommend1" : CacheRegexConfig(expr: "^/api/1\\.1/search/label\\?x=([0-9]+\\.[0-9]+)&page=1&order=1&pageSize=15&y=([0-9]+\\.[0-9]+)$", buffer: 5, expire: 60),
        "recommend2" : CacheRegexConfig(expr: "^/api/1\\.1/search/label\\?x=([0-9]+\\.[0-9]+)&page=1&order=2&pageSize=15&y=([0-9]+\\.[0-9]+)$", buffer: 5, expire: 60),
        // 音频缓存 音频缓存3天
//        "play" : CacheRegexConfig(expr: "/audio/([a-zA-Z0-9]+).mp3", buffer: 50, expire: 60 * 60 * 3)
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
        if let expire = getCacheExpire(key)  {
            if !expireValid {
                let retString = globalKvStore?.getStringById(key, fromTable: CacheContant.table)
                return retString
            }
            
            if let item = globalKvStore?.getYTKKeyValueItemById(key, fromTable: CacheContant.table) {
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
        } else {
            /// 缓存区溢出的key删除
            for (_,conf) in cacheRegexConfs {
                if conf.isCacheKey(key) {
                    globalKvStore?.putString(value, withId: key, intoTable: CacheContant.table)
                    if let overflowKey = conf.appendBuffer(key) {
                        globalKvStore?.deleteObjectById(overflowKey, fromTable: CacheContant.table)
                    }
                    return true
                }
            }
        }
        return false
    }
    
    
    func clearCache(type: CacheType, id: String = ""){
        var delkeys = [String]()
        switch type {
            case CacheType.City:
                let delkey: String = "/api/1.1/city?city=" + id
                delkeys.append(delkey)
            case CacheType.Sight:
                let delkey: String = "/api/1.1/sight?sightId=" + id
                delkeys.append(delkey)
            default:
                break
        }
    }
    
    /// 清除数据
    func clear(handler: ()->Void) {
        globalKvStore?.clearTable(CacheContant.table)
    }
    
    // 获取缓存有效期
    private func getCacheExpire(key: String) -> NSTimeInterval? {
        if let expire = cachekeys[key] {
            return expire
        } else {
            for (_, conf) in cacheRegexConfs {
                if let expire = conf.getCacheExpire(key) {
                    return expire
                }
            }
        }
        
        return nil
    }
}
