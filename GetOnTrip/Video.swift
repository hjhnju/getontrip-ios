//
//  Viedio.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/30.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

struct VideoContant {
    static let TypeAlbum: String = "1"
    static let TypeVideo: String = "2"
}

/// 视频模型
class Video: ModelObject {
    /// id
    var id: String = ""
    /// 标题
    var title: String = ""
    /// url
    var url: String = ""
    /// 图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 414, height: 199)
            image = UIKitTools.blurImageUrl(image, radius: 9, sigma: 3)
        }
    }
    /// 类型1-专辑，2-视频
    var type: String = VideoContant.TypeVideo
    ///  时长
    var len: String = ""
    
    var collected: String = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override init() {
        super.init()
    }
    
    func isAlbum() -> Bool {
        return (type == VideoContant.TypeAlbum) ? true : false
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}