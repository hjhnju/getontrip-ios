//
//  TopicCellData.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/30.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 景点列表数据
class TopicCellData: NSObject {
    ///  默认数据的id
    var id: String = ""
    /// 标题
    var title: String = ""
    ///  副标题
    var subtitle: String = ""
    ///  访问数
    var visit: String = ""
    ///  收集数
    var collect: String = ""
    ///  来源
    var from: String = ""
    ///  图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 133, height: 84)
        }
    }
    
    /// 标签
    var tag: NSMutableArray = NSMutableArray()
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}