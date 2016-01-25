//
//  Landscape.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/30.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import CoreLocation

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
            imageHeader      = UIKitTools.sliceImageUrl(image, width: Int(Frame.screen.width), height: 200)
            image            = UIKitTools.sliceImageUrl(image, width: 119, height: 84)
        }
    }
    
    
    lazy var imageHeader: String = ""
    /// 必玩标签
    lazy var desc = ""
    /// 音频
    var audio = "" {
        didSet {
            audio = AppIni.BaseResourceUri + audio
        }
    }
    /// 音频长度
    lazy var audio_len = "00:00"
    /// 经度
    var x = "0"
    /// 纬度
    var y = "0"
    /// 距离
    lazy var dis = ""
    /// 单位
    lazy var dis_unit = ""
    /// 位置
    var location: CLLocation?// = CLLocation(latitude: CLLocationDegrees(0), longitude: CLLocationDegrees(0))
    /// 相距位置 用此排序
    var apartLocation: CLLocationDistance = 0
    
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        location = CLLocation(latitude: CLLocationDegrees(Double(y) ?? 0), longitude: CLLocationDegrees(Double(x) ?? 0))
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}