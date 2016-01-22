//
//  SightLandscapesHeaderCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/20.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class SightLandscapesHeaderCell: UITableViewHeaderFooterView {

    /// 图片
    lazy var iconView: UIImageView = UIImageView()
    /// 标题
    lazy var titleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 20, mutiLines: true, fontName: Font.PingFangSCRegular)
    /// 副标题
    lazy var subtitleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 12, mutiLines: true)
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
    lazy var locationButton: UIButton = UIButton(image: "icon_location_orange", title: "  888m", fontSize: 13, titleColor: SceneColor.originYellow)
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
                
                let isHidden = landscape.audio_len == "" ? true : false
                playAreaButton.hidden  = isHidden
                pulsateView.hidden     = isHidden
                playLabel.hidden       = isHidden
                speechImageView.hidden = isHidden
                speechView.hidden      = isHidden
                
                print(landscape.desc)
            }
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        initProperty()
        initAutoLayout()
    }
    
    private func initProperty() {
        
        backgroundColor = .clearColor()
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(speechView)
        contentView.addSubview(speechImageView)
        contentView.addSubview(playLabel)
        contentView.addSubview(compulsoryView)
        contentView.addSubview(compulsoryLabel)
        contentView.addSubview(locationButton)
        contentView.addSubview(pulsateView)
        contentView.addSubview(playAreaButton)
        
        let rotate: CGFloat = CGFloat(M_PI_2) * 0.5
        compulsoryLabel.transform = CGAffineTransformMakeRotation(-rotate)
        
        
        subtitleLabel.numberOfLines  = 3
        iconView.contentMode         = .ScaleAspectFill
        iconView.clipsToBounds       = true
        
        speechView.layer.cornerRadius = 49 * 0.5
        speechView.layer.borderWidth = 0.5
        speechView.layer.borderColor = UIColor(hex: 0xE4E4E4, alpha: 0.5).CGColor
        
        playAreaButton.addTarget(self, action: "playAreaButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        speechImageView.contentMode = .ScaleAspectFill
        speechImageView.clipsToBounds = true
    }
    
    private func initAutoLayout() {
        iconView.ff_AlignInner(.CenterLeft, referView: contentView, size: CGSizeMake(119, 84), offset: CGPointMake(9, 0))
        titleLabel.ff_AlignHorizontal(.TopRight, referView: iconView, size: nil, offset: CGPointMake(9, 0))
        subtitleLabel.ff_AlignVertical(.BottomLeft, referView: titleLabel, size: nil, offset: CGPointMake(0, 5))
        speechView.ff_AlignInner(.CenterRight, referView: contentView, size: CGSizeMake(49, 49), offset: CGPointMake(-18, 0))
        
        speechImageView.ff_AlignInner(.CenterCenter, referView: speechView, size: CGSizeMake(31, 31))
        
        playLabel.ff_AlignVertical(.BottomCenter, referView: speechView, size: nil, offset: CGPointMake(0, 3))
        compulsoryView.ff_AlignInner(.TopLeft, referView: iconView, size: CGSizeMake(24, 24), offset: CGPointMake(-1, -1))
        compulsoryLabel.ff_AlignInner(.TopLeft, referView: iconView, size: nil, offset: CGPointMake(0, 3))
        locationButton.ff_AlignHorizontal(.CenterRight, referView: titleLabel, size: nil, offset: CGPointMake(6, 0))
        pulsateView.ff_AlignInner(.CenterCenter, referView: speechView, size: CGSizeMake(49, 49), offset: CGPointMake(-1, -10))
        playAreaButton.ff_AlignInner(.CenterRight, referView: contentView, size: CGSizeMake(95, 115))
        playAreaButton.backgroundColor = UIColor.randomColor()
        playAreaButton.alpha = 0.2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    var isAddAnimate: Bool = false
    func playAreaButtonAction(sender: UIButton) {
        
//        if PlayFrequency.sharePlayFrequency.index == sender.tag {
//            if !PlayFrequency.sharePlayFrequency.isLoading {
//                PlayFrequency.sharePlayFrequency.playButtonAction(sender)
//            }
//            return
//        }
        
        speechImageView.hidden = !speechImageView.hidden
        if !isAddAnimate {
            ProgressHUD.showSuccessHUD(nil, text: "缓冲中，请稍候")
            pulsateView.playIconAction()
            isAddAnimate = true
        }
//        PlayFrequency.sharePlayFrequency.index = sender.tag
//        PlayFrequency.sharePlayFrequency.playCell = self
    }


}
