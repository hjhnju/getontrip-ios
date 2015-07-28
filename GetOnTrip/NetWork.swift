//
//  Data.swift
//  Project-TuZhi-App
//
//  Created by guojinli on 15/7/14.
//  Copyright (c) 2015年 guojinli. All rights reserved.
//

import UIKit
// 定义回调闭包
/// 成功回调闭包
typealias Success = (result: AnyObject?) -> ()

/// 失败回调闭包
typealias Fail = (error: NSError?) -> ()

class NetWork {
    /// 网络访问方式
    enum HTTPMethod:String {
        case GET  = "GET"
        case POST = "POST"
    }
    
    ///  返回 JSON 字典
    ///  :param: method 请求方式
    ///  :param: urlStr url 字符串
    ///  :param: params 请求参数字典
    func JSON(method: HTTPMethod, _ urlStr: String, _ params: [String: String]?, _ success:Success, _ fail: Fail) {
        
        /// 全局网络会话
        let session = NSURLSession.sharedSession()
        /// 请求
        var request = NSMutableURLRequest()
        /// 完整 urlString
        var urlString: String
        
        var query = String()
        
        // 处理 requset
        var array = [String]()
        if params != nil {
            for (k, v) in params! {
                
                let str = k + "=" + v.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                
                array.append(str)
            }
            query = join("&", array)
        }
        
        /// 如果是 GET 请求
        if method == .GET {
            // 拼接  url
            urlString = urlStr + "?" + query
            request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
            
        } else {
            /// 如果是 POST 请求
            request = NSMutableURLRequest(URL: NSURL(string: urlStr)!)
            request.HTTPMethod = HTTPMethod.POST.rawValue
            request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        }
        
        ///  处理请求
        session.dataTaskWithRequest(request) { (data, _ , error) -> Void in
            // 回调代码
            
            // 如果有错误
            if error != nil {
                fail(error: error)
                return
            } else {
                // 有数据
                if let dict = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) as? NSDictionary{
                    success(result: dict)
                    
                } else { // 反序列化失败
                    let error = NSError(domain: "com.baidu.error", code: -1, userInfo: ["error" :"反序列化失败"])
                    fail(error: error)
                }
                
            }
            }.resume()
    }
}
