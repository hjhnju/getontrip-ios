//  所有Model的基类
//  ModelObject.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/12/18.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class ModelObject: NSObject {
    
    //默认随机颜色属性
    var bgColor: UIColor = SceneColor.randomColor()
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}