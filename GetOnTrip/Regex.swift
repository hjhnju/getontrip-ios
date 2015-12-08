//
//  Regex.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/24.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class RegexString {
    
    // 验证邮箱
    class func validateEmail(email: String) -> Bool {
        let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        if let _ = email.rangeOfString(mailPattern, options: .RegularExpressionSearch) {
            return true
        }
        return false
    }
    
    // 验证密码
    class func validatePassword(password: String) -> Bool {
        
        let mailPattern = "^[a-zA-Z0-9]{6,20}$"
        if let _ = password.rangeOfString(mailPattern, options: .RegularExpressionSearch) {
            return true
        }
        return false
    }
}
