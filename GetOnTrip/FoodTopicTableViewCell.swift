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
                
//                titleLabel.font = UIFont(name: Font.PingFangSCRegular ?? Font.ios8Font, size: 15)
                subtitleLabel.font = UIFont(name: Font.PingFangSCLight ?? Font.ios8Font, size: 12)
                
                iconView.backgroundColor = cellData.bgColor
                //是否加载网络图片
                if UserProfiler.instance.isShowImage() {
                    iconView.sd_setImageWithURL(NSURL(string: cellData.image))
                }
                
                subtitleLabel.text = cellData.desc
                titleLabel.attributedText = cellData.title.getAttributedString(0, lineSpacing: 1, breakMode: .ByTruncatingTail, fontName: Font.PingFangSCRegular, fontSize: 15)
                praise.setTitle(" " + cellData.praise, forState: .Normal)
                preview.setTitle(" " + cellData.visit, forState: .Normal)
            }
        }
    }
    
    override func initAutoLayout() {
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 133 - 24
        iconView.ff_AlignInner(.CenterLeft, referView: self, size: CGSizeMake(133, 84), offset: CGPointMake(9, 0))
        subtitleLabel.ff_AlignHorizontal(.TopRight, referView: iconView, size: CGSizeMake(w, 19), offset: CGPointMake(6, -2.5))
        titleLabel.ff_AlignVertical(.BottomLeft, referView: subtitleLabel, size: nil, offset: CGPointMake(0, 0))
        praise.ff_AlignHorizontal(.BottomRight, referView: iconView, size: nil, offset: CGPointMake(6, 2))
        preview.ff_AlignHorizontal(.CenterRight, referView: praise, size: nil, offset: CGPointMake(8, 0))
        baseLine.ff_AlignInner(.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5))
    }
}
