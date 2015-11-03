//
//  UserInfoRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/10.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class UserInfoRequest: NSObject {
    
    /**
    * 接口3：/api/user/getinfo
    * 用户信息获取接口
    * @param integer type,第三方登录类型，1:qq,2:weixin,3:weibo
    * @return json
    */
    
    // 请求参数
    var type: Int = 0
    
    // 异步加载获取数据
    func userInfoGainMeans(handler: UserInfo -> Void) {
        
        var post      = [String: String]()
        post["type"]  = String(type)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/user/getinfo", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                
            }
        }
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/user/getinfo", post: post) { (result, error) -> () in
            if error == nil {
                if (result!["data"]!!.count == 0) {
                    let user = UserInfo()
                    user.type = "0"
                    handler(user)
                    
                } else {
                    handler(UserInfo(dict: result!["data"] as! [String : AnyObject]))
                }
            }
        }
    }
}
