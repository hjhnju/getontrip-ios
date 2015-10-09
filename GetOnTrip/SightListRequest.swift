//
//  SightListRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/28.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SightListRequest: NSObject {
    
    /**
    * 接口1：/api/sight/detail
    * 景点话题列表接口
    * @param integer sightId
    * @param integer page
    * @param integer pageSize
    * @param string tags:逗号隔开的id串，如："1,2"。对于用户点击通用标签的时候，不要传景点ID，只传通用标签ID及页码信息。对于用户点击书籍标签，视频标签，景观标签，分别调用书籍模块，景观模块，视频模块的接口。
    * @return json
    */
//    http://123.57.46.229:8301/api/sight/detail?tags=1&sightId=4    
    // 请求参数
    var sightId :String?
    var page    :Int = 1
    var pageSize:Int = 6
    var tags    :String?
    var deviceId = appUUID
//    http://123.57.67.165:8301/api/sight/detail?tags
    // 将数据回调外界
    func fetchSightListModels(handler: NSDictionary -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: NSDictionary -> Void) {
        var post         = [String: String]()
        post["sightId"]  = String(4)
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        post["tags"]     = String(tags)
        post["deviceId"] = String(deviceId)
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/sight/detail",
            post: post,
            handler: {(respData: AnyObject) -> Void in
                print(respData)
                let dict = NSMutableDictionary()
                var sightTags = [SightListTags]()
                for item in respData["tags"] as! NSArray {
                    sightTags.append(SightListTags(dict: item as! [String : String]))
                }
                
                var sightData = [SightListData]()
                for item in respData["data"] as! NSArray {
                    print(item)
                    sightData.append(SightListData(dict: item as! [String : AnyObject]))
                }
                
                dict.setValue(sightTags, forKey: "sightTags")
                dict.setValue(sightData, forKey: "sightDatas")
                
                // 回调
                handler(dict.copy() as! NSDictionary)
            }
        )
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
    
    init(dict: [String: String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

/// 景点列表数据
class SightListData: NSObject {
    ///  默认数据的id
    var id: String?
    /// 标题
    var title: String?
    ///  副标题
    var subtitle: String?
    ///  访问数
    var visit: String?
    ///  收集数
    var collect: String?
    ///  来源
    var from: String?
    ///  图片
    var image: String? {
        didSet {
            image = AppIni.BaseUri + image!
        }
    }
    
    /// 标签
    var tags: NSMutableArray?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}