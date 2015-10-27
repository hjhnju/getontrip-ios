//
//  SightListRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/28.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SightTopicRequest: NSObject {
    
    /**
    * 接口1：/api/sight/detail
    * 景点话题列表接口
    * @param integer sightId
    * @param integer page
    * @param integer pageSize
    * @param string deviceId，用户的设备ID（因为要统计UV）
    * @param string tags:逗号隔开的id串，如："1,2"。
    * 对于用户点击书籍标签，视频标签，景观标签，分别调用书籍模块，景观模块，视频模块的接口。
    * @return json
    */
    
    // 请求参数
    var sightId :String = ""
    var page    :Int = 1
    var pageSize:Int = 6
    var tag : String = ""
    var deviceId = appUUID
    // 将数据回调外界
    func fetchSightListModels(handler: NSDictionary -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: NSDictionary -> Void) {
        var post         = [String: String]()
        post["sightId"]  = sightId
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        post["tags"]     = String(tag)
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/sight/detail", post: post) { (result, error) -> () in
            if error == nil {
                let data = result!["data"]
                let dict = NSMutableDictionary()
                var sightTags = [SightListTags]()
                
                if data!!["tags"] != nil {
                    for item in data!!["tags"] as! NSArray {
                        sightTags.append(SightListTags(dict: item as! [String : AnyObject]))
                    }
                }
                
                var sightData = [SightListData]()
                if data!!["data"] != nil {
                    for item in data!!["data"] as! NSArray {
                        sightData.append(SightListData(dict: item as! [String : AnyObject]))
                    }
                }
                
                dict.setValue(sightTags, forKey: "sightTags")
                dict.setValue(sightData, forKey: "sightDatas")
                
                // 回调
                handler(dict.copy() as! NSDictionary)
            }
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
    var tag: NSMutableArray?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}