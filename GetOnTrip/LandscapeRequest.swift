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
    var sightId :String?
    var page    :Int = 1
    var pageSize:Int = 6
    
    //    http://123.57.67.165:8301/api/sight/detail?tags
    // 将数据回调外界
    func fetchSightListModels(handler: NSArray -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: NSArray -> Void) {
        var post         = [String: String]()
        post["sightId"]  = String(4)
        post["page"]     = String(self.page)
        post["pageSize"] = String(self.pageSize)
        
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/landscape",
            post: post,
            handler: {(respData: AnyObject) -> Void in
                
                let sightLandscape = NSMutableArray() // [SightLandscape]()
                for item in respData.objectForKey("list") as! NSArray {
                    sightLandscape.addObject(SightLandscape(dict: item as! [String : AnyObject]))
                }
                
                // 回调
                handler(sightLandscape)
            }
        )
    }
}

/// 景点列表Tags
class SightLandscape: NSObject {
    /// id
    var id: String?
    ///  标题名称
    var name: String?
    ///  副标题内容
    var content: String?
    ///  url
    var url: String?
    /// 图片
    var image: String? 
    /// 目录
    var catalogs: NSMutableArray?
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        id = String(dict["id"]!)
        name = String(dict["name"]!)
        content = String(dict["content"]!)
        image = AppIni.BaseUri + String(dict["image"]!)
        
//        setValuesForKeysWithDictionary(dict)
        catalogs = NSMutableArray()
        for item in dict["catalog"] as! NSArray {
            let text = NSMutableString(string: item["name"] as! String)
            let range = text.rangeOfString("\r\n")
            text.deleteCharactersInRange(range)
            catalogs!.addObject(text)
        }
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
