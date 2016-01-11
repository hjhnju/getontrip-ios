//
//  HomeSearchCityRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

struct RecommendLoadType  {
    static let TypeLabelAndImages = 1
    static let TypeContent        = 2
}

class RecommendRequest: NSObject {
    
    // 请求参数
    var order   : String = "1"
    var page    : Int = 1
    var pageSize: Int = 15
    var isLoadType: Int = RecommendLoadType.TypeLabelAndImages
    
    
    func fetchNextPageModels(handler: (RecommendModel?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: (RecommendModel?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }

    // 异步加载获取数据
    func fetchModels(handler: (RecommendModel?, Int) -> Void) {
        var post         = [String: String]()
        post["order"]    = String(order)
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        post["x"]        = LocateToCity.sharedLocateToCity.x
        post["y"]        = LocateToCity.sharedLocateToCity.y
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/search/label", post: post) { (data, status) -> () in
            if status == RetCode.SUCCESS {
                // 回调
                handler(self.dataWithModel(data), status)
                return
            }
            handler(nil, status)
        }
    }
    
    ///  数据转换模型
    func dataWithModel(data: JSON) -> RecommendModel {
        let searchModel = RecommendModel()
        
        if isLoadType == RecommendLoadType.TypeLabelAndImages {
            for item in data["images"].arrayValue {
                let url = UIKitTools.sliceImageUrl(item["url"].stringValue, width: Int(Frame.screen.width), height: 244)
                print(url)
                searchModel.images.append(url)
            }
        } else if isLoadType == RecommendLoadType.TypeContent {
            for item in data["content"].arrayValue {
                if let item = item.dictionaryObject {
                    searchModel.contents.append(RecommendCellData(dict: item))
                }
            }
        }
        for item in data["label"].arrayValue {
            if let item = item.dictionaryObject {
                searchModel.labels.append(RecommendLabel(dict: item))
            }
        }
        return searchModel
    }
}

//TODO: - 模型数据不是同时都有值，labels和images有值时，contents就无值，否则相反
class RecommendModel {
    
    lazy var labels = [RecommendLabel]()
    
    lazy var contents = [RecommendCellData]()
    
    lazy var images = [String]()
}
