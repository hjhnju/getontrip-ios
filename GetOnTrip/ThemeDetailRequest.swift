//
//  ThemeDetailRequest.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/9/2.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation

class ThemeDetailRequest {
    
    var pageSize:Int = 1
    
    //获取当前页的数据
    var curPage:Int = 1
    
    var theme: Theme
    
    init(theme: Theme){
        self.theme = theme
    }
    
    func fetchNextPageModels(handler: () -> Void) {
        fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler:() -> Void) {
        self.curPage = 1
        fetchModels(handler)
    }
    
    // 异步API，参数为回调函数
    private func fetchModels(handler: () -> Void){
        var post         = [String:String]()
        post["page"]     = String(self.curPage)
        post["pageSize"] = String(self.pageSize)
        post["id"]       = String(self.theme.id)
        
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/theme/detail",
            post: post,
            handler: {(respData: JSON) -> Void in
                self.theme.favorites = respData["collect"].intValue
                self.theme.content = respData["content"].stringValue
                if self.theme.imageUrl == nil {
                    self.theme.imageUrl = respData["image"].stringValue
                }
                self.theme.landscape.removeAll(keepCapacity: false)
                
                //for test
                //self.theme.imageUrl = AppIni.BaseUri + "/pic/878648ee0ee3e652.jpg"
                //self.theme.image    = nil
                //self.theme.content = "是具有溶蚀力的水对可溶性岩石（大多为石灰岩）进行溶蚀等作用所形成的地表和地下形态的总称，又称溶岩地貌。除溶蚀作用以外，还包括流水的冲蚀、潜蚀，以及坍陷等机械侵蚀过程。喀斯特（Karst）一词源自前南斯拉夫西北部伊斯特拉半岛碳酸盐岩高原的名称，当地称谓，意为岩石裸露的具有溶蚀力的水对可溶性岩石（大多为石灰岩）进行溶蚀等作用所形成的地表和地下形态的总称，又称溶岩地貌。除溶蚀作用以外，还包括流水的冲蚀、潜蚀"
                //test
                
                for item in respData["landscape"].arrayValue {
                    let id = item["id"].intValue
                    let name = item["name"].stringValue
                    let image = item["image"].stringValue
                    let landsc = Landscape(id: id, name: name)
                    landsc.imageUrl = image
                    self.theme.landscape.append(landsc)
                }
                handler()
            }
        )
    }
}
