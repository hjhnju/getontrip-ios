//
//  SQLiteManager.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/17.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SQLiteManager {
    
    private static let instance = SQLiteManager()
    class var sharedSQLiteManager: SQLiteManager { return instance }
    
    /// 数据库队列对象
    var queue: FMDatabaseQueue?
    
    func openDB(dbName: String) {
        
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!.stringByAppendingPathComponent(dbName)
        print(path)
        
        // 实例化数据库队列对象，会自动打开数据库
        // 如果数据库不存在，会新建再打开
        queue = FMDatabaseQueue(path: path)
        
        createTable()
    }
    
    ///  创建数据表
    private func createTable() {
        let path = NSBundle.mainBundle().pathForResource("tables.sql", ofType: nil)!
        let sql = String(contentsOfFile: path)
        
        // 提示：在 FMDB 中，除了查询，其他一律使用 executeUpdate
        queue?.inDatabase({ (db) -> Void in
            if db!.executeUpdate(sql!) {
                print("建表成功")
            } else {
                print("建表失败")
            }
        })
    }

}
