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
    * @param string  deviceId
    * @return json
    * 设置用户的登录态
    */
    
    // 请求参数
    var openId   :Int
    var type     :Int
    var deviceId :String = appUUID!
    
    // 初始化方法
    init(openId: Int, type: Int) {
        self.type   = type
        self.openId = openId
        
    }
    
    // TODO: 当用户登陆后，只需要让后台知道此用户已登陆过即可，目前后台无返回值
    func fetchLoginModels() {
      
        var post         = [String: String]()
        post["openId"]   = String(self.openId)
        post["type"]     = String(self.type)
        post["deviceId"] = String(self.deviceId)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/user/login",
            post: post,
            handler: {(respData: NSArray) -> Void in
            }
        )
    }
}
