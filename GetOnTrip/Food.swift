//
//  Food.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/18.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class Food: ModelObject {
    /// id
    var id: String = ""
    /// 商店数量
    var shopNum: String = ""
    /// 相关话题数量
    var topicNum: String = ""
    /// 标题
    var title: String = ""
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
    /// 食物url
    var url: String = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
}
