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

class HttpRequest {
    
    typealias RequestFinishedCallBack = (result: AnyObject?, error: NSError?) -> ()
    
    typealias RequestJSONCallBack = (result: JSON, status: Int) -> ()
    
    /// 网络工具单例
    static let sharedHttpRequest = HttpRequest()
    
    static let sharedManager: Manager = {
        let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest  = 20
        configuration.timeoutIntervalForResource = 20
        
        // config.URLCache = urlCache
        configuration.requestCachePolicy =  NSURLRequestCachePolicy.ReturnCacheDataElseLoad
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
    
    ///  网络访问方法
    ///
    ///  - parameter url:     访问环境
    ///  - parameter path:    访问网络路径
    ///  - parameter post:    参数
    ///  - parameter handler: 回调数据及错误
    class func ajax2(url: String?, path: String?, post: Dictionary<String, String>, handler: RequestJSONCallBack) {
        
        let urlPath = (url ?? "") + (path ?? "")
        
        print("[HttpRequest]:url=\(urlPath), post=\(post)")
        HttpRequest.sharedManager.request(.POST, urlPath, parameters:post).response { request, response, respData, error -> Void in
            
//            let ree = NSURLCache.sharedURLCache().cachedResponseForRequest(request!)
//            print(ree)
//            print(NSURLCache.sharedURLCache().memoryCapacity)
//            print(NSHomeDirectory())
            
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