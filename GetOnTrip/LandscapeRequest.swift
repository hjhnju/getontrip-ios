//
//  LandscapeRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/4/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit

class LandscapeRequest: NSObject {
    
    /**
    * 接口1：/api/landscape
    * 百科详情接口
    * @param integer page
    * @param integer pageSize
    * @param integer sightId,景点ID
    * @return json
    */
    

    // 请求参数
    var sightId :String = ""
    var page    :Int = 1
    var pageSize:Int = 6
    
    func fetchNextPageModels(handler: (NSArray?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: (NSArray?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: (NSArray?, Int) -> Void) {
        var post         = [String: String]()
        post["sightId"]  = sightId
        post["page"]     = String(self.page)
        post["pageSize"] = String(self.pageSize)
        
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/landscape", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var sightLandscape = [SightLandscape]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        sightLandscape.append(SightLandscape(dict: item))
                    }
                }
                handler(sightLandscape, status)
                return
            }
            handler(nil, status)
        }
    }
}

/// 景点景观Cell数据
class SightLandscape: NSObject {
    /// id
    var id: String = ""
    ///  标题名称
    var name: String = ""
    ///  副标题内容
    var content: String = ""
    ///  url
    var url: String = ""
    /// 图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 119, height: 84)
        }
    }
    /// 目录
    var catalogs: NSMutableArray?
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        catalogs = NSMutableArray()
        for item in dict["catalog"] as! NSArray {

            var text = NSString(string: item["name"] as! String).substringWithRange(NSMakeRange(0, 4))
            if text.containsString("\r\n") {
                let range = text.rangeOfString("\r\n")
                text.removeRange(range!)
            }
            catalogs!.addObject(text)
        }
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
