//
//  Statistics.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/11.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

/// 统计相关
class Statistics {
    
    static let shareStatistics = Statistics()
    
    // 传入事件id和需要统计的文字
    func event(eventId: String, labelStr: String? = "") {
        MobClick.event(eventId, label: labelStr)
    }
    
    /// 注册统计相关配置
    func registerStatisticsSetting() {
        // 注册key 并设置为程序启动时发送消息，默认为appstore渠道
        MobClick.startWithAppkey("568a1c6be0f55a3252000934", reportPolicy: BATCH, channelId: nil)
        /** 设置是否对日志信息进行加密, 默认NO(不加密). */
        MobClick.setEncryptEnabled(true)
        /// 是否在终端打印
//        MobClick.setLogEnabled(true)
    }
    
    /// 账号登陆
    func profilesSignInWithPuid(id: String, loginType: String) {
        MobClick.profileSignInWithPUID(id, provider: loginType)
    }
    
    /// 账号退出
    func profilesSignOff() {
        MobClick.profileSignOff()
    }
}
