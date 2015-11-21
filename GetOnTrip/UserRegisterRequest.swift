

//
//  UserRegisterRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/20.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class UserRegisterRequest: NSObject {
    
    /**
    * 接口7：/api/user/regist
    * 用户注册接口
    * @param string email,邮箱
    * @param string passwd,密码
    * @return json
    */
    
    class func userRegister(email: String, passwd: String, handler:(AnyObject?, Int) -> Void) {
        
        var post       = [String: String]()
        post["email"]  = email
        post["passwd"] = passwd
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/user/regist", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                handler(result.object, status)
                return
            } else {
                handler(nil, status)
            }
        }
    }
    
    
    
    /**
    * 接口2：/api/user/login2
    * 邮箱登录接口
    * @param string email,邮箱
    * @param string passwd,密码
    * @return json
    * 普通的用户的登录态
    */
    
    class func userEmailLogin(email: String, passwd: String, handler:(AnyObject?, Int) -> Void) {
        
        var post       = [String: String]()
        post["email"]  = email
        post["passwd"] = passwd
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/user/login2", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                handler(result.object, status)
                return
            } else {
                handler(nil, status)
            }
        }
    }
    
    /**
    * 接口8：/api/user/sendPasswdEmail
    * 发送密码重置邮件
    * @param string email,邮箱
    * @return json
    */
    
    class func userSendPasswdEmail(email: String, handler:(AnyObject?, Int) -> Void) {
        var post       = [String: String]()
        post["email"]  = email
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/user/sendPasswdEmail", post: post) { (result, status) -> () in
            print(result)
            if status == RetCode.SUCCESS {
                handler(result.object, status)
                return
            } else {
                handler(nil, status)
            }
        }
    }
}
