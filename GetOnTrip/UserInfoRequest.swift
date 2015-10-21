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
    var type: Int?

    
    // 异步加载获取数据
    func userInfoGainMeans(handler: UserInfo -> Void) {
        
        var post         = [String: String]()
        post["type"]  = String(type!)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/user/getinfo",
            post: post,
            handler: {(respData: AnyObject) -> Void in
                
                if (respData.count == 0) {
                    let user = UserInfo()
                    user.type = "0"
                    handler(user)
                    
                } else {
                    handler(UserInfo(dict: respData as! [String : AnyObject]))
                }
            }
        )
    }
}

class UserInfo : NSObject {
    
    var nick_name: String = ""
    
    var image: String = "" {
        didSet {
            image = AppIni.BaseUri + image
        }
    }
    
    var sex: String = ""
    
    /// 自己添加的不是后端返回的数据，用于判断此用户是否是后台记录在册的用户,记录在册为1
    var type: String = "1"
    
    convenience init(dict: [String : AnyObject]) {
        self.init()
        
//        setValuesForKeysWithDictionary(dict)
        nick_name = dict["nick_name"] as! String
        image = AppIni.BaseUri + (dict["image"] as! String)
        sex = String(dict["sex"])
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
