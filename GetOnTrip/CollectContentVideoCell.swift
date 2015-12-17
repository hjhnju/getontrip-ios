
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
//    lazy var coverView = UIView(color: UIColor.blackColor())
    /// 播放图片
    lazy var playImageView = UIImageView(image: UIImage(named: "play_white"))
    
    override func overrideBeforeAction() {

        iconView.addSubview(playImageView)
        playImageView.ff_AlignInner(.CenterCenter, referView: iconView, size: nil)
    }
    
    override func overrideAfterAction() {
        if #available(iOS 9.0, *) {
            titleLabel.font = UIFont(name: Font.defaultFont, size: 16)
        } else {
            titleLabel.font = UIFont(name: Font.ios8Font, size: 16)
        }
        titleLabel.textColor = SceneColor.frontBlack
        titleLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 147
        titleLabel.numberOfLines = 2
        subtitleLabel.hidden = true
        titleLabel.ff_AlignHorizontal(.TopRight, referView: iconView, size: nil, offset: CGPointMake(9, 0))        
    }
    
    override var data: AnyObject? {
        didSet {
            if let collectContent = data as? CollectContent {
                iconView.sd_setImageWithURL(NSURL(string: collectContent.image), placeholderImage: PlaceholderImage.defaultSmall, completed: { (image, error, cacheType, url) -> Void in
                    if image != nil {
                        self.iconView.image = UIImageView.imageByApplyingImage(image, blurRadius: 0.2).scaleImage(140)
                    }
                })
                
                titleLabel.text = collectContent.title
                praise.setTitle(" " + collectContent.praise ?? "", forState: .Normal)
                visit.setTitle(" " + collectContent.visit ?? "", forState: .Normal)
            }
        }
    }

}
