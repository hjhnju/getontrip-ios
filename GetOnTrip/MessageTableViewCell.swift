//
//  MessageTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/2.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

// MARK: - 回复消息
class MessageTableViewCell: UITableViewCell {
    /// 头像
    lazy var iconView: UIImageView = UIImageView()
    /// 回复人
    lazy var restorePerson: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 12, mutiLines: false)
    /// 回复时间
    lazy var restoreTime: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 9, mutiLines: false)
    /// 所回复的照片
    lazy var restoreImageView: UIImageView = UIImageView()
    /// 删除按钮
    lazy var deleteButton = UIButton(title: "删除", fontSize: 20, radius: 0, titleColor: UIColor.blackColor())
    
    /// 设置底线
    lazy var baseline: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.3)
    
    var message: MessageList? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: message!.avatar), placeholderImage: PlaceholderImage.defaultSmall)
            restorePerson.text = message?.content
            restoreTime.text = message?.create_time
            restoreImageView.sd_setImageWithURL(NSURL(string: message!.image), placeholderImage: PlaceholderImage.defaultSmall)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(baseline)
        contentView.addSubview(iconView)
        contentView.addSubview(restoreTime)
        contentView.addSubview(restorePerson)
        contentView.addSubview(restoreImageView)
        
        iconView.layer.borderWidth = 1.0
        iconView.layer.borderColor = SceneColor.shallowGrey.CGColor
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = 35 * 0.5
        iconView.contentMode = UIViewContentMode.ScaleAspectFill
        
        iconView.ff_AlignInner(.CenterLeft, referView: contentView, size: CGSizeMake(35, 35), offset: CGPointMake(9, 0))
        restorePerson.ff_AlignHorizontal(.TopRight, referView: iconView, size: nil, offset: CGPointMake(7, 0))
        restoreTime.ff_AlignHorizontal(.BottomRight, referView: iconView, size: nil, offset: CGPointMake(7, 0))
        restoreImageView.ff_AlignInner(.CenterRight, referView: contentView, size: CGSizeMake(77, 57), offset: CGPointMake(-9, 0))
        baseline.ff_AlignInner(.BottomCenter, referView: contentView, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        iconView.layer.cornerRadius = max(iconView.bounds.width, iconView.bounds.height) * 0.5
//        iconView.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}



