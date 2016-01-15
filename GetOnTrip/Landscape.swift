//
//  Landscape.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/30.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 景点景观Cell数据
class Landscape: ModelObject {
    /// id
    lazy var id: String = ""
    ///  标题名称
    lazy var name: String = ""
    ///  副标题内容
    lazy var content: String = ""
    ///  url
    lazy var url: String = ""
    /// 图片
    var image: String = "" {
        didSet {
            detailBackground = UIKitTools.sliceImageUrl(image, width: Int(Frame.screen.width), height: Int(Frame.screen.height))
            imageHeader      = UIKitTools.sliceImageUrl(image, width: Int(Frame.screen.width), height: 200)
            image            = UIKitTools.sliceImageUrl(image, width: 119, height: 84)
        }
    }
    
    lazy var detailBackground: String = ""
    
    lazy var imageHeader: String = ""
    
    // TODO: 以下，后台暂时未添加
    /// 必玩标签
    lazy var desc = ""
    /// 音频
    lazy var audio = "/audio/fd6f5bc4b4514c759ae44600f5b9580b.mp3"
    /// 音频长度
    lazy var audio_len = "00:00"
    /// 地理位置 
    lazy var location = "666"
    /// 经度
    lazy var x = "0"
    /// 纬度
    lazy var y = "0"
    
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        audio = "/audio/fd6f5bc4b4514c759ae44600f5b9580b.mp3"
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}