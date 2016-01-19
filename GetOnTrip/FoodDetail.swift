//
//  FoodBrief.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/19.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class FoodDetail: ModelObject {

    /// id
    lazy var id: String = ""
    /// 标题
    lazy var title: String = ""
    /// 内容
    lazy var content: String = ""
    /// 图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 133, height: 84)

        }
    }
    /// 商店数量
    lazy var shopNum: String = ""
    /// 店铺详情模型
    var shopDetails: [ShopDetail] = [ShopDetail]()
    /// 话题详情模型
    var topicDetails: [FoodTopicDetail] = [FoodTopicDetail]()
    /// 自身标题的行高
    lazy var headerHeight: CGFloat = 0
    
    /* 特产 */
    /// 特产数量
    lazy var productNum = ""
    
    override init() {
        super.init()
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
        
        if let data = dict["shops"] as? NSArray {
            for item in data as? [[String : String]] ?? [[String : String]]() {
                shopDetails.append(ShopDetail(dict: item))
            }
        }
        
        if let data = dict["products"] as? NSArray {
            for item in data as? [[String : String]] ?? [[String : String]]() {
                shopDetails.append(ShopDetail(dict: item))
            }
        }
        
        if let data = dict["topics"] as? NSArray {
            for item in data as? [[String : String]] ?? [[String : String]]() {
                topicDetails.append(FoodTopicDetail(dict: item))
            }
        }
        
        /// 计算自身行高
        headerHeight = FoodHeaderContentViewCell.heightWithString(content)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}

/// 商店详情
class ShopDetail: ModelObject {
    /// id
    lazy var id = ""
    /// 标题
    lazy var title = ""
    /// 地扯
    lazy var addr = ""
    /// 评分
    lazy var score = ""
    /// 价格
    lazy var price: String = ""
    /// url
    lazy var url: String = ""
    /// 图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 133, height: 84)
        }
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
}

/// 美食详情
class FoodTopicDetail: ModelObject {
    /// id
    lazy var id = ""
    /// 标题
    lazy var title = ""
    /// 描述
    lazy var desc = ""
    /// 图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: 133, height: 84)
        }
    }
    /// 访问
    lazy var visit = ""
    /// 点赞
    lazy var praise: String = ""
    /// url
    lazy var url = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
}

