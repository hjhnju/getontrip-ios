//
//  ThemeRequest.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation

class ThemeRequest {

    var pageSize:Int = 3
    
    //获取当前页的数据
    var curPage:Int = 1

    func fetchNextPageModels(handler: [Theme] -> Void) {
        fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler:[Theme] -> Void) {
        self.curPage = 1
        fetchModels(handler)
    }
    
    // 异步API，参数为回调函数
    private func fetchModels(handler: [Theme] -> Void){
        var post         = [String:String]()
        post["page"]     = String(self.curPage)
        post["pageSize"] = String(self.pageSize)
        
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/theme/list",
            post: post,
            handler: {(respData: JSON) -> Void in
                var themes = [Theme]()
                for it in respData.arrayValue {
                    let id       = it["id"].intValue
                    let title    = it["name"].stringValue
                    let imageUrl = AppIni.BaseUri + it["image"].stringValue
                    let period   = it["period"].stringValue
                    
                    var theme  = Theme(id: id, period: period, title: title, image: imageUrl)
                    theme.favorites = it["collect"].intValue
                    themes.append(theme)
                }
                if themes.count > 0 {
                    self.curPage = self.curPage + 1
                }
                handler(themes)
            }
        )
    }
}
