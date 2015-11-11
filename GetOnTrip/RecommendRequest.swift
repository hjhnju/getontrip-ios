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

class RecommendRequest: NSObject {
    
    // 请求参数
    var label   : String = ""
    var page    : Int = 1
    var pageSize: Int = 6
    
    func fetchNextPageModels(handler: (NSDictionary?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: (NSDictionary?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }

    // 异步加载获取数据
    func fetchModels(handler: (NSDictionary?, Int) -> Void) {
        var post         = [String: String]()
        post["label"]    = String(label)
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        
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
    func dataWithModel(data: JSON) -> NSMutableDictionary {
        let searchModel = NSMutableDictionary()
        var searchLabels = [RecommendLabel]()
        var searchDatas = [RecommendCellData]()
        for item in data["label"].arrayValue {
            if let item = item.dictionaryObject {
                searchLabels.append(RecommendLabel(dict: item))
            }
        }
        for item in data["content"].arrayValue {
            if let item = item.dictionaryObject {
                searchDatas.append(RecommendCellData(dict: item))
            }
        }
        
        searchModel.setValue(searchLabels, forKey: "labels")
        searchModel.setValue(searchDatas, forKey: "cells")
        let url = UIKitTools.sliceImageUrl(data["image"].stringValue, width: Int(UIScreen.mainScreen().bounds.width), height: 244)
        searchModel.setValue(url, forKey: "image")
        return searchModel
    }
}