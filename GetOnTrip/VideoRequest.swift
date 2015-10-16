//
//  VideoRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/19.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class VideoRequest: NSObject {
    
    /**
    * 接口1：/api/video
    * 视频详情接口
    * @param integer page
    * @param integer pageSize
    * @param integer sightId,景点ID
    * @return json
    */
    
    // 请求参数
    var sightId :String?
    var page    :Int = 1
    var pageSize:Int = 6
    
    // 将数据回调外界
    func fetchSightListModels(handler: NSArray -> Void) {
        fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: NSArray -> Void) {
        var post         = [String: String]()
        post["sightId"]  = String(4)
        post["page"]     = String(self.page)
        post["pageSize"] = String(self.pageSize)
        
        
        // 发送网络请求加载数据
        HttpRequest.ajax(AppIni.BaseUri,
            path: "/api/video",
            post: post,
            handler: {(respData: AnyObject) -> Void in
                
                let sightVideo = NSMutableArray() // [SightBook]()
                
                for item in respData as! NSArray {
                    sightVideo.addObject(SightVideo(dict: item as! [String : AnyObject]))
                }
                
                // 回调
                handler(sightVideo)
            }
        )
    }
}

/// 视频模型
class SightVideo: NSObject {
    /// id
    var id: String?
    /// 标题
    var title: String?
    /// url
    var url: String?
    /// 图片
    var image: String? {
        didSet {
            image = AppIni.BaseUri + image!
        }
    }
    ///  时长
    var len: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
