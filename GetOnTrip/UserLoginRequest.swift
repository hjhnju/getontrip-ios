//
//  UserLoghtRequest.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/11.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

class UserLoginRequest: NSObject {
    
    /**
    * 接口1：/api/user/login
    * 登录接口
    * @param integer openId
    * @param integer type,1:qq,2:weixin,3:weibo
    * @return json
    * 设置用户的登录态
    */
    /// 请求参数 默认微信登陆
    var openId: String = ""
    var type  : Int    = 1
    
    //当用户登陆后，只需要让后台知道此用户已登陆过即可，目前后台无返回值
    func login(handler: (result: AnyObject?, status: Int) -> Void) {
        var post         = [String: String]()
        post["openId"]   = String(openId)
        post["type"]     = String(type)
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/user/login", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                print(result)
                handler(result: result.stringValue, status: status)
                return
            }
            handler(result: nil, status: status)
        }
    }
    
    /**
    * 接口2：/api/user/signOut
    * 退出登录接口
    * @return json
    */
    func signout() {
        let post = [String: String]()
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/user/signOut", post: post) { (result, error) -> () in
            if (error == nil) {
                print(result)
            }
        }
    }
    
    /**
    * 接口6：/api/user/checkLogin
    * result返回用户ID
    * 检查用户是否登录
    */
    func check(handler: (result: Int?, status: Int) -> Void) {
        let post = [String : String]()
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/user/checkLogin", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                handler(result: result.intValue, status: status)
            } else {
                handler(result: nil, status: status)
            }
        }
    }
}

