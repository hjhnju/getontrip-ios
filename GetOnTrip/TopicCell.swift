//
//  HistoryCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/3/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class TopicCell: UITableViewCell {
    
    /// 图片
    lazy var iconView: UIImageView = UIImageView()
    
    ///  副标题
    lazy var subtitleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "密道传说常年有", fontSize: 14, mutiLines: false)
    
    ///  标题
    lazy var titleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "故宫内真有密道吗？如果有入口在哪里？", fontSize: 18, mutiLines: false)
    
    //收藏
    lazy var praise: UIButton = UIButton(image: "icon_star_gray", title: " 1", fontSize: 12, titleColor: UIColor(hex: 0x2A2D2E, alpha: 0.6))
    
    //浏览
    lazy var preview: UIButton = UIButton(image: "icon_eye_gray", title: " 1", fontSize: 12, titleColor: UIColor(hex: 0x2A2D2E, alpha: 0.6))
    
    lazy var baseLine: UIView = UIView(color: UIColor(hex: 0x979797, alpha: 0.3))
    
    var data: TopicBrief? {
        didSet {

            if let cellData = data {
                iconView.image = nil
                iconView.sd_setImageWithURL(NSURL(string: cellData.image), placeholderImage: PlaceholderImage.defaultSmall)
                subtitleLabel.text = cellData.subtitle
                titleLabel.text = cellData.title
                praise.setTitle(" " + cellData.praise, forState: UIControlState.Normal)
                preview.setTitle(" " + cellData.visit, forState: UIControlState.Normal)
            }
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        
        addSubview(iconView)
        addSubview(subtitleLabel)
        addSubview(titleLabel)
        addSubview(praise)
        addSubview(preview)
        addSubview(baseLine)
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 133 - 24
        titleLabel.numberOfLines = 2
        titleLabel.preferredMaxLayoutWidth = w
        
        iconView.ff_AlignInner(.CenterLeft, referView: self, size: CGSizeMake(133, 84), offset: CGPointMake(9, 0))
        subtitleLabel.ff_AlignHorizontal(.TopRight, referView: iconView, size: CGSizeMake(w, 19), offset: CGPointMake(6, 0))
        titleLabel.ff_AlignVertical(.BottomLeft, referView: subtitleLabel, size: nil, offset: CGPointMake(0, 0))
        praise.ff_AlignHorizontal(.BottomRight, referView: iconView, size: nil, offset: CGPointMake(6, 0))
        preview.ff_AlignHorizontal(.CenterRight, referView: praise, size: nil, offset: CGPointMake(8, 0))
        baseLine.ff_AlignInner(.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
