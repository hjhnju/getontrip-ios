//
//  UserLoghtRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/10.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class UserLoghtRequest: NSObject {
    
    /**
    * 接口1：/api/user/login
    * 登录接口
    * @param integer openId
    * @param integer type,1:qq,2:weixin,3:weibo
    * @return json
    * 设置用户的登录态
    */
    
    /// 请求参数 默认微信登陆
    var openId: String?
    var type  : Int    = 1
    
    // TODO: 当用户登陆后，只需要让后台知道此用户已登陆过即可，目前后台无返回值
    func fetchLoginModels() {
      
        var post         = [String: String]()
        post["openId"]   = String(openId!)
        post["type"]     = String(type)
        
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/user/login", post: post) { (result, error) -> () in
            
            if error == nil {
                print(result!["data"])
            }
        }
    }
}


class UserExitLoghtRequest: NSObject {
    
    
    /**
    * 接口2：/api/user/signOut
    * 退出登录接口
    * @return json
    */
    
    
    func fetchExitLoginModels() {
        
        let post         = [String: String]()
        // 发送网络请求加载数据
        
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/user/signOut", post: post) { (result, error) -> () in
            if (error == nil) {
                print(result)
            }
        }
    }
}

