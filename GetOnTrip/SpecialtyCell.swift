//
//  SpecialtyCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/18.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class SpecialtyCell: FoodCell {

   override var data: AnyObject? {
        didSet {
            if let cellData = data as? Specialty {
                iconView.backgroundColor = cellData.bgColor
                //是否加载网络图片
                if UserProfiler.instance.isShowImage() {
                    iconView.sd_setImageWithURL(NSURL(string: cellData.image))
                }
                
                compulsoryView.hidden  = cellData.desc == "" ? true : false
                compulsoryLabel.hidden = cellData.desc == "" ? true : false
                
                subtitleLabel.text = cellData.desc
                titleLabel.text = cellData.title
            }
        }
    }

}
