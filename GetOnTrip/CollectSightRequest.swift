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
    
    static let sharedCollectType = CollectSightRequest()
    
    // 异步加载话题获取数据
    func fetchCollectionModels(type: Int, handler: [AnyObject] -> Void) {
        var post       = [String: String]()
        post["type"]   = String(type)
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/collect/list", post: post) { (result, error) -> () in
            if error == nil {
                var collectSightMT = [CollectCity]()
                var collectSightMS = [CollectSight]()
                var collectSightMC = [CollectContent]()
                
                for it in result!["data"] as! NSArray {
                    switch type {
                    case 1:
                        collectSightMC.append(CollectContent(dict: it as! [String : AnyObject]))
                    case 2:
                        collectSightMS.append(CollectSight(dict: it as! [String : AnyObject]))
                    default:
                        collectSightMT.append(CollectCity(dict: it as! [String : AnyObject]))
                        break
                    }
                }
                
                switch type {
                case 1:
                    handler(collectSightMC)
                case 2:
                    handler(collectSightMS)
                default:
                    handler(collectSightMT)
                    break
                }
            }
        }
//        HttpRequest.ajax(AppIni.BaseUri,
//            path: "/api/collect/list",
//            post: post,
//            handler: {(respData: AnyObject) -> Void in
//                
//                var collectSightMT = [CollectCity]()
//                var collectSightMS = [CollectSight]()
//                var collectSightMC = [CollectContent]()
//                
//                for it in respData as! NSArray {
//                    switch type {
//                    case 1:
//                        collectSightMC.append(CollectContent(dict: it as! [String : AnyObject]))
//                    case 2:
//                        collectSightMS.append(CollectSight(dict: it as! [String : AnyObject]))
//                    default:
//                        collectSightMT.append(CollectCity(dict: it as! [String : AnyObject]))
//                        break
//                    }
//                }
//                
//                switch type {
//                case 1:
//                    handler(collectSightMC)
//                case 2:
//                    handler(collectSightMS)
//                default:
//                    handler(collectSightMT)
//                    break
//                }
//            }
//        )
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
            image = AppIni.BaseUri + image
        }
    }

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
    var image: String = "" {
        didSet {
            image = AppIni.BaseUri + image
        }
    }
    /// 副标题
    var subtitle: String = ""

    var type: String = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
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
            image = AppIni.BaseUri + image
        }
    }
    var name: String = ""
    
    var topicNum: String = ""

    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}