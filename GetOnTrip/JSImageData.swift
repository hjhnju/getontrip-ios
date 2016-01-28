//
//  JSImageData.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/27.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class JSImageData: NSObject {
    
    lazy var x: Int = 0
    lazy var y: Int = 0
    lazy var w: Int = 0
    lazy var h: Int = 0

    lazy var desc: String = ""
    lazy var src: String = ""
    
    var frame: CGRect = CGRectZero
    
    init(dict: [String : AnyObject]) {
        super.init()
        x = dict["x"] as! Int
        y = dict["y"] as! Int
        w = dict["w"] as! Int
        h = dict["h"] as! Int
        desc = (dict["desc"] as? String) ?? ""
        src = (dict["src"] as? String) ?? ""
    }
}
