//
//  UserProfiler.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/12/18.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import ReachabilitySwift

class UserProfiler: NSObject {
    
    static let instance: UserProfiler = UserProfiler()
    
    /// 当前是否在wifi环境下，再首页根据当前网络环境切换
    var isViaWiFi: Bool = true
    
    /// 是否省流量模式（开启则非wifi下不显示图片）
    var savingTrafficMode: Bool  {
        get {
            // 默认返回
            if let userDefault = NSUserDefaults.standardUserDefaults().valueForKey("isSavingTrafficMode") as? Bool {
                return userDefault
            }
            return false
        }
        set {
            // 保存至用户配置
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "isSavingTrafficMode")
        }
    }
    
    /// 根据当前用户设置判断是否显示图片
    func isShowImage() -> Bool {
        //非wifi 且开启 时返回 true
        let isShow: Bool = isViaWiFi ? true : (savingTrafficMode ? false : true)
        return isShow
    }
    
}