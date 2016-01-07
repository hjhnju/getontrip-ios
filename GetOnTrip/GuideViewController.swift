//
//  GuideViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/17.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

let reuseIdentifier = "Cell"

class GuideViewController: UICollectionViewController {

    lazy var numberPage: Int = 4
    
    /// 界面布局
    let layout = UICollectionViewFlowLayout()
    
    let titles = ["好看好玩有品位", "大千世界走着瞧", "内容丰富更精美", ""]
    
    let subtitles = ["开始厌倦了走马观花的旅行？\n你不是一个人\n途知带你了解旅行目的地的一切\n人文历史、风土人情、科学地理和传说趣闻",
        "觉得读万卷书行万里路很难？\n让你带上一本旅行的百科全书\n在时间和空间里肆意穿梭\n一掌知天下的快乐，快来感受吧",
        "想要更多不一样的体验？\n便捷浏览目的地的必吃必玩、热门话题、\n相关书籍和音频视频\n所有精品内容尽在您的手中", ""]
    
    let colors = [UIColor(hex: 0xE14B45, alpha: 1.0), UIColor(hex: 0x9C3C51, alpha: 1.0), UIColor(hex: 0x51718F, alpha: 1.0), UIColor.clearColor()]
    
    lazy var exitButton = UIButton(image: "close_setting", title: "", fontSize: 0)
    
    // 分页
    lazy var pagecontrol: UIPageControl = { [weak self] in
        var pageC = UIPageControl()
        pageC.numberOfPages = self?.numberPage ?? 0
        pageC.currentPage = 0
        pageC.addTarget(self, action: "pageChanged", forControlEvents: .ValueChanged)
        pageC.userInteractionEnabled = false
        pageC.pageIndicatorTintColor = UIColor(hex: 0xA9A9A9, alpha: 1.0)
        pageC.currentPageIndicatorTintColor = UIColor(hex: 0x1C1C1C, alpha: 1.0)
        return pageC
    }()
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pagecontrol)
        view.addSubview(exitButton)
        exitButton.hidden = numberPage != 4 ? false : true
        exitButton.addTarget(self, action: "exitButtonAction", forControlEvents: .TouchUpInside)
        automaticallyAdjustsScrollViewInsets = false
        exitButton.ff_AlignInner(.TopRight, referView: view, size: nil, offset: CGPointMake(-20, 40))
        pagecontrol.ff_AlignInner(.BottomCenter, referView: view, size: nil, offset: CGPointMake(0, -20))
        
        // 注册可重用 cell
        self.collectionView!.registerClass(NewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置布局
        layout.itemSize = view.bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 设置分页
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
    }
    
    // MARK: UICollectionViewDataSource
    /// 图片总数
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberPage
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewFeatureCell
        cell.title.text = titles[indexPath.row]
        cell.title.textColor = colors[indexPath.row]
        cell.subtitle.attributedText = subtitles[indexPath.row].getAttributedString(0, lineSpacing: 7, breakMode: .ByTruncatingTail, fontName: Font.PingFangTCThin, fontSize: 14)
        cell.subtitle.textAlignment = .Center
        cell.imageIndex = indexPath.row
        pagecontrol.currentPage = indexPath.row
        
        let isHidden = indexPath.row == 3 ? false : true
        pagecontrol.hidden         = !isHidden
        cell.startButton.hidden    = isHidden
        cell.iconImageView.hidden  = !isHidden
        cell.introduceLabel.hidden = isHidden
        cell.introduceImageView.hidden = isHidden
        
        return cell
    }
    
    func exitButtonAction() {
        navigationController?.popViewControllerAnimated(true)
    }
}

class NewFeatureCell: UICollectionViewCell {
    
    /// 图像索引
    var imageIndex: Int = 0 {
        didSet {
            pictureView.image = UIImage(named: "guide\(imageIndex + 1)")
        }
    }
    
    // 图像
    lazy var pictureView: UIImageView = UIImageView()
    
