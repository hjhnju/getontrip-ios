
//
//  Regex.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/24.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: [])
    }
    
    func match(input: String) -> Bool {
        
        if let matches = regex?.matchesInString(input,
            options: [],
            range: NSMakeRange(0, input.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))) {
                return matches.count > 0
        } else {
            return false
        }
    }
}

class RegexString {
    
    // TODO: 都不能出现中文否则会崩
    // 验证邮箱
    class func validateEmail(email: String) -> Bool {
        let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher     = MyRegex(mailPattern)
        return matcher.match(email)
    }
    
    // 验证密码
    class func validatePassword(password: String) -> Bool {
        
        let mailPattern = "^[a-zA-Z0-9]{6,20}$"
        let matcher     = MyRegex(mailPattern)
        return matcher.match(password)
    }
}
