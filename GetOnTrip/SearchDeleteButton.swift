//
//  SearchDeleteButton.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/9.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SearchDeleteButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame.origin.x = frame.width - (imageView?.frame.width ?? 0) - 9
    }
}
