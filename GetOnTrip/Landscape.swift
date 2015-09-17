//
//  Landscape.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/9/2.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation

class Landscape {
    var id: Int
    
    var imageUrl: String?
    
    var name: String
    
    //距离
    var distance: String?
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
}