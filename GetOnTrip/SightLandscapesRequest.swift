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
    var pageSize:Int = 10
    var enterInfo:String = "sight"
    
    func fetchNextPageModels(handler: ([Landscape]?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: ([Landscape]?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: ([Landscape]?, Int) -> Void) {
        var post         = [String: String]()
        if enterInfo == "sight" {
            post["sightId"]  = sightId
        } else {
            post["cityId"]   = sightId
        }
        post["page"]     = String(self.page)
        post["pageSize"] = String(self.pageSize)
        post["x"]        = LocateToCity.sharedLocateToCity.x
        post["y"]        = LocateToCity.sharedLocateToCity.y
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/\(enterInfo)/landscape", post: post) { (result, status) -> () in

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