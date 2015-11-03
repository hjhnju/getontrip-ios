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
    
    // 请求参数
    var type : Int    = 0
    var param: UserAccount?
    
    // 异步加载获取数据
    func userAddInfoMeans() {
        
        var post         = [String: String]()
        post["nick_name"] = param?.nickname ?? ""
        post["type"]  = String(type ?? 0)
        post["image"] = param?.icon ?? ""
        post["sex"]   = String(param?.gender ?? 0)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/user/addinfo", post: post) { (result, error) -> () in
            if error == nil {
                print(result)
                print("添加成功")
            }
        }
    }
}
