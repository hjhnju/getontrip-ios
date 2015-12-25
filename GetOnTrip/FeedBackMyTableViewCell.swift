//
//  FeedBackMyTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/24.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class FeedBackMyTableViewCell: UITableViewCell {
    
    /// 时间
    lazy var timeLabel = UILabel(color: SceneColor.frontBlack, title: "1970-1-1", fontSize: 10, mutiLines: true, fontName: Font.PingFangSCLight)
    
    /// 头像
    lazy var iconImageView = UIImageView(image: UIImage(named: "icon_app")!)
    
    /// 内容
    lazy var contentLabel = UILabel(color: .whiteColor(), title: "在吗？", fontSize: 14, mutiLines: true, fontName: Font.PingFangSCLight)
    
    /// 内容底部图
    lazy var contentImageView = UIImageView(image: UIImage(named: "content_feedback"))
    
    var imageViewWidth: NSLayoutConstraint?
    
    var imageViewHeight: NSLayoutConstraint?
    
    var iconImageViewTop: NSLayoutConstraint?
    
    var data: Feedback? {
        didSet {
            if let data = data {
                contentImageView.image = UIImage(named: data.type == "1" ? "content_feedback" : "system_feedback")
                contentLabel.textColor = data.type == "1" ? .whiteColor() : SceneColor.frontBlack
                timeLabel.hidden = data.isShowTime
                timeLabel.text = data.create_time
                iconImageView.sd_setImageWithURL(NSURL(string: globalUser?.icon ?? ""), placeholderImage: PlaceholderImage.defaultSmall)
                if data.type != "1" { iconImageView.image = UIImage(named: "icon_app") }
                contentLabel.text = data.content
                
                iconImageViewTop?.constant = data.isShowTime ? 18 : 50
                imageViewWidth?.constant = data.content.sizeofStringWithFount1(UIFont(name: Font.PingFangSCLight, size: 14) ?? UIFont(name: Font.ios8Font, size: 14)!, maxSize: CGSizeMake(UIScreen.mainScreen().bounds.width - 98, CGFloat.max)).width + 20
                imageViewHeight?.constant = data.content.sizeofStringWithFount1(UIFont(name: Font.PingFangSCLight, size: 14) ?? UIFont(name: Font.ios8Font, size: 14)!, maxSize: CGSizeMake(UIScreen.mainScreen().bounds.width - 98, CGFloat.max)).height + 7
                iconImageView.layoutIfNeeded()
                contentImageView.layoutIfNeeded()
            }
        }
    }
    
    class func heightWithFeedBack(feedback: Feedback) -> CGFloat {
        
        let timeH: CGFloat = feedback.isShowTime ? 18 : 50
        return timeH + max(feedback.content.sizeofStringWithFount1(UIFont(name: Font.PingFangSCLight, size: 14) ?? UIFont(name: Font.ios8Font, size: 14)!, maxSize: CGSizeMake(UIScreen.mainScreen().bounds.width - 78, CGFloat.max)).height + 7, 35) + 8
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(contentImageView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(contentLabel)
        initAutoLayout()
        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 98
        iconImageView.layer.cornerRadius = 35 * 0.5
    }
    
    private func initAutoLayout() {
        timeLabel.ff_AlignInner(.TopCenter, referView: contentView, size: nil, offset: CGPointMake(0, 18))
        let iconCons = iconImageView.ff_AlignInner(.TopRight, referView: contentView, size: CGSizeMake(35, 35), offset: CGPointMake(-9, 50))
        let cons = contentImageView.ff_AlignHorizontal(.TopLeft, referView: iconImageView, size: CGSizeMake(100, 100), offset: CGPointMake(-12, 0))
        contentLabel.ff_AlignInner(.CenterCenter, referView: contentImageView, size: nil)
        imageViewWidth = contentImageView.ff_Constraint(cons, attribute: .Width)
        imageViewHeight = contentImageView.ff_Constraint(cons, attribute: .Height)
        iconImageViewTop = iconImageView.ff_Constraint(iconCons, attribute: .Top)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {}
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {}
}

class FeedBackSytemTableViewCell: FeedBackMyTableViewCell {
    
    private override func initAutoLayout() {
        timeLabel.ff_AlignInner(.TopCenter, referView: contentView, size: nil, offset: CGPointMake(0, 18))
        let iconCons = iconImageView.ff_AlignInner(.TopLeft, referView: contentView, size: CGSizeMake(35, 35), offset: CGPointMake(9, 50))
        let cons = contentImageView.ff_AlignHorizontal(.TopRight, referView: iconImageView, size: CGSizeMake(100, 100), offset: CGPointMake(12, 0))
        contentLabel.ff_AlignInner(.CenterCenter, referView: contentImageView, size: nil)
        imageViewWidth = contentImageView.ff_Constraint(cons, attribute: .Width)
        imageViewHeight = contentImageView.ff_Constraint(cons, attribute: .Height)
        iconImageViewTop = iconImageView.ff_Constraint(iconCons, attribute: .Top)
    }
}
