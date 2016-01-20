//
//  FoodTopicTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/19.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class FoodTopicTableViewCell: TopicCell {

    override var data: AnyObject? {
        didSet {
            if let cellData = data as? FoodTopicDetail {
                
                contentView.backgroundColor = SceneColor.greyWhite
                
                titleLabel.font = UIFont(name: Font.PingFangSCLight ?? Font.ios8Font, size: 15)
                subtitleLabel.font = UIFont(name: Font.PingFangSCLight ?? Font.ios8Font, size: 12)
                
                iconView.backgroundColor = cellData.bgColor
                //是否加载网络图片
                if UserProfiler.instance.isShowImage() {
                    iconView.sd_setImageWithURL(NSURL(string: cellData.image))
                }
                
                subtitleLabel.text = cellData.desc
                titleLabel.text = cellData.title
                praise.setTitle(" " + cellData.praise, forState: .Normal)
                preview.setTitle(" " + cellData.visit, forState: .Normal)
            }
        }
    }
}
