//
//  HttpRequest.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import YTKKeyValueStore

struct HttpRequestContant {
    static let timeout: NSTimeInterval = 20
}

class HttpRequest {
    
    typealias RequestFinishedCallBack = (result: AnyObject?, error: NSError?) -> ()
    
    typealias RequestJSONCallBack = (result: JSON, status: Int) -> ()
    
    /// 网络工具单例
    static let sharedHttpRequest = HttpRequest()
    
    static let sharedManager: Manager = {
        let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        //采用后端控制缓存时间
        let nsUrlCache = NSURLCache.sharedURLCache()
        configuration.URLCache = NSURLCache.sharedURLCache()
        
        configuration.requestCachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
        
        configuration.timeoutIntervalForRequest  = HttpRequestContant.timeout
        configuration.timeoutIntervalForResource = HttpRequestContant.timeout
        return Manager(configuration: configuration)
    }()
    
    ///  网络访问方法
    ///
    ///  - parameter url:     访问环境
    ///  - parameter path:    访问网络路径
    ///  - parameter post:    参数
    ///  - parameter handler: 回调数据及错误
    class func ajax(url: String?, path: String?, post: Dictionary<String, String>, handler: RequestFinishedCallBack) {
        
        let urlPath = (url ?? "") + (path ?? "")
        
        print("[HttpRequest]:url=\(urlPath), post=\(post)")

        request(.POST, urlPath, parameters:post).responseJSON { (response) -> Void in
            handler(result: response.result.value, error: response.result.error)
        }
    }
    
    static let kvStore = YTKKeyValueStore(DBWithName: "getontrip")
    
    ///  网络访问方法
    ///
    ///  - parameter url:     访问环境
    ///  - parameter path:    访问网络路径
    ///  - parameter post:    参数
    ///  - parameter handler: 回调数据及错误
    class func ajax2(url: String?, path: String?, post: Dictionary<String, String>, handler: RequestJSONCallBack) {

        HttpRequest.kvStore.createTableWithName("http_etag")
        HttpRequest.kvStore.createTableWithName("http_lastmodified")
        
        var params = [String]()
        for (field, value) in post {
            params.append("\(field)=\(value)")
        }
        //GET请求才会有效缓存
        var urlPath = (url ?? "") + (path ?? "")
        if params.count > 0 {
            urlPath += "?" + params.joinWithSeparator("&")
        }
        
        print("[HttpRequest]:url=\(urlPath)")
        
        let nsurl =  NSURL(string: urlPath.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        if nsurl == nil {
            print("[HttpRequest]:nsurl is nil=\(nsurl)")
            return
        }
        let nsreq = NSMutableURLRequest(URL: nsurl!)
        if let etag = HttpRequest.kvStore.getStringById(urlPath, fromTable: "http_etag") {
            nsreq.setValue(etag, forHTTPHeaderField: "If-None-Match")
        }
        if let lastModified = HttpRequest.kvStore.getStringById(urlPath, fromTable: "http_lastmodified") {
            nsreq.setValue(lastModified, forKeyPath: "If-Modified-Since")
        }
        
        HttpRequest.sharedManager.request(nsreq).response { request, response, respData, error -> Void in
            print("urlPath\(urlPath)")
            
            if let etag = response?.allHeaderFields["ETag"] as? String {
                HttpRequest.kvStore.putString(etag, withId: urlPath, intoTable: "http_etag")
            }
            if let lastModified = response?.allHeaderFields["Last-Modified"] as? String {
                HttpRequest.kvStore.putString(lastModified, withId: urlPath, intoTable: "http_lastmodified")
            }
            
            //异常
            if error != nil {
                print("[HttpRequest]:error=\(error)")
                return handler(result: nil, status: RetCode.NETWORK_ERROR)
            }
            //处理数据
            if let data = respData {
                let json = JSON(data: data)
                return handler(result: json["data"], status: json["status"].intValue)
            }
        }
        
        print("[HttpRequest]:url=\(urlPath) sync finished")
    }
    
    /// 上传文件
    ///
    /// - parameter urlString:  urlString
    /// - parameter data:       要上传文件的二进制数据
    /// - parameter parameters: 参数字典
    /// - parameter finished:   完成回调
    func upload(urlString: String, data: NSData, parameters: [String: AnyObject]?, finished: RequestFinishedCallBack) {
        
        let urlStr = AppIni.BaseUri + urlString
        Alamofire.upload(.POST,
            urlStr,
            multipartFormData: { (multipartFormData) in
                
                multipartFormData.appendBodyPart(data: data, name: "file", fileName: "123.png", mimeType: "image/png")
                
                guard let params = parameters else {
                    return
                }
                
                for (k, v) in params {
                    let value = v as! String
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: k)
                }
            }) { (encodingResult) -> Void in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        finished(result: response.result.value, error: response.result.error)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    finished(result: nil, error: nil)
                }
        }
    }
}