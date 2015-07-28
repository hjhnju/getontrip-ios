//
//  NetworkManager.swift
//  Project-TuZhi-App
//
//  Created by guojinli on 15/7/14.
//  Copyright (c) 2015年 guojinli. All rights reserved.
//

import UIKit

class TZNetWork {
    /// 单例
    static let shareInstance = TZNetWork()
    
    // 全局的net
    let net = NetWork()
    
    /**
    隔离的一层网络
    */
    func JSON(method: NetWork.HTTPMethod, _ urlString: String,_ params: [String: String]?,_ success: Success, _ fail: Fail){
        net.JSON(method, urlString, params, success, fail)
    }
}