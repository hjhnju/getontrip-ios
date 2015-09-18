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
    class func ajax(url: String?, path: String?, post: Dictionary<String, String>, handler: (NSArray) -> Void) {
        
        let urlPath = (url ?? "") + (path ?? "")
        
        NSLog("[HttpRequest]:url=\(urlPath), post=\(post)")
        
        request(.POST, urlPath, parameters:post).response { request, response, respData, error -> Void in
            
            let result = try! NSJSONSerialization.JSONObjectWithData(respData!, options: NSJSONReadingOptions(rawValue: 0)) as! [String: AnyObject]
            
            if result["status"] as! Int == 0 {
                    return handler(result["data"] as! NSArray)
            }
            
//            if let data = respData {
////                let json = JSON(data: data)
//                if json["status"] == 0 {
//                    let data = json["data"]
//                    if !data.isEmpty {
//                        return handler(data)
//                    }
//                }
//            }
//            handler(nil)
        }
    }
    
    
    static let boundary = "bangni-upload"
    /// 上传一张及多张图片的方法
    class func uploadPicture(URLString: String, fieldName: String, dataList:[String: NSData!], parameters: [String: AnyObject]? = nil ,completion:(JSON: AnyObject?) -> ()) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: URLString)!)
        
        // 1. 设置请求的方法
        request.HTTPMethod = "POST"
        // 2. 设置 content-type
        let type = "multipart/form-data; boundary=\(boundary)"
        request.setValue(type, forHTTPHeaderField: "Content-Type")
        
//        _ = formData(fieldName, dataList: dataList, parameters: parameters)

//        upload(request, data: data).responseJSON() { (_, _, JSON, error) -> Void in
//            println("error = \(error)")
//            println("JSON = \(JSON)")
//            if error == nil {
//                completion(JSON: JSON)
//            } else {
//                completion(JSON: nil)
//            }
//        }
    }
    
    // 生成 formData 的方法
    private class func formData(fieldName: String, dataList:[String: NSData!], parameters: [String: AnyObject]? = nil) -> NSData {
        
        let dataM = NSMutableData()
        
        // 1. 遍历字典，拼接字符串参数
        if let params = parameters {
            for (k, v) in params {
                var strM = "--\(boundary)\r\n"
                strM += "Content-Disposition: form-data; name=\"\(k)\"\r\n\r\n"
                strM += "\(v)\r\n"
                
                dataM.appendData(strM.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            }
        }
        
        // 2. 遍历文件数据数组
        for (k, v) in dataList {
            var strM = "--\(boundary)\r\n"
            strM += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(k)\"\r\n"
            // 这里的Content-Type 一定要是image/jpeg  否则会报错
            strM += "Content-Type: image/jpeg\r\n\r\n"
            
            dataM.appendData(strM.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            // 追加文件数据
            dataM.appendData(v)
            dataM.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        }
        
        // 3. 请求结尾字符串，告诉服务器，上传数据已经结束
        let tail = "--\(boundary)--\r\n"
        dataM.appendData(tail.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        
        return dataM
    }
    
    
    class func urlRequestWithComponents(urlString:String, parameters: Dictionary<String, String>, imageData: NSData) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"avatar\"; filename=\"myAvatar.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // return URLRequestConvertible and NSData
        return (ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }

}