    /// 小图标
    lazy var iconImageView: UIImageView = UIImageView(image: UIImage(named: "guide_icon")!)
    
    // 开始按钮
    lazy var startButton: UIButton = UIButton(title: "开启探索之旅", fontSize: 20, radius: 10, titleColor: UIColor(hex: 0x252525, alpha: 1.0), fontName: Font.PingFangSCLight)
    
    /// 标题
    lazy var title: UILabel = UILabel(color: UIColor.whiteColor(), title: "寻找路上的故事", fontSize: 26, mutiLines: true, fontName: Font.PingFangSCRegular)
    
    /// 副标题
    lazy var subtitle: UILabel = UILabel(color: UIColor(hex: 0x676464, alpha: 1.0), title: "旅行，不只有照片", fontSize: 14, mutiLines: true, fontName: Font.PingFangTCThin)
    
    /// 介绍
    lazy var introduceLabel = UILabel(color: UIColor(hex: 0x676464, alpha: 1.0), title: "", fontSize: 24, mutiLines: true, fontName: Font.PingFangTCThin)
    /// 介绍图片
    lazy var introduceImageView = UIImageView(image: UIImage(named: "app_title")!)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        setupAutoLayout()
    }
    
    private func initView() {
        contentView.addSubview(pictureView)
        contentView.addSubview(title)
        contentView.addSubview(introduceImageView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(introduceLabel)
        contentView.addSubview(subtitle)
        contentView.addSubview(startButton)
        contentView.backgroundColor = SceneColor.greyWhite
        
        pictureView.contentMode = .ScaleAspectFill
        startButton.addTarget(self, action: "startButtonClicked", forControlEvents: .TouchUpInside)
//        startButton.layer.borderWidth = 1.0
//        startButton.layer.borderColor = UIColor.whiteColor().CGColor
        startButton.backgroundColor = UIColor(hex: 0xFFDB00, alpha: 1.0)
        startButton.layer.cornerRadius = 3
        
        title.textAlignment = .Center
        introduceImageView.contentMode = .ScaleToFill
        introduceLabel.attributedText = "一起发现旅途中的一砖一瓦、一山一水、\n一方百姓背后的历史故事、人文地理、风土人情"
            .getAttributedString(0, lineSpacing: 7, breakMode: .ByTruncatingTail, fontName: Font.PingFangTCThin, fontSize: 14)
        introduceLabel.textAlignment = .Center
    }
    
    private func setupAutoLayout() {
        pictureView.ff_AlignInner(.TopLeft, referView: contentView, size: CGSizeMake(Frame.screen.width, Frame.screen.height * 0.42))
        title.ff_AlignInner(.TopCenter, referView: contentView, size: nil, offset: CGPointMake(0, Frame.screen.height * 0.5))
        introduceImageView.ff_AlignVertical(.CenterCenter, referView: contentView, size: nil, offset: CGPointMake(0, 20))
        introduceLabel.ff_AlignVertical(.BottomCenter, referView: introduceImageView, size: nil, offset: CGPointMake(0, 30))
        iconImageView.ff_AlignInner(.TopCenter, referView: contentView, size: nil, offset: CGPointMake(0, Frame.screen.height * 0.58423))
        subtitle.ff_AlignInner(.TopCenter, referView: contentView, size: nil, offset: CGPointMake(0, Frame.screen.height * 0.646739))
        startButton.ff_AlignInner(.BottomCenter, referView: contentView, size: CGSizeMake(Frame.screen.width - 23 * 2, 61), offset: CGPointMake(0, -23))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 点击开始按钮
    func startButtonClicked() {
        let slideVC = SlideMenuViewController()
        UIApplication.sharedApplication().keyWindow?.rootViewController = slideVC
    }
}

class GuideButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.textAlignment = NSTextAlignment.Center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.center = CGPointMake(bounds.width * 0.5, 0)
        titleLabel?.center = CGPointMake(bounds.width * 0.5, CGRectGetMaxY(imageView!.frame) + titleLabel!.bounds.height * 0.5 + 12)
    }
}
