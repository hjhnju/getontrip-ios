//
//  SettingButton.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/27.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SettingButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = CGRectMake(12, 0, 22, 22)
    }

}
