//
//  HomeSearchCityRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import SwiftyJSON

class RecommendRequest: NSObject {
    /**
    * 接口2：/api/search/label
    * 搜索列表页   首页入口二
    * @param integer page
    * @param integer pageSize
    * @param integer label,搜索标签，标签可以不传
    * @return json
    */
    
    // 请求参数
    var label   : String = ""
    var page    : Int = 1
    var pageSize: Int = 6
    
    func fetchNextPageModels(handler: (NSDictionary?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: (NSDictionary?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }

    // 异步加载获取数据
    func fetchModels(handler: (NSDictionary?, Int) -> Void) {
        var post         = [String: String]()
        post["label"]    = String(label)
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/search/label", post: post) { (data, status) -> () in
            if status == RetCode.SUCCESS {
                
//                RecommendRequest.saveStatus(data)
                
                let searchModel = NSMutableDictionary()
                
                var searchLabels = [RecommendLabel]()
                var searchDatas = [RecommendCellData]()
                
                for item in data["label"].arrayValue {
                    if let item = item.dictionaryObject {
                        searchLabels.append(RecommendLabel(dict: item))
                    }
                }
                
                for item in data["content"].arrayValue {
                    if let item = item.dictionaryObject {
                        searchDatas.append(RecommendCellData(dict: item))
                    }
                }
                
                searchModel.setValue(searchLabels, forKey: "labels")
                searchModel.setValue(searchDatas, forKey: "cells")
                let url = UIKitTools.sliceImageUrl(data["image"].stringValue, width: Int(UIScreen.mainScreen().bounds.width), height: 244)
                searchModel.setValue(url, forKey: "image")
                // 回调
                handler(searchModel, status)
                return
            }
            handler(nil, status)
        }
    }
    
    
//    private func loadCacheStatus(page: Int, finished:(array: [[String: AnyObject]])->()) {
//        
//        // 2. SQL
//        var sql = "SELECT statusId, status, userId FROM T_Status \n" +
//        "WHERE userId = \(sharedUserAccount!.uid) \n"
//        
//            sql += "AND statusId > \(page)\n"
//        
//        sql += "ORDER BY statusId DESC LIMIT 20;"
//        
//        // 测试 sql
//        print(sql)
//        // 3. 执行 SQL
//        SQLiteManager.sharedSQLiteManager.queue?.inTransaction({ (db, _) -> Void in
//            let rs = db.executeQuery(sql)!
//            
//            // 遍历结果集合 － 思考，返回什么？`字典数组`即可，和网络返回的数据格式一致
//            // 字典是一条完整的微博数据的字典
//            var array = [[String: AnyObject]]()
//            
//            while rs.next() {
//                let str = rs.stringForColumn("status")
//                
//                // 字符串 -> 二进制数据 -> 字典
//                let data = str.dataUsingEncoding(NSUTF8StringEncoding)!
//                let dict = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as! [String: AnyObject]
//                
//                array.append(dict)
//            }
//            
//            // 完成回调
//            finished(array: array)
//        })
//    }
//    
//    
//    /// 将数据保存到数据库
//    private class func saveStatus(array: JSON) {
//        
//        // 2. SQL
//        let sql = "INSERT OR REPLACE INTO T_Recommend (id, page, pageSize) VALUES (?, ?, ?);"
//        
//        // 3. 遍历数组
//        for dict in array {
//            // 3.1 statusId
//            let statusId = dict["id"] as! Int
//            // 3.2 status 字典 -> 二进制数据 -> 字符串
//            let data = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
//            let str = NSString(data: data, encoding: NSUTF8StringEncoding)!
//            
//            // 4. 执行 sql
//            SQLiteManager.sharedSQLiteManager.queue!.inTransaction({ (db, rollback) -> Void in
//
//                if !db.executeUpdate(sql, statusId, str) {
//                    rollback.memory = true
//                }
//            })
//        }
//    }
    
}