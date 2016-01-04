//
//  FavoriteRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/8.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class CollectSightRequest: NSObject {
    
    // 请求参数
    var page    : Int = 1
    var pageSize: Int = 6
    var type    : Int = 0
    
    static let sharedCollectType = CollectSightRequest()
    
    func fetchNextPageModels(handler: ([AnyObject]?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: ([AnyObject]?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }
    
    // 异步加载话题获取数据
    func fetchModels(handler: ([AnyObject]?, Int) -> Void) {
        var post       = [String: String]()
        post["type"]   = String(type)
        post["page"]   = String(page)
        post["pageSize"] = String(pageSize)
        
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/collect/list", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var collectSightMT = [CollectCity]()
                var collectSightMS = [CollectSight]()
                var collectSightMC = [CollectContent]()
                for it in result.arrayValue {
                    switch self.type {
                    case 1:
                        collectSightMC.append(CollectContent(dict: it.dictionaryObject!))
                    case 2:
                        collectSightMS.append(CollectSight(dict: it.dictionaryObject!))
                    case 3:
                        collectSightMT.append(CollectCity(dict: it.dictionaryObject!))
                    default:
                        break
                    }
                }
                
                switch self.type {
                case 1:
                    handler(collectSightMC, status)
                case 2:
                    handler(collectSightMS, status)
                default:
                    handler(collectSightMT, status)
                    break
                }
            } else {
                handler(nil, status)
            }
        }
    }
}


/// 景点
class CollectSight: NSObject {
    
    /// 收藏话题id
    var id: String = ""
    /// 话题名
    var name: String = ""
    /// 话题图片

    var image: String = "" {
        didSet {
            let w: Int = Int((Frame.screen.width - 57) / 3)
            image = UIKitTools.sliceImageUrl(image, width: w, height: w)
        }
    }
    
    var content: String = ""
    
    var collect: String = ""
    
    /// 共几个话题
    var topicNum: String = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

/// 收藏内容
class CollectContent: NSObject {
    /// 收藏话题id
    var id: String = ""
    /// 标题
    var title: String = ""
    /// 收藏数
    var collect: String = ""
    /// 图片
    var image: String = ""
    
    var visit: String = ""
    /// 作者
    var author: String = ""
    /// 副标题
    var subtitle: String = ""
    /// 点赞
    var praise: String = ""

    var type: String = ""
    
    var url: String = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
        
        image = UIKitTools.sliceImageUrl(image, width: 120, height: 73)
        if String(dict["type"]) == String(FavoriteContant.TypeBook) {
            image = UIKitTools.sliceImageUrl(image, width: 120, height: 91)
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

class CollectCity: NSObject {
    
    /// 收藏主题id
    var id: String = ""
    /// 图片
    var image: String = "" {
        didSet {
            let w: Int = Int((Frame.screen.width - 57) / 3)
            image = UIKitTools.sliceImageUrl(image, width: w, height: w)
        }
    }
    var name: String = ""
    
    var topicNum: String = ""
    
    var content: String = ""
    
    var collect: String = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}