//
//  Cookie.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/17.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class Cookie {
    class func setCookie(key: String, value: AnyObject?) {
        var props = [String: AnyObject]()
        props[NSHTTPCookieName]  = key
        props[NSHTTPCookieValue] = value ?? ""
        props[NSHTTPCookieDomain]    = AppIni.BaseUri
        props[NSHTTPCookieOriginURL] = AppIni.BaseUri
        props[NSHTTPCookiePath]    = "/"
        props[NSHTTPCookieVersion] = "0"
        
        if let property = NSHTTPCookie(properties: props) {
            NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(property)
        }
    }
}