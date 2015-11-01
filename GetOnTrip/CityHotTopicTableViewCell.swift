//
//  HomeCityCententTopicCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SDWebImage

class CityHotTopicTableViewCell: UITableViewCell {

    /// 图片
    var iconView: UIImageView = UIImageView()
    /// 标题
    var title: UILabel = UILabel(color: UIColor.whiteColor(), title: "", fontSize: 15, mutiLines: true)
    /// 副标题
    var subTitle: UILabel = UILabel(color: SceneColor.whiteGrey, title: "", fontSize: 11, mutiLines: false)
    /// 标签
    var label: UILabel = UILabel(color: SceneColor.whiteGrey, title: "", fontSize: 9, mutiLines: false)
    /// 浏览数
    var visit: UIButton = UIButton(title: "", fontSize: 9, radius: 0, titleColor: SceneColor.whiteGrey)
    /// 底线
    var baseView: UIView = UIView(color: UIColor.whiteColor(), alphaF: 0.3)
    
    var topic: BriefTopic? {
        didSet {
            if let topic = topic {
                iconView.sd_setImageWithURL(NSURL(string: topic.image), placeholderImage:PlaceholderImage.defaultSmall)
                title.text = topic.title
                subTitle.text = topic.subtitle
                label.text = "\(topic.sight)・\(topic.tag)"
                visit.setTitle("   " + topic.visit, forState: UIControlState.Normal)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(title)
        addSubview(label)
        addSubview(visit)
        addSubview(baseView)
        addSubview(iconView)
        addSubview(subTitle)
        
        backgroundColor = UIColor.clearColor()
        label.alpha = 0.5
        visit.setImage(UIImage(named: "topic_eye_gray"), forState: UIControlState.Normal)
        title.numberOfLines = 2
        subTitle.numberOfLines = 2
        title.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 148
        iconView.contentMode                  = UIViewContentMode.ScaleAspectFill
        iconView.clipsToBounds                = true
        
        iconView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(124, 84), offset: CGPointMake(9, 0))
        subTitle.ff_AlignHorizontal(ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPointMake(6, 0))
        title.ff_AlignVertical(ff_AlignType.BottomLeft, referView: subTitle, size: nil, offset: CGPointMake(0, 5))
        label.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPointMake(9, 0))
        visit.ff_AlignInner(ff_AlignType.BottomRight, referView: self, size: CGSizeMake(33, 11), offset: CGPointMake(-9, -10))
        baseView.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 19, 0.5), offset: CGPointMake(0, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
