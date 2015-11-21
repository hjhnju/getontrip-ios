//
//  ReportRequest.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/21.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 举报请求
class ReportRequest: NSObject {
    
    // 请求参数
    var commentid : String = ""
    
    // 异步加载获取数据
    func report(handler: ((result: String?, status: Int?) -> Void)? = nil) {
        var post         = [String: String]()
        post["commentid"]  = String(commentid)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/advise/report", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                    handler?(result: result.stringValue, status: status)
            } else {
                handler?(result: nil, status: status)
            }
        }
    }
}