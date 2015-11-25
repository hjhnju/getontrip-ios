//
//  CacheRegexKey.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class CacheRegexConfig  {
    
    /// 正则表达式rawstring
    var expr: String = ""
    
    /// 缓存区大小
    var bufferSize: Int    = 0
    
    /// 有效期（超过有效期仍存在，作为展示用缓存）
    var expire: NSTimeInterval = 0
    
    /// 缓存区 TODO:只能用nsarray
    var buffer = [String]()
    
    init(expr:String, buffer:Int, expire:NSTimeInterval) {
        self.expr   = expr
        self.bufferSize = buffer
        if let cacheBuffer = globalKvStore?.getObjectById(expr, fromTable: CacheContant.table) as? [String]{
            self.buffer = cacheBuffer
        }
        self.expire = expire
    }
    
    func getCacheExpire(key: String) -> NSTimeInterval? {
        if let _ = key.rangeOfString(expr, options: .RegularExpressionSearch) {
            return expire
        }
        return nil
    }
    
    /// 是否满足正则配置
    func isCacheKey(key: String) -> Bool {
        if let _ = key.rangeOfString(expr, options: .RegularExpressionSearch) {
            return true
        }
        return false
    }
    
    /// 添加key入buffer, 并返回溢出buffer的key
    func appendBuffer(key: String) -> String? {
        if let index = buffer.indexOf(key) {
            buffer.removeAtIndex(index)
        }
        buffer.insert(key, atIndex: 0)
        var overflowKey: String? = nil
        if buffer.count == (bufferSize + 1) {
            overflowKey = buffer.popLast()
        }
        globalKvStore?.putObject(buffer as NSArray, withId: expr, intoTable: CacheContant.table)
        return overflowKey
    }
    
//    deinit {
//        print("deinit for CacheRegexConfig")
//        globalKvStore?.putObject(buffer as NSArray, withId: expr, intoTable: CacheContant.table)
//    }
}
