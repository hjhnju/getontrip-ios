//
//  SystemTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/2.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

// MARK: - 系统消息
class SystemTableViewCell: UITableViewCell {
    /// 头像
    lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "icon_app"))
    /// 系统回复
    lazy var restorePerson: UILabel = UILabel(color: SceneColor.frontBlack, title: "系统消息", fontSize: 12, mutiLines: false)
    /// 回复时间
    lazy var restoreTime: UILabel = UILabel(color: SceneColor.frontBlack, title: "2天前", fontSize: 9, mutiLines: false)
    /// 标题
    lazy var title: UILabel = UILabel(color: SceneColor.frontBlack, title: "周天赞自己，升级正能量！", fontSize: 12, mutiLines: false)
    /// 副标题
    lazy var subTitle: UILabel = UILabel(color: SceneColor.frontBlack, title: "给负能量除以二，让好心情翻一番。来途知查看你的爱心话题，推荐有趣的话题，传递周一正能量能量！查看你的爱心话题，推荐有趣的话题，传递周一正能量能量能量能能量", fontSize: 12, mutiLines: false)
    /// 图片
    lazy var restoreImageView: UIImageView = UIImageView()
    
    /// 设置底线
    lazy var baseline: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.3)
    
    var message: MessageList? {
        didSet {
            restoreTime.text = message?.create_time
            restoreImageView.sd_setImageWithURL(NSURL(string: message!.image), placeholderImage: PlaceholderImage.defaultSmall)
            
            let getWidth = CGRectGetMaxX(restorePerson.frame) + 8
            title.text = message?.title
            subTitle.text = message?.content
            if message!.systemMesIsIcon {
                restoreImageView.removeFromSuperview()
                title.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - (getWidth + 10)
                subTitle.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - (getWidth + 10)
            } else {
                title.preferredMaxLayoutWidth = bounds.width - (getWidth + iconView.bounds.width + 10 + 18)
                subTitle.preferredMaxLayoutWidth = bounds.width - (getWidth + iconView.bounds.width + 10 + 18)
            }
        }
    }
    
    class func messageWithHeight(mes: MessageList) -> CGFloat {
        var w: CGFloat = 114
        var h: CGFloat = 24
        if mes.systemMesIsIcon {
            w = UIScreen.mainScreen().bounds.width - CGFloat(114) - CGFloat(105)
        } else {
            w = UIScreen.mainScreen().bounds.width - CGFloat(114) - CGFloat(9)
        }
        h = h + mes.title.sizeofStringWithFount1(UIFont.systemFontOfSize(12), maxSize: CGSizeMake(w, CGFloat.max)).height +
            mes.content.sizeofStringWithFount1(UIFont.systemFontOfSize(12), maxSize: CGSizeMake(w, CGFloat.max)).height
        return max(h, 72)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(title)
        addSubview(subTitle)
        addSubview(baseline)
        addSubview(iconView)
        addSubview(restoreTime)
        addSubview(restorePerson)
        addSubview(restoreImageView)
        
        title.numberOfLines = 0
        subTitle.numberOfLines = 0
        
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = 35 * 0.5
        
        iconView.ff_AlignInner(.TopLeft, referView: self, size: CGSizeMake(35, 35), offset: CGPointMake(10, 19))
        restorePerson.ff_AlignHorizontal(.TopRight, referView: iconView, size: nil, offset: CGPointMake(7, 0))
        restoreTime.ff_AlignHorizontal(.BottomRight, referView: iconView, size: nil, offset: CGPointMake(7, 0))
        restoreImageView.ff_AlignInner(.CenterRight, referView: self, size: CGSizeMake(77, 58), offset: CGPointMake(-9, 0))
        title.ff_AlignHorizontal(.TopRight, referView: restorePerson, size: nil, offset: CGPointMake(15, 0))
        subTitle.ff_AlignVertical(.BottomLeft, referView: title, size: nil, offset: CGPointMake(0, 8))
        baseline.ff_AlignInner(.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
}

