//
//  DotLike.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/1.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

struct PraisedContant {
    //查询用
    static let TypeTopic   = 1
    static let TypeBook    = 2
    static let TypeVideo   = 3
}

/// 点赞
class Praised: NSObject {

    class func praised(type: Int, objid: String, isFavorite: Bool, handler: (String?, Int) -> Void) {
        
        if globalUser == nil {
            LoginView.sharedLoginView.doAfterLogin() {(success, error) -> () in
                if success {
                    Praised.doAction(type, objid: objid, isFavorite: isFavorite, handler: handler)
                } else {
                    handler("-1", 0)
                }
            }
        } else {
            Praised.doAction(type, objid: objid, isFavorite: isFavorite, handler: handler)
        }
        
    }
    
    class private func doAction(type: Int, objid: String, isFavorite: Bool, handler: (String?, Int) -> Void) {
        var post      = [String: String]()
        post["type"]  = String(type)
        post["objid"] = String(objid)
        let path = isFavorite ? "/api/praise/add" : "/api/praise/del"
        
        HttpRequest.ajax2(AppIni.BaseUri, path: path, post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                
                handler(result.string, status)
                return
            }
            handler(nil, status)
        }
    }
}
