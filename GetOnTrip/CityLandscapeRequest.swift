//
//  CityLandscapeRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/29.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class CityLandscapeRequest: NSObject {
    
    // 请求参数
    var cityId :String = ""
    var page    :Int = 1
    var pageSize:Int = 100
    
    func fetchNextPageModels(handler: (CityLandscape?, Int) -> Void) {
        page = page + 1
        return fetchModels(handler)
    }
    
    func fetchFirstPageModels(handler: (CityLandscape?, Int) -> Void) {
        page = 1
        return fetchModels(handler)
    }
    
    // 异步加载获取数据
    func fetchModels(handler: (CityLandscape?, Int) -> Void) {
        var post         = [String: String]()
        post["cityId"]   = cityId
        post["page"]     = String(self.page)
        post["pageSize"] = String(self.pageSize)
        post["x"]        = LocateToCity.sharedLocateToCity.x
        post["y"]        = LocateToCity.sharedLocateToCity.y
        // 发送网络请求加载数据
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/city/landscape", post: post) { (result, status) -> () in
            
            if status == RetCode.SUCCESS {
                if let resu = result.dictionaryObject {
                    handler(CityLandscape(dict: resu), status)
                }
                return
            }
            handler(nil, status)
        }
    }
}

class CityLandscape: ModelObject {
    /// id
    lazy var id: String = ""
    ///  标题名称
    lazy var name: String = ""
    /// 图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: Int(Frame.screen.width), height: 169)
        }
    }
    ///  描述
    lazy var des: String = ""
    /// 距离
    lazy var dis: String = ""
    ///  音频
    lazy var audio: String = ""
    /// 音频长度
    lazy var audio_len: String = ""
    /// 景点id
    lazy var landscape_id = ""
    /// 景观
    lazy var sights: [Landscape] = [Landscape]()
    
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        sights.removeAll()
        if let sight = dict["sight"] as? NSArray {
            for item in sight {
                if let dic = item as? [String : AnyObject] {
                    sights.append(Landscape(dict: dic))
                }
            }
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}