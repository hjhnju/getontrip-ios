//
//  CyclopaedicRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/19.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class CyclopaedicRequest: NSObject {
    
    /**
    * 接口1：/api/wiki
    * 百科详情接口
    * @param integer page
    * @param integer pageSize
    * @param integer sightId,景点ID
    * @return json
    */
    
    // 请求参数
    var pageSize:Int = 2
    var curPage: Int = 1
    var sightId: Int
    
    // 初始化方法
    init(sightId: Int) {
        self.sightId = sightId
    }
    
    // 将数据回调外界
    func fetchCyclopaedicPageModels(handler:[Cyclopaedic] -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: [Cyclopaedic] -> Void) {
        var post         = [String: String]()
        post["page"]     = String(self.curPage)
        post["pageSize"] = String(self.pageSize)
        post["sightId"]  = String(self.sightId)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIniOnline.BaseUri,
            path: "/api/wiki",
            post: post,
            handler: {(respData: JSON) -> Void in
                
                var cyclopaedics = [Cyclopaedic]()
                for item in respData.arrayValue {
                    // 转换百科元素
                    let status      = item["status"].intValue
                    let content     = item["content"].stringValue
                    let title       = item["title"].stringValue
                    let image       = item["image"].stringValue
                    let create_time = item["create_time"].intValue
                    var cyc_label   = [CyclopaedicLabel]()
                    
                        // 转换百科中元素标签
                        for it in item["items"].arrayValue {
                            let id          = it["id"].intValue
                            let name        = it["name"].stringValue
                            let url         = it["url"].stringValue
                            let create_Time = it["create_time"].intValue
                            let cyclopaedic_label = CyclopaedicLabel(labelId: id, name: name, url: url, create_time: create_Time)
                            cyc_label.append(cyclopaedic_label)
                        }
                    
                    let cyclopaedicM = Cyclopaedic(status: status, content: content, title: title, image: image, create_time: create_time, items: cyc_label)
                    cyclopaedics.append(cyclopaedicM)
                }
                // 回调
                handler(cyclopaedics)
            }
        )
    }
}
