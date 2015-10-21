//
//  UserAddRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/20.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class UserAddRequest: NSObject {
    
    /**
    * 接口4：/api/user/addinfo
    * 用户信息添加接口
    * @param integer type,第三方登录类型，1:qq,2:weixin,3:weibo
    * @param string  param,eg: param=nick_name:aa,type:jpg,image:bb,sex:1
    * @return json
    */
    
    // http://123.57.46.229:8301/api/user/addinfo?param=sex:0,nick_name:open,image:http&type=3
    // 请求参数
    var type : Int?
    var param: String?
    
    // 异步加载获取数据
    func userAddInfoMeans() {
        
        var post         = [String: String]()
        post["type"]  = String(type!)
        post["param"] = String(param!)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/user/addinfo",
            post: post,
            handler: {(respData: AnyObject) -> Void in
                print(respData)
//                if (respData.count == 0) {
//                    let user = UserInfo()
//                    user.type = "0"
//                } else {
//                    handler(UserInfo(dict: respData as! [String : AnyObject]))
//                }
                
                let cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
                for c in cookieJar.cookies! {
                    print(c)
                }
                
            }
        )
    }
}
