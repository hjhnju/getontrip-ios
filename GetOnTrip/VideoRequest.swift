//
//  VideoRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/19.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class VideoRequest: NSObject {
    
    // 请求参数
    var sightId :String = ""
    var page    :Int = 1
    var pageSize:Int = 6
    
    func fetchNextPageModels(handler: (NSArray?, Int) -> Void) {
        page = page + 1
        return fetchVideoListModels(handler)
    }
    
    func fetchFirstPageModels(handler: (NSArray?, Int) -> Void) {
        page = 1
        return fetchVideoListModels(handler)
    }
    
    // 异步加载获取数据
    func fetchVideoListModels(handler: (NSArray?, Int) -> Void) {
        var post         = [String: String]()
        post["sightId"]  = sightId
        post["page"]     = String(self.page)
        post["pageSize"] = String(self.pageSize)
        
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/video", post: post) { (result, status) -> () in
            
            if status == RetCode.SUCCESS {
                var sightVideo = [SightVideo]()
                for item in result.arrayValue {
                    if let item = item.dictionaryObject {
                        sightVideo.append(SightVideo(dict: item))
                    }
                }
                handler(sightVideo, status)
                return
            }
            handler(nil, status)
        }
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
    var image: String = "" {
        didSet {
            image = AppIni.BaseUri + image
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
