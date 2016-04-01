//
//  SightDetailViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/13.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class SightDetailViewController: BaseViewController {

    /// 自定义导航
    lazy var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: .whiteColor(), titleSize: 22)
    /// 播放控制器
    weak var playViewController: PlayFrequency?
    weak var cityPlayViewController: CityPlayRulsateView?
    /// 播放cell
    weak var playCell: LandscapeCell?
    /// 景观详情页面背景图
    lazy var backgroundImageView = UIImageView()
    /// 遮罩
    lazy var coverView = UIView(color: SceneColor.clarityBlack, alphaF: 0.7)
    /// 容器
    lazy var scrollView = UIScrollView()
    /// 说明
    lazy var explainLabel = UILabel(color: .whiteColor(), title: "圆明园是少有", fontSize: 17, mutiLines: true, fontName: Font.PingFangSCLight)
    /// 查看更看
    lazy var lookUpMoreButton = UIButton(title: "查看更多", fontSize: 14, radius: 0, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.5), fontName: Font.PingFangSCRegular)
    /// 播放底部view
    lazy var playBottomView = UIView()
    /// 播放开始按钮
    lazy var playBeginButton = UIButton(image: "icon_playBegin", title: "", fontSize: 0)
    /// 播放进度
    var slide = UISlider()
    /// 具体点击的是外界列表哪一个
    var index: Int = 0
    /// 是否正在播放
    lazy var isPlay: Bool = false
    /// 现在播放到的时间
    lazy var currentTimeLabel = UILabel(color: SceneColor.frontBlack, title: "00:00", fontSize: 12, mutiLines: true, fontName: Font.PingFangTCThin)
    /// 总时长
    lazy var totalTimeLabel = UILabel(color: SceneColor.frontBlack, title: "00:00", fontSize: 12, mutiLines: true, fontName: Font.PingFangTCThin)
    
    var dataSource: Landscape = Landscape() {
        didSet {
            if UserProfiler.instance.isShowImage() {
                backgroundImageView.sd_setImageWithURL(NSURL(string: dataSource.image), placeholderImage: PlaceholderImage.defaultSmall)
            }
            let y: CGFloat = dataSource.content.sizeofStringWithFount(UIFont(name: Font.PingFangSCLight, size: 17) ??
                UIFont(name: Font.ios8Font, size: 17)!, maxSize: CGSizeMake(Frame.screen.width - 56, CGFloat.max), lineSpacing: 8).height
            scrollView.contentSize = CGSizeMake(0, y)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
            explainLabel.attributedText = dataSource.content.getAttributedString(0, lineSpacing: 8, breakMode: .ByTruncatingTail, fontName: Font.PingFangSCLight, fontSize: 17)
            totalTimeLabel.text = "\(dataSource.audio_len)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initAutoLayout()
        initNavBar()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        playViewController?.sightDetailController = self
        cityPlayViewController?.sightDetailController = self
        let isHidden = dataSource.audio_len == "" ? true : false
        currentTimeLabel.hidden = isHidden
        playBottomView.hidden   = isHidden
        slide.hidden            = isHidden
        totalTimeLabel.hidden   = isHidden
        playViewController?.setupLockScreenSongInfos()
        cityPlayViewController?.setupLockScreenSongInfos()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        
        if event!.type == UIEventType.RemoteControl {
            if event!.subtype == UIEventSubtype.RemoteControlPlay {
                print("received remote play")
                playViewController?.updatePlayOrPauseBtn(false)
            } else if event!.subtype == UIEventSubtype.RemoteControlPause {
                print("received remote pause")
                playViewController?.updatePlayOrPauseBtn(true)
            } else if event!.subtype == UIEventSubtype.RemoteControlTogglePlayPause {
                print("received toggle")
            }
        }
    }
    
    
    lazy var blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
    private func initView() {
        
        playBottomView.addSubview(blurView)
        blurView.contentView.backgroundColor = UIColor.whiteColor()
        blurView.contentView.alpha = 0.8
        blurView.ff_Fill(playBottomView)
        
        view.backgroundColor = .blackColor()
        view.clipsToBounds = true
        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
        view.addSubview(playBottomView)
        playBottomView.addSubview(playBeginButton)
        view.addSubview(currentTimeLabel)
        view.addSubview(totalTimeLabel)
        view.addSubview(slide)

        let blurV =  UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        backgroundImageView.addSubview(blurV)
        blurV.ff_Fill(backgroundImageView)
        
        slide.minimumTrackTintColor = UIColor(hex: 0x000000, alpha: 0.5)
        slide.maximumTrackTintColor = UIColor(hex: 0xD5D5D5, alpha: 1.0)
        slide.setThumbImage(UIImage(named: "sight_landscape_playProgress")!, forState: .Normal)
        
        playBeginButton.setImage(UIImage(named: "icon_playStop"), forState: .Selected)
        
        scrollView.backgroundColor = .clearColor()
        scrollView.addSubview(explainLabel)
        scrollView.addSubview(lookUpMoreButton)
        backgroundImageView.addSubview(coverView)
        backgroundImageView.contentMode = .ScaleAspectFill
        explainLabel.preferredMaxLayoutWidth = Frame.screen.width - 56
        lookUpMoreButton.addTarget(self, action: #selector(SightDetailViewController.lookUpMoreButtonAction), forControlEvents: .TouchUpInside)
    }
    
    private func initAutoLayout() {
        
        backgroundImageView.ff_AlignInner(.TopLeft, referView: view, size: Frame.screen.size)
        coverView.ff_Fill(backgroundImageView)
        scrollView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(Frame.screen.width, Frame.screen.height - 66 - 81), offset: CGPointMake(0, 81))
        explainLabel.ff_AlignInner(.TopLeft, referView: scrollView, size: nil, offset: CGPointMake(29, 0))
        lookUpMoreButton.ff_AlignVertical(.BottomCenter, referView: explainLabel, size: nil, offset: CGPointMake(0, 27))
        playBottomView.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(Frame.screen.width, 66))
        playBeginButton.ff_AlignInner(.CenterLeft, referView: playBottomView, size: CGSizeMake(38, 38), offset: CGPointMake(24, 0))
        currentTimeLabel.ff_AlignInner(.CenterLeft, referView: playBottomView, size: nil, offset: CGPointMake(83, 0))
        totalTimeLabel.ff_AlignInner(.CenterRight, referView: playBottomView, size: nil, offset: CGPointMake(-24, 0))
        slide.ff_AlignInner(.CenterRight, referView: playBottomView, size: CGSizeMake(Frame.screen.width-113-75, 15), offset: CGPointMake(-66, 0))
    }

    private func initNavBar() {
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        navBar.titleLabel.font = UIFont(name: Font.PingFangSCRegular, size: 22)
        navBar.setTitle(dataSource.name)
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: #selector(SightDetailViewController.popViewAction(_:)))
        navBar.setBlurViewEffect(false)
        navBar.setButtonTintColor(UIColor.yellowColor())
        navBar.backgroundColor = UIColor.clearColor()
    }
    
    func lookUpMoreButtonAction() {
        let sc = DetailWebViewController()
        let landscape = dataSource
        sc.url = landscape.url
        sc.title = landscape.name
        navigationController?.pushViewController(sc, animated: true)
    }
}
