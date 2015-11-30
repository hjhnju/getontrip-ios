//
//  ErrorCode.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/27.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class RetCode: NSObject {
    /// 成功
    static let  SUCCESS           = 0
    /// 需要图片验证码
    static let  NEED_PICTURE      = 101
    
    /// CSRF验证不通过
    static let  CSRFTOKEN_INVALID = 102
    
    /// 需要补全信息
    static let  NEED_ADDINFO      = 103
    
    /// 前端跳转
    static let  NEED_REDIRECT     = 302
    
    /// 默认错误 未知错误
    static let  UNKNOWN_ERROR     = 999
    
    /// 验证会话 会话无效
    static let  SESSION_INVALID   = 410
    
    /// 非法请求
    static let  SESSION_DENY      = 411
    
    /// 未登录
    static let  SESSION_NOT_LOGIN = 412

    /// 其他错误 数据库操作错误
    static let  DB_ERROR          = 501
    
    /// 接口参数错误
    static let  PARAM_ERROR       = 502
    
    /// 功能未实现
    static let  NOT_FINISHED      = 503
    
    /// 数据为空
    static let  DATA_NULL         = 504
    
    /// 服务降级
    static let  SERVICE_DEGRADED  = 505
    
    /// 配置错误
    static let  CONFIG_FAIL       = 506
    
    /// 并发加锁失败
    static let  LOCK_ERROR        = 507
    
    /// 网络请求失败
    static let  NETWORK_ERROR     = 508
    
    //邮箱格式错误
    static let EMAIL_FORMAT_WRONG  = 1027
    
    //密码格式错误
    static let PASSWD_FORMAT_WRONG = 1028
    
    //邮箱不存在
    static let EMAIL_WRONG         = 1029
    
    //密码错误
    static let PASSWD_WORNG        = 1030
    
    //邮箱已被注册
    static let EMAIL_EXSIT         = 1031
    
    /// 用户名已存在
    static let UserNameExist       = 1032
    
    static let arrErrMap: [Int:String] = [
        RetCode.SUCCESS           : "成功",
        RetCode.UNKNOWN_ERROR     : "未知错误",
        RetCode.NEED_ADDINFO      : "需要补全信息",
    
        RetCode.SESSION_INVALID   : "会话无效",
        RetCode.SESSION_DENY      : "非法请求",
        RetCode.SESSION_NOT_LOGIN : "未登录",
        
        RetCode.DB_ERROR          : "数据库操作错误",
        RetCode.PARAM_ERROR       : "接口参数错误",
        RetCode.NOT_FINISHED      : "功能未实现",
        RetCode.DATA_NULL         : "数据为空",
        RetCode.SERVICE_DEGRADED  : "服务降级",
        RetCode.NEED_PICTURE      : "需要图片验证码",
        RetCode.CSRFTOKEN_INVALID : "会话token实效，请重新刷新页面",
        
        RetCode.NEED_REDIRECT     : "前端跳转",
        RetCode.LOCK_ERROR        : "加锁失败",
    ]
    
    static let userNameArrErrMap: [Int:String] = [
        RetCode.UserNameExist : "用户名已存在"
    ]
    
    //获取错误信息
    static func getMsg(retCode: Int) -> String {
        return arrErrMap[retCode] ?? ""
    }
    
    // 给用户显示的信息
    static let arrErrMapLogin: [Int:String] = [
        RetCode.EMAIL_FORMAT_WRONG  : "邮箱格式错误",
        RetCode.PASSWD_FORMAT_WRONG : "密码格式错误",
        RetCode.EMAIL_WRONG         : "邮箱不存在",
        RetCode.PASSWD_WORNG        : "密码错误",
        RetCode.EMAIL_EXSIT         : "邮箱已被注册"
    ]
    
    static func getShowMsg(retCode: Int) -> String {
        return arrErrMapLogin[retCode] ?? ""
    }
    
    /// 用户名获取错误信息
    static func getShowUNE(retCode: Int) -> String {
        return userNameArrErrMap[retCode] ?? ""
    }
}