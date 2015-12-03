
//
//  CollectContentVideoCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/24.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CollectContentVideoCell: BaseTableViewCell {
    
    /// 模糊类
    lazy var blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
    
    /// 播放图片
    lazy var playImageView = UIImageView(image: UIImage(named: "play_white"))
    
    override func overrideBeforeAction() {

        iconView.addSubview(blurView)
        iconView.addSubview(playImageView)
//        blurView.contentView.alpha = 0.1
        blurView.alpha = 0.3
        blurView.ff_Fill(iconView)
        playImageView.ff_AlignInner(.CenterCenter, referView: iconView, size: nil)
    }
    
    override func overrideAfterAction() {
        titleLabel.font = UIFont.systemFontOfSize(16)
        titleLabel.textColor = SceneColor.frontBlack
        titleLabel.preferredMaxLayoutWidth = 146
        titleLabel.numberOfLines = 2
        subtitleLabel.hidden = true
        titleLabel.ff_AlignHorizontal(.TopRight, referView: iconView, size: nil, offset: CGPointMake(9, 0))
    }
    
    override var data: AnyObject? {
        didSet {
            if let collectContent = data as? CollectContent {
                iconView.sd_setImageWithURL(NSURL(string: collectContent.image))
                titleLabel.text = collectContent.title
                praise.setTitle(" " + collectContent.praise ?? "", forState: .Normal)
                visit.setTitle(" " + collectContent.visit ?? "", forState: .Normal)
            }
        }
    }

}
