//
//  SightListRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/28.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SightTopicRequest: NSObject {
    
    // 请求参数
    var sightId :String = ""
    var page    :Int = 1
    var pageSize:Int = 6
    var tag     :String = ""
    
    func fetchNextPageModels(handler: ([String : AnyObject]?, Int) -> Void) {
        page = page + 1
        return fetchSightListModels(handler)
    }
    
    func fetchFirstPageModels(handler: ([String : AnyObject]?, Int) -> Void) {
        page = 1
        return fetchSightListModels(handler)
    }
    
    // 将数据回调外界
    func fetchSightListModels(handler: ([String : AnyObject]?, Int) -> Void) {
        var post         = [String: String]()
        post["sightId"]  = sightId
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        post["tags"]     = String(tag)
        // 发送网络请求加载数据
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/sight/detail", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {

                var dict = [String : AnyObject]()
                var sightTags = [SightListTags]()
                if result["tags"] != nil {
                    for item in result["tags"].arrayValue {
                        if let item = item.dictionaryObject {
                            sightTags.append(SightListTags(dict: item))
                        }
                    }
                }
                
                var sightData = [TopicCellData]()
                for item in result["data"].arrayValue {
                    if let item = item.dictionaryObject {
                        sightData.append(TopicCellData(dict: item))
                    }
                }
                
                dict["sightTags"] = sightTags
                dict["sightDatas"] = sightData
                handler(dict, status)
                return
            }
            handler(nil, status)
        }
    }
}

/// 景点列表Tags
class SightListTags: NSObject {
    /// 话题tagid
    var id: String?
    ///  类型
    var type: String?
    ///  标签名字
    var name: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
}

/// 景点列表数据
class TopicCellData: NSObject {
    ///  默认数据的id
    var id: String = ""
    /// 标题
    var title: String = ""
    ///  副标题
    var subtitle: String = ""
    ///  访问数
    var visit: String = ""
    ///  收集数
    var collect: String = ""
    ///  来源
    var from: String = ""
    ///  图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 133, height: 84)
        }
    }
    
    /// 标签
    var tag: NSMutableArray = NSMutableArray()
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}