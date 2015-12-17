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

    /// 界面布局
    let layout = UICollectionViewFlowLayout()
    
    let titles = ["这里是路和故事", "这里是阅读和领悟", "这里是诗和远方", ""]
    
    let subtitles = ["旅行  不只有照片", "旅行  不只是看见", "旅行  不会是终点", ""]
    
    let subtitleEnglish = ["MORE THAN PICTURES", "SOMETHING SPECIAL", "ON THE WAY", ""]
    
    // 分页
    lazy var pagecontrol: UIPageControl = {
        var pageC = UIPageControl()
        pageC.numberOfPages = 4
        pageC.currentPage = 0
        pageC.addTarget(self, action: "pageChanged", forControlEvents: UIControlEvents.ValueChanged)
        pageC.userInteractionEnabled = false
        return pageC
    }()
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pagecontrol)
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
    let imageCount = 4
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewFeatureCell
        cell.title.text = titles[indexPath.row]
        cell.subtitle.text = subtitles[indexPath.row]
        cell.subtitleEnglish.text = subtitleEnglish[indexPath.row]
        cell.imageIndex = indexPath.row
        pagecontrol.currentPage = indexPath.row
        
        if indexPath.row == 3 {
            cell.startButton.hidden = false
            cell.introduceLabel.hidden = false
        } else {
            cell.startButton.hidden = true
            cell.introduceLabel.hidden = true
        }
        
        return cell
    }
}

class NewFeatureCell: UICollectionViewCell {
    
    /// 图像索引
    var imageIndex: Int = 0 {
        didSet {
            iconView.image = UIImage(named: "guide\(imageIndex + 1)")
        }
    }
    
    // 图像
    lazy var iconView: UIImageView = UIImageView()
    
    // 开始按钮
    lazy var startButton: UIButton = UIButton(title: "开启探索之旅", fontSize: 20, radius: 10, titleColor: UIColor.whiteColor(), fontName: Font.PingFangTCThin)
    
    /// 蒙版
    lazy var cover: UIView = UIView(color: SceneColor.bgBlack, alphaF: 0.5)
    
    /// 标题
    lazy var title: UILabel = UILabel(color: UIColor.whiteColor(), title: "寻找路上的故事", fontSize: 32, mutiLines: true, fontName: Font.PingFangTCThin)
    
    /// 副标题
    lazy var subtitle: UILabel = UILabel(color: UIColor.whiteColor(), title: "旅行，不只有照片", fontSize: 24, mutiLines: true, fontName: Font.PingFangTCThin)
    
    /// 介绍
    lazy var introduceLabel = UILabel(color: .whiteColor(), title: "了解景点背后的故事", fontSize: 24, mutiLines: true, fontName: Font.PingFangTCThin)
    
    /// 副标题英文
    lazy var subtitleEnglish: UILabel = UILabel(color: UIColor.whiteColor(), title: "MORE THEN PICTURES", fontSize: 28, mutiLines: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        setupAutoLayout()
    }
    
    private func initView() {
        addSubview(iconView)
        addSubview(cover)
        addSubview(title)
        addSubview(subtitle)
        addSubview(subtitleEnglish)
        addSubview(startButton)
        addSubview(introduceLabel)
        
        iconView.contentMode = UIViewContentMode.ScaleAspectFill
        subtitleEnglish.font = UIFont(name: Font.HelveticaNeueThin, size: 28)
        startButton.addTarget(self, action: "startButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        startButton.layer.borderWidth = 1.0
        startButton.layer.borderColor = UIColor.whiteColor().CGColor
        startButton.layer.cornerRadius = 15
        
        title.textAlignment = NSTextAlignment.Center
        subtitle.textAlignment = NSTextAlignment.Justified
    }
    
    private func setupAutoLayout() {
        iconView.ff_AlignInner(.TopLeft, referView: self, size: CGSizeMake(bounds.width, bounds.height))
        cover.ff_AlignInner(.TopLeft, referView: self, size: CGSizeMake(bounds.width, bounds.height))
        title.ff_AlignInner(.TopCenter, referView: self, size: nil, offset: CGPointMake(0, 136))
        subtitle.ff_AlignInner(.BottomCenter, referView: self, size: nil, offset: CGPointMake(0, -79))
        subtitleEnglish.ff_AlignVertical(.TopCenter, referView: subtitle, size: nil, offset: CGPointMake(0, -6))
        introduceLabel.ff_AlignInner(.BottomCenter, referView: self, size: nil, offset: CGPointMake(0, -146))
        startButton.ff_AlignInner(.CenterCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width * 0.55, 64), offset: CGPointMake(0, 0))
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
