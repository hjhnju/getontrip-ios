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
                shopLabel.text = "个名品推荐，"
                iconView.backgroundColor = cellData.bgColor
                //是否加载网络图片
                if UserProfiler.instance.isShowImage() {
                    iconView.sd_setImageWithURL(NSURL(string: cellData.image))
                }
                shopNumLabel.text = cellData.productNum
                topicNumLabel.text = cellData.topicNum
                compulsoryView.hidden  = cellData.desc == "" ? true : false
                compulsoryLabel.hidden = cellData.desc == "" ? true : false
                compulsoryLabel.text = cellData.desc
                
                subtitleLabel.text = cellData.content
                titleLabel.text = cellData.title
            }
        }
    }

}
