//
//  Specialty.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/18.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class Specialty: ModelObject {
    /// id
    var id: String = ""
    /// 详情数量
    var topicNum: String = ""
    /// 产品数量
    var productNum: String = ""
    /// 标题
    var title: String = ""
    /// 内容
    var content: String = ""
    /// 描述
    var desc: String = ""
    /// 所在景点
    var sightid = ""
    /// 图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 133, height: 84)
        }
    }
    /// url
    var url: String = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
}
