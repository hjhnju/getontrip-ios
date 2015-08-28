//
//  HttpRequest.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import Alamofire

class HttpRequest {
    class func ajax(url: String?, path: String?, post: Dictionary<String, String>, handler: (JSON) -> Void) {
        
        let urlPath = (url ?? "") + (path ?? "")
        
        NSLog("[HttpRequest]:url=\(urlPath), post=\(post)")
        
        request(.POST, urlPath, parameters:post).response { request, response, respData, error -> Void in
            if let data = respData {
                let json = JSON(data: data)
                if json["status"] == 0 {
                    let data = json["data"]
                    if !data.isEmpty {
                        return handler(data)
                    }
                }
            }
            return handler(nil)
        }
    }
}