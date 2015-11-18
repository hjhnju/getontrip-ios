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
    func get(handler: (user: UserInfo?, status: Int) -> Void) {
        
        var post      = [String: String]()
        post["type"]  = String(type)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/user/getinfo", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                if result != nil {
                    if let resu = result.dictionaryObject {
                        handler(user: UserInfo(dict: resu), status: status)
                        return
                    }
                }
                handler(user: nil, status: status)
            } else {
                handler(user: nil, status: status)
            }
        }
    }
    
    /**
    * 接口4：/api/user/addinfo
    * 用户信息添加接口
    * @param integer type,第三方登录类型，1:qq,2:weixin,3:weibo
    * @param string  param,eg: param=nick_name:aa,type:jpg,image:bb,sex:1
    * @return json
    */
    func add(userAccount: UserAccount, handler: (AnyObject?, Int) -> Void) {
        var post          = [String: String]()
        post["nick_name"] = userAccount.nickname
        post["type"]  = String(type)
        post["image"] = userAccount.icon
        post["sex"]   = String(userAccount.gender)
        post["city"]  = userAccount.city
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/user/addinfo", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                
                handler(result.string, status)
                return
            }
            handler(nil, status)
        }
    }
}
