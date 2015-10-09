//
//  GuideViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/17.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class GuideViewController: UICollectionViewController {

    /// 界面布局
    let layout = UICollectionViewFlowLayout()
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pagecontrol)
        
        // 自动布局 － 一定要创建完控件就添加
        let screen = UIScreen.mainScreen().bounds
        let w: CGFloat = 100
        let h: CGFloat = 50
        let x: CGFloat = (screen.width - w) * 0.5
        let pageY: CGFloat = screen.height - 100
        pagecontrol.frame = CGRectMake(x, pageY, w, h)
        
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
        
        cell.imageIndex = indexPath.row
        pagecontrol.currentPage = indexPath.row
        return cell
    }
    
    //  collectionView 停止滚动的动画方法
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        // 获取当前显示的 cell
        let path: AnyObject = collectionView.indexPathsForVisibleItems().last!
        
        if path.item == imageCount - 1 {
            // 获取cell，让cell播放动画
            (collectionView.cellForItemAtIndexPath(path as! NSIndexPath) as! NewFeatureCell).showStartButton()
        }
    }
    
    // 分页
    lazy var pagecontrol: UIPageControl = {
        var pageC = UIPageControl()
        pageC.pageIndicatorTintColor = UIColor.blackColor()
        pageC.currentPageIndicatorTintColor = UIColor.redColor()
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
            iconView.image = UIImage(named: "\(imageIndex + 1).jpg")
            startButton.hidden = true
        }
    }
    
    ///  动画显示开始按钮
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
    
    /// 点击开始按钮
    func startButtonClicked() {
        
        let slideVC = SearchListPageController()
        UIApplication.sharedApplication().keyWindow?.rootViewController = slideVC
    }
    
    // 图像
    lazy var iconView: UIImageView = {
        return UIImageView()
    }()
    
    // 开始按钮
    lazy var startButton: UIButton = {
        // 自定义按钮
        let btn = UIButton(type: UIButtonType.Custom)
        btn.frame = CGRectMake(0, 0, 105, 36)
        
        btn.setTitle("立即体验", forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.redColor()
//                btn.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
//                btn.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        
        btn.addTarget(self, action: "startButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(startButton)
        
        // 自动布局 － 一定要创建完控件就添加
        let screen = UIScreen.mainScreen().bounds
        let w: CGFloat = 100
        let h: CGFloat = 50
        let x: CGFloat = (screen.width - w) * 0.5
        let y: CGFloat = screen.height - 220
        startButton.frame = CGRectMake(x, y, w, h)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.frame = self.bounds
    }
}
