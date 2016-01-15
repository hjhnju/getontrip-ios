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
    
    /// 景观详情页面背景图
    lazy var backgroundImageView = UIImageView()
    /// 遮罩
    lazy var coverView = UIView(color: SceneColor.clarityBlack, alphaF: 0.7)
    /// 容器
    lazy var scrollView = UIScrollView()
    /// 说明
    lazy var explainLabel = UILabel(color: .whiteColor(), title: "圆明园是少有的奇迹", fontSize: 17, mutiLines: true, fontName: Font.PingFangSCLight)
    /// 查看更看
    lazy var lookUpMoreButton = UIButton(title: "查看更多", fontSize: 14, radius: 0, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.5), fontName: Font.PingFangSCRegular)
    /// 播放底部view
    lazy var playBottomView = UIView(color: .whiteColor(), alphaF: 0.9)
    /// 播放开始按钮
    lazy var playBeginButton = UIButton(image: "icon_playBegin", title: "", fontSize: 0)
    /// 播放进度
    lazy var playPView: PlayProgressView = PlayProgressView()
    /// 播放类
    
    /// 具体点击的是外界列表哪一个
    var index: Int = 0 {
        didSet {
            PlayFrequency.sharePlayFrequency.index = index
        }
    }
    /// 是否正在播放
    lazy var isPlay: Bool = false
    
    var dataSource: Landscape = Landscape() {
        didSet {
            if UserProfiler.instance.isShowImage() {
                backgroundImageView.sd_setImageWithURL(NSURL(string: dataSource.detailBackground), placeholderImage: PlaceholderImage.defaultSmall)
            }
            let y: CGFloat = dataSource.content.sizeofStringWithFount(UIFont(name: Font.PingFangSCLight, size: 17) ??
                UIFont(name: Font.ios8Font, size: 17)!, maxSize: CGSizeMake(Frame.screen.width - 56, CGFloat.max), lineSpacing: 0).height
            scrollView.contentSize = CGSizeMake(0, y)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
            explainLabel.text = dataSource.content
            PlayFrequency.sharePlayFrequency.playUrl = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        initView()
        initAutoLayout()
        initNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initView() {
        view.backgroundColor = .blackColor()
        view.clipsToBounds = true
        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
        view.addSubview(playBottomView)
        playBottomView.addSubview(playBeginButton)
        view.addSubview(playPView)
        
        playBeginButton.setImage(UIImage(named: "icon_playStop"), forState: UIControlState.Selected)
        scrollView.backgroundColor = .clearColor()
        scrollView.addSubview(explainLabel)
        scrollView.addSubview(lookUpMoreButton)
        backgroundImageView.addSubview(coverView)
        backgroundImageView.contentMode = .ScaleAspectFill
        explainLabel.preferredMaxLayoutWidth = Frame.screen.width - 56
        playBeginButton.addTarget(self, action: "playBeginButtonAction:", forControlEvents: .TouchUpInside)
        PlayFrequency.sharePlayFrequency.playDetailViewController = self
        
        lookUpMoreButton.addTarget(self, action: "lookUpMoreButtonAction", forControlEvents: .TouchUpInside)
    }
    
    private func initAutoLayout() {
        
        backgroundImageView.ff_AlignInner(.TopLeft, referView: view, size: Frame.screen.size)
        coverView.ff_Fill(backgroundImageView)
        scrollView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(Frame.screen.width, Frame.screen.height - 66 - 81), offset: CGPointMake(0, 81))
        explainLabel.ff_AlignInner(.TopLeft, referView: scrollView, size: nil, offset: CGPointMake(29, 0))
        lookUpMoreButton.ff_AlignVertical(.BottomCenter, referView: explainLabel, size: nil, offset: CGPointMake(0, 27))
        playBottomView.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(Frame.screen.width, 66))
        playBeginButton.ff_AlignInner(.CenterLeft, referView: playBottomView, size: CGSizeMake(38, 38), offset: CGPointMake(24, 0))
        playPView.ff_AlignInner(.CenterLeft, referView: playBottomView, size: CGSizeMake(Frame.screen.width - 83 - 24, 15), offset: CGPointMake(83, 0))
    }

    private func initNavBar() {
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        navBar.setTitle(dataSource.name)
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")
        navBar.setBlurViewEffect(false)
        navBar.setButtonTintColor(UIColor.yellowColor())
        navBar.backgroundColor = UIColor.clearColor()
    }
    
    /// 播放方法
    func playBeginButtonAction(sender: UIButton) {
        
        PlayFrequency.sharePlayFrequency.play()
    }
    
    func lookUpMoreButtonAction() {
        let sc = DetailWebViewController()
        let landscape = dataSource
        sc.url = landscape.url
        sc.title = landscape.name
        navigationController?.pushViewController(sc, animated: true)
    }

}
