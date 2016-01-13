//
//  LandscapeCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/3/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class LandscapeCell1: UITableViewCell {
    
    /// 图片
    lazy var iconView: UIImageView = UIImageView()
    /// 标题
    lazy var titleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 20, mutiLines: true, fontName: Font.PingFangSCRegular)
    /// 副标题
    lazy var subtitleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 12, mutiLines: true)
    /// 底线
    lazy var baseLine: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.3)
    /// 语音image
    lazy var speechButton = UIButton(image: "icon_speech", title: "", fontSize: 0)
    /// 播放时长
    lazy var playLabel = UILabel(color: SceneColor.bgBlack, title: "01:13/4:36", fontSize: 10, mutiLines: true, fontName: Font.HelveticaNeueThin)
    /// 必玩文字
    var compulsoryLabel = UILabel(color: .whiteColor(), title: "必玩", fontSize: 8, mutiLines: true, fontName: Font.PingFangSCRegular)
    /// 必玩底部
    var compulsoryView = CompulsoryPlayView(color: .clearColor())
    
    var superNavigation: UINavigationController?
    
    var landscape: Landscape? {
        didSet {
            if let landscape = landscape {
                iconView.backgroundColor = landscape.bgColor
                // 是否加载网络图片
                if UserProfiler.instance.isShowImage() { iconView.sd_setImageWithURL(NSURL(string: landscape.image)) }
                titleLabel.text = landscape.name
                subtitleLabel.attributedText = landscape.content.getAttributedString(0, lineSpacing: 7, breakMode: .ByTruncatingTail)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initProperty()
        initAutoLayout()
    }
    
    private func initProperty() {
        
        backgroundColor = .clearColor()
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(baseLine)
        contentView.addSubview(speechButton)
        contentView.addSubview(playLabel)
        iconView.addSubview(compulsoryView)
        iconView.addSubview(compulsoryLabel)
        
        let rotate: CGFloat = CGFloat(M_PI_2) * 0.5
        compulsoryLabel.transform = CGAffineTransformMakeRotation(-rotate)
        
        subtitleLabel.numberOfLines  = 3
        subtitleLabel.preferredMaxLayoutWidth = Frame.screen.width - 139 - 90
        iconView.contentMode         = .ScaleAspectFill
        iconView.clipsToBounds       = true
    }
    
    private func initAutoLayout() {
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 119 - 15 - 6
        iconView.ff_AlignInner(.CenterLeft, referView: contentView, size: CGSizeMake(119, 84), offset: CGPointMake(9, 0))
        titleLabel.ff_AlignHorizontal(.TopRight, referView: iconView, size: CGSizeMake(w, 21), offset: CGPointMake(9, 0))
        subtitleLabel.ff_AlignVertical(.BottomLeft, referView: titleLabel, size: nil, offset: CGPointMake(0, 9))
        baseLine.ff_AlignInner(.BottomCenter, referView: contentView, size: CGSizeMake(Frame.screen.width - 18, 0.5), offset: CGPointMake(0, 0))
        speechButton.ff_AlignInner(.CenterRight, referView: contentView, size: CGSizeMake(49, 49), offset: CGPointMake(-18, 0))
        playLabel.ff_AlignVertical(.BottomCenter, referView: speechButton, size: nil, offset: CGPointMake(0, 0))
        compulsoryView.ff_AlignInner(.TopLeft, referView: iconView, size: CGSizeMake(23, 23))
        compulsoryLabel.ff_AlignInner(.TopLeft, referView: iconView, size: nil, offset: CGPointMake(0, 3))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}

class LandscapeCell: LandscapeCell1 {
    
    
    lazy var mapButton    = UIButton(image: "icon_map", title: "  切换地图", fontSize: 11, titleColor: .whiteColor(), fontName: Font.PingFangSCRegular)
    
    override var landscape: Landscape? {
        didSet {
            if let landscape = landscape {
                iconView.contentMode = .ScaleAspectFill
                iconView.backgroundColor = landscape.bgColor
                //是否加载网络图片
                if UserProfiler.instance.isShowImage() {
                    iconView.sd_setImageWithURL(NSURL(string: landscape.imageHeader), placeholderImage: PlaceholderImage.defaultSmall, completed: { (image, error, cacheType, url) -> Void in
                        if image != nil {
                            self.iconView.image = UIImageView.imageByApplyingImage(image, blurRadius: 0.3)
                        }
                    })
                }
                
                titleLabel.text = landscape.name
                subtitleLabel.attributedText = landscape.content.getAttributedString(0, lineSpacing: 5, breakMode: .ByTruncatingTail, fontName: Font.defaultFont, fontSize: 14)
            }
        }
    }
    
    /// 图片模糊
    lazy var coverView = UIView(color: UIColor.blackColor())
    
    override func initAutoLayout() {
        initProperty()
        iconView.ff_AlignInner(.CenterCenter, referView: contentView, size: CGSizeMake(Frame.screen.width + 20, 200))
        coverView.ff_AlignInner(.CenterCenter, referView: iconView, size: CGSizeMake(Frame.screen.width + 20, 190))
        titleLabel.ff_AlignInner(.TopLeft, referView: contentView, size: nil, offset: CGPointMake(9, 25))
        subtitleLabel.ff_AlignVertical(.BottomLeft, referView: titleLabel, size: nil, offset: CGPointMake(0, 15))
        speechButton.ff_AlignInner(.CenterRight, referView: contentView, size: CGSizeMake(49, 49), offset: CGPointMake(-18, 0))
        mapButton.ff_AlignHorizontal(.CenterRight, referView: titleLabel, size: nil, offset: CGPointMake(7, 0))
        playLabel.ff_AlignVertical(.BottomCenter, referView: speechButton, size: nil, offset: CGPointMake(0, 0))
    }
    
    /// 初始化相关属性
    private override func initProperty() {
        super.initProperty()
        
        iconView.addSubview(coverView)
        coverView.alpha = 0.3
        clipsToBounds = true
        titleLabel.textColor    = .whiteColor()
        subtitleLabel.textColor = .whiteColor()
        subtitleLabel.preferredMaxLayoutWidth = Frame.screen.width - 104
        baseLine.hidden = true
        iconView.contentMode = .ScaleAspectFit
        contentView.addSubview(mapButton)
    }
}
