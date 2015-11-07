//
//  RecommendCellData.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/5.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

struct RecommendCellType  {
    static let TypeCity  = "2"
    static let TypeSight = "1"
}

/// 搜索数据
class RecommendCellData: NSObject {
    
    //id
    var id: String = ""
    //标题
    var name: String = ""
    //图片
    var image: String = "" {
        didSet {
            image = UIKitTools.sliceImageUrl(image, width: Int(UIScreen.mainScreen().bounds.width), height: Int(RecommendTableViewCell.RowHeight))
        }
    }
    
    var param1: String = ""
    
    var param2: String = ""
    
    var param3: String = ""
    
    //城市＝2，景点＝1
    var type: String = RecommendCellType.TypeSight
    
    init(dict: [String: AnyObject]) {
        super.init()
        //
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    func isTypeCity() -> Bool {
        return self.type == RecommendCellType.TypeCity ? true : false
    }
}
