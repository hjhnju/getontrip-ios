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
    
    let titles = ["寻找路上的故事", "发现未知的逸事", "感受悠远的历史", ""]
    
    let subtitles = ["MORE THAN PICTURES\n旅行，不只有照片", "WANT SEE MORE\n旅行，不只是看见", "ON THE WAY\n旅行，不会是终点", ""]
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pagecontrol)
        pagecontrol.ff_AlignInner(ff_AlignType.BottomCenter, referView: view, size: nil, offset: CGPointMake(0, -10))
        
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
        cell.imageIndex = indexPath.row
        pagecontrol.currentPage = indexPath.row
        if indexPath.row == 3 {
            cell.cover.hidden = true
            cell.iconButton.hidden = false
        } else {
            cell.cover.hidden = false
            cell.iconButton.hidden = true
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let cel = cell as! NewFeatureCell
        cel.title.frame.origin.x = view.bounds.width + cel.title.frame.width + 100
        cel.subtitle.frame.origin.x = -cel.subtitle.frame.width - 100
        
        UIView.animateWithDuration(0.5) { () -> Void in
        }
        
        UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 3, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
            cel.title.center.x = self.view.bounds.width * 0.5
            cel.subtitle.center.x = self.view.bounds.width * 0.5
            
            }, completion: nil)
        
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! NewFeatureCell
//        cell.title.text = titles[indexPath.row ]
//        cell.subtitle.text = subtitles[indexPath.row]
    }
    
    //  collectionView 停止滚动的动画方法
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        print(indexPath.row + 1)
        // 获取当前显示的 cell
        let path: AnyObject = collectionView.indexPathsForVisibleItems().last!
        
        
        if path.item == imageCount - 1 {
            // 获取cell，让cell播放动画
            let cell = collectionView.cellForItemAtIndexPath(path as! NSIndexPath) as! NewFeatureCell
            cell.showStartButton()
        }
    }
    
    // 分页
    lazy var pagecontrol: UIPageControl = {
        var pageC = UIPageControl()
        pageC.numberOfPages = 4
        pageC.currentPage = 0
        pageC.addTarget(self, action: "pageChanged", forControlEvents: UIControlEvents.ValueChanged)
        pageC.userInteractionEnabled = false
        return pageC
        }()
}

class NewFeatureCell: UICollectionViewCell {
    
    /// 图像索引
    var imageIndex: Int = 0 {
        didSet {
            iconView.image = UIImage(named: "guide\(imageIndex + 1)")
            startButton.hidden = true
        }
    }
    
    // 图像
    lazy var iconView: UIImageView = UIImageView()
    
    // 开始按钮
    lazy var startButton: UIButton = UIButton(title: "开启探索之旅", fontSize: 20, radius: 10, titleColor: UIColor(hex: 0x202020, alpha: 1.0))
    
    /// 蒙版
    lazy var cover: UIView = UIView(color: SceneColor.bgBlack, alphaF: 0.55)
    
    /// 标题
    lazy var title: UILabel = UILabel(color: UIColor.whiteColor(), title: "寻找路上的故事", fontSize: 32, mutiLines: true)
    
    /// 副标题
    lazy var subtitle: UILabel = UILabel(color: UIColor.whiteColor(), title: "MORE THAN PICTURES", fontSize: 28, mutiLines: true)
    
    lazy var iconButton: GuideButton = GuideButton(image: "icon_app", title: "尽阅世间之美", fontSize: 20, titleColor: UIColor(hex: 0x202020, alpha: 1.0))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(cover)
        addSubview(title)
        addSubview(subtitle)
        addSubview(startButton)
        addSubview(iconButton)
        
        startButton.addTarget(self, action: "startButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        startButton.backgroundColor = SceneColor.lightYellow
        title.textAlignment = NSTextAlignment.Center
        subtitle.textAlignment = NSTextAlignment.Center
        
        iconView.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: CGSizeMake(bounds.width, bounds.height))
        cover.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: CGSizeMake(bounds.width, bounds.height))
        title.ff_AlignInner(ff_AlignType.TopCenter, referView: self, size: nil, offset: CGPointMake(0, 136))
        subtitle.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: nil, offset: CGPointMake(0, -79))
        startButton.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: CGSizeMake(228, 64), offset: CGPointMake(0, 50))
        iconButton.ff_AlignInner(ff_AlignType.TopCenter, referView: self, size: nil, offset: CGPointMake(0, 150))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 点击开始按钮
    func startButtonClicked() {
        let slideVC = SlideMenuViewController()
        UIApplication.sharedApplication().keyWindow?.rootViewController = slideVC
    }
    
    ///  动画显示开启探索之旅
    func showStartButton() {
        // 动画
        startButton.transform = CGAffineTransformMakeScale(0, 0)
        startButton.hidden = false
        startButton.userInteractionEnabled = false
        
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.startButton.transform = CGAffineTransformIdentity
            }, completion: { (_) -> Void in
                
                self.startButton.userInteractionEnabled = true
        })
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
