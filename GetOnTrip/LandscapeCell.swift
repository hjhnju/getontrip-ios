//
//  LandscapeCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/3/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class LandscapeCell: UITableViewCell {
    
    /// 图片
    lazy var iconView: UIImageView = UIImageView()
    /// 标题
    lazy var titleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 20, mutiLines: true, fontName: Font.PingFangSCRegular)
    /// 副标题
    lazy var subtitleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 12, mutiLines: true)
    /// 底线
    lazy var baseLine: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.3)
    /// 语音播放底部
    lazy var speechView = UIView(color: SceneColor.lightYellow)
    // 语音image
    lazy var speechImageView = UIImageView(image: UIImage(named: "icon_speech"))
    /// 播放时长
    lazy var playLabel = UILabel(color: SceneColor.bgBlack, title: "01:13/4:36", fontSize: 10, mutiLines: true, fontName: Font.HelveticaNeueThin)
    /// 必玩文字
    lazy var compulsoryLabel = UILabel(color: .whiteColor(), title: "必玩", fontSize: 8, mutiLines: true, fontName: Font.PingFangSCRegular)
    /// 必玩底部
    lazy var compulsoryView: CompulsoryPlayView = CompulsoryPlayView(color: .clearColor())
    /// 地理位置说明
    lazy var locationButton: UIButton = UIButton(image: "icon_location_orange", title: "  888", fontSize: 13, titleColor: SceneColor.originYellow)
    /// 地理位置单位
    lazy var locationUnitLabel: UILabel = UILabel(color: SceneColor.originYellow, title: "Km", fontSize: 10)
    /// 播放图标
    lazy var pulsateView: PlayPulsateView = PlayPulsateView()
    // 点击区域放大
    lazy var playAreaButton: UIButton = UIButton()
    
    var superNavigation: UINavigationController?
    
    var landscape: Landscape? {
        didSet {
            if let landscape = landscape {
                iconView.backgroundColor = landscape.bgColor
                // 是否加载网络图片
                if UserProfiler.instance.isShowImage() { iconView.sd_setImageWithURL(NSURL(string: landscape.image)) }
                titleLabel.text = landscape.name
                subtitleLabel.attributedText = landscape.content.getAttributedString(0, lineSpacing: 4, breakMode: .ByTruncatingTail)
                compulsoryView.hidden  = landscape.desc == "" ? true : false
                compulsoryLabel.hidden = landscape.desc == "" ? true : false
                compulsoryLabel.text   = landscape.desc
                subtitleLabel.preferredMaxLayoutWidth = landscape.audio_len == "" ? Frame.screen.width - 139 - 9 : Frame.screen.width - 139 - 95
                playLabel.text = "00:00/\(landscape.audio_len)"
                
                locationButton.setTitle(" " + landscape.dis, forState: .Normal)
                let isHidden = landscape.audio_len == "" ? true : false
                playAreaButton.hidden  = isHidden
                pulsateView.alpha      = landscape.audio_len == "" ? 0 : 1
                playLabel.hidden       = isHidden
                speechImageView.alpha  = landscape.audio_len == "" ? 0 : 1
                speechView.hidden      = isHidden
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initProperty()
        initAutoLayout()
        playAreaButton.addTarget(self, action: "playAreaButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func initProperty() {
        
        backgroundColor = .clearColor()
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(baseLine)
        contentView.addSubview(speechView)
        contentView.addSubview(speechImageView)
        contentView.addSubview(playLabel)
        contentView.addSubview(compulsoryView)
        contentView.addSubview(compulsoryLabel)
        contentView.addSubview(locationButton)
        contentView.addSubview(pulsateView)
        contentView.addSubview(playAreaButton)
        contentView.addSubview(locationUnitLabel)
        
        let rotate: CGFloat = CGFloat(M_PI_2) * 0.5
        compulsoryLabel.transform = CGAffineTransformMakeRotation(-rotate)
        pulsateView.color = UIColor(hex: 0x3C3C3C, alpha: 1.0)
        
        subtitleLabel.numberOfLines  = 3
        iconView.contentMode         = .ScaleAspectFill
        iconView.clipsToBounds       = true
        
        speechView.layer.cornerRadius = 49 * 0.5
        speechView.layer.borderWidth = 0.5
        speechView.layer.borderColor = UIColor(hex: 0xE4E4E4, alpha: 0.5).CGColor
        
        speechImageView.contentMode = .ScaleAspectFill
        speechImageView.clipsToBounds = true
    }
    
    private func initAutoLayout() {
        iconView.ff_AlignInner(.CenterLeft, referView: contentView, size: CGSizeMake(119, 84), offset: CGPointMake(9, 0))
        titleLabel.ff_AlignHorizontal(.TopRight, referView: iconView, size: nil, offset: CGPointMake(9, -3))
//        subtitleLabel.ff_AlignVertical(.BottomLeft, referView: titleLabel, size: nil, offset: CGPointMake(0, 5))
        subtitleLabel.ff_AlignHorizontal(.BottomRight, referView: iconView, size: nil, offset: CGPointMake(9, 3))
        baseLine.ff_AlignInner(.BottomCenter, referView: contentView, size: CGSizeMake(Frame.screen.width - 18, 0.5), offset: CGPointMake(0, 0))
        speechView.ff_AlignInner(.CenterRight, referView: contentView, size: CGSizeMake(49, 49), offset: CGPointMake(-18, 0))
        speechImageView.ff_AlignInner(.CenterCenter, referView: speechView, size: CGSizeMake(31, 31))
        playLabel.ff_AlignVertical(.BottomCenter, referView: speechView, size: nil, offset: CGPointMake(0, 3))
        compulsoryView.ff_AlignInner(.TopLeft, referView: iconView, size: CGSizeMake(24, 24), offset: CGPointMake(-1, -1))
        compulsoryLabel.ff_AlignInner(.TopLeft, referView: iconView, size: nil, offset: CGPointMake(0, 3))
        locationButton.ff_AlignHorizontal(.CenterRight, referView: titleLabel, size: nil, offset: CGPointMake(6, 0))
        locationUnitLabel.ff_AlignHorizontal(.BottomRight, referView: locationButton, size: nil, offset: CGPointMake(0, -1))
        pulsateView.ff_AlignInner(.CenterCenter, referView: speechView, size: CGSizeMake(49, 49), offset: CGPointMake(-1, -10))
        playAreaButton.ff_AlignInner(.CenterRight, referView: contentView, size: CGSizeMake(95, 115))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
    
    var isAddAnimate: Bool = false
    func playAreaButtonAction(sender: UIButton) {
        PlayFrequency.sharePlayFrequency.playCell = self
        if !isAddAnimate {
            ProgressHUD.showSuccessHUD(nil, text: "缓冲中，请稍候")
            pulsateView.playIconAction()
            pulsateView.hidden = true
            isAddAnimate = true
        }
        
        if PlayFrequency.sharePlayFrequency.index == sender.tag {
            if !PlayFrequency.sharePlayFrequency.isLoading {
                PlayFrequency.sharePlayFrequency.playButtonAction(sender)
            }
            return
        }
        
        PlayFrequency.sharePlayFrequency.index = sender.tag
    }
}

class LandscapeCellHead: LandscapeCell {
    
    
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
                
                let isHidden = landscape.audio_len == "" ? true : false
                playAreaButton.hidden  = isHidden
                pulsateView.alpha      = landscape.audio_len == "" ? 0 : 1
                playLabel.hidden       = isHidden
                speechImageView.alpha  = landscape.audio_len == "" ? 0 : 1
                speechView.hidden      = isHidden
                
                subtitleLabel.preferredMaxLayoutWidth = landscape.audio_len == "" ? Frame.screen.width - 18 : Frame.screen.width - 9 - 95
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
        speechView.ff_AlignInner(.CenterRight, referView: contentView, size: CGSizeMake(49, 49), offset: CGPointMake(-18, 0))
        pulsateView.ff_AlignInner(.CenterCenter, referView: speechView, size: CGSizeMake(49, 49), offset: CGPointMake(-1, -10))
        speechImageView.ff_AlignInner(.CenterCenter, referView: speechView, size: CGSizeMake(31, 31))
        mapButton.ff_AlignHorizontal(.CenterRight, referView: titleLabel, size: nil, offset: CGPointMake(7, 0))
        playLabel.ff_AlignVertical(.BottomCenter, referView: speechView, size: nil, offset: CGPointMake(0, 3))
        playAreaButton.ff_AlignInner(.CenterRight, referView: contentView, size: CGSizeMake(95, 115))
    }
    
    /// 初始化相关属性
    private override func initProperty() {
        super.initProperty()
        
        iconView.addSubview(coverView)
        coverView.alpha = 0.3
        clipsToBounds = true
        titleLabel.textColor    = .whiteColor()
        subtitleLabel.textColor = .whiteColor()
        baseLine.hidden = true
        iconView.contentMode = .ScaleAspectFit
        contentView.addSubview(mapButton)
        playLabel.textColor = .whiteColor()
        subtitleLabel.numberOfLines  = 3
        iconView.contentMode         = .ScaleAspectFill
        iconView.clipsToBounds       = true
        
        speechView.layer.cornerRadius = 49 * 0.5
        speechView.layer.borderWidth = 0.5
        speechView.layer.borderColor = UIColor(hex: 0xE4E4E4, alpha: 0.5).CGColor
        
        speechImageView.contentMode = .ScaleAspectFill
        speechImageView.clipsToBounds = true
    }
}
