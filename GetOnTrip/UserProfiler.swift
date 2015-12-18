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
    
    /// 当前是否在wifi环境下
    var isViaWiFi: Bool = true
    
    /// 是否省流量模式（开启则非wifi下不显示图片）
    var savingTrafficMode: Bool  {
        get {
            //非wifi 且开启 时返回 true
            return true && !isViaWiFi
        }
        set {
            // 保存至用户配置
            
        }
    }
    
    
}