//
//  SightLandscapesRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/4/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit

class SightLandscapesRequest: NSObject {
    
    /**
    * 接口1：/api/landscape
    * 百科列表接口
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
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/sight/landscape", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var land = [Landscape]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        land.append(Landscape(dict: item))
                    }
                }
                handler(land, status)
                return
            }
            handler(nil, status)
        }
    }
}