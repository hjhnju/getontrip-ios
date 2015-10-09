//
//  Theme.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

class Theme {
    
    var id: Int!
    
    var title: String!
    
    var imageUrl: String!
    
    //保存已抓取过的图片
    var image: UIImage?
    
    var period: String!
    
    var favorites: Int = 0
    
    var content: String = ""
    
    var landscape = [Landscape]()
    
    init(id: Int, period: String, title: String, image: String){
        self.id     = id
        self.period = period
        self.title  = title
        self.imageUrl = image
    }
    
    func hasDetail() -> Bool {
        if !content.isEmpty || landscape.count>0 {
            return true
        }
        return false
    }
}