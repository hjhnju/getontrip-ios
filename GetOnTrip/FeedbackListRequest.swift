//
//  FeedbackListRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/1.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class FeedbackListRequest: NSObject {
    
    /**
     * 接口1：/api/advise/list
     * 查询反馈意见接口
     * @return json
     */

    // 异步加载话题获取数据
    func fetchFeedbackListModels(handler: () -> Void) {
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/advise/list", post: [String: String]()) { (result, status) -> () in
            if status == RetCode.SUCCESS {
               print(result)
                
                return
            }
        }
        
    }
}

class FeedbackSendRequest: NSObject {
    
    /**
    * 接口2：/api/advise/add
    * 添加反馈意见接口
    * @param string advise，意见信息
    * @return json
    */
    
    class func fetchFeedbackSendModels(advise: String, handler:() -> Void) {
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "api/advise/add", post: ["advise" : advise]) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                print(result)
                return
            }
        }
    }
    
}
