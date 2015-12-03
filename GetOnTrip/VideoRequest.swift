//
//  VideoRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/3.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class VideoRequest: NSObject {
    
    // 异步加载获取数据
    class func fetchModels(id: String, handler: (Video?, Int) -> Void) {
        var post         = [String: String]()
        post["id"]    = id
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/video", post: post) { (data, status) -> () in
            if status == RetCode.SUCCESS {
                // 回调
                if let item = data.dictionaryObject {
                    handler(Video(dict: item), status)
                }
                return
            }
            handler(nil, status)
        }
    }
}
