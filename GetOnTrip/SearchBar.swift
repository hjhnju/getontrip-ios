//
//  SearchBar.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/8.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SearchBar: UISearchBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 111)
    }
    
}
