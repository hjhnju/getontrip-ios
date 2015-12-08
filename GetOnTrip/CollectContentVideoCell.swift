
//
//  CollectContentVideoCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/24.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CollectContentVideoCell: BaseTableViewCell {
    
    /// 图片模糊
    lazy var coverView = UIView(color: UIColor.blackColor())
    /// 播放图片
    lazy var playImageView = UIImageView(image: UIImage(named: "play_white"))
    
    override func overrideBeforeAction() {

        iconView.addSubview(coverView)
        iconView.addSubview(playImageView)
        coverView.alpha = 0.3
        coverView.ff_Fill(iconView)
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
                iconView.sd_setImageWithURL(NSURL(string: collectContent.image), placeholderImage: PlaceholderImage.defaultSmall, completed: { (image, error, cacheType, url) -> Void in
                    self.iconView.image = UIImageView.imageByApplyingImage(image)
                })
                
                titleLabel.text = collectContent.title
                praise.setTitle(" " + collectContent.praise ?? "", forState: .Normal)
                visit.setTitle(" " + collectContent.visit ?? "", forState: .Normal)
            }
        }
    }

}
