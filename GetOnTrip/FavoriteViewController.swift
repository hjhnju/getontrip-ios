//
//  FavoriteViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/1.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class FavoriteViewController: MenuViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    static let name = "我的收藏"
    
    // MARK: - 属性
    lazy var titleBackground: UIView = UIView()
    
    /// 景点按钮
    lazy var sightBtn: UIButton = UIButton(title: "景点", fontSize: 14, radius: 0, titleColor: UIColor.whiteColor())
    
    /// 话题按钮
    lazy var contentBtn: UIButton = UIButton(title: "内容", fontSize: 14, radius: 0, titleColor: UIColor.whiteColor())
    
    /// 城市按钮
    lazy var cityBtn: UIButton = UIButton(title: "城市", fontSize: 14, radius: 0, titleColor: UIColor.whiteColor())
    
    lazy var selectView: UIView = UIView(color: .yellowColor(), alphaF: 1.0)
    
    // 景点控制器
    lazy var sightViewController: CollectSightViewController = CollectSightViewController()
    
    // 内容控制器
    lazy var contentController: CollectContentViewController = CollectContentViewController()
    
    // 城市控制器
    lazy var cityController: CollectCityViewController = CollectCityViewController()
    
    /// 流水布局
    lazy var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    /// 左侧滑动的view
    var slideView = UIView()
    
    /// 底部容器view
    lazy var collectionView: UICollectionView = { [weak self] in
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: self!.layout)
        return cv
        }()
    
    // MARK: - 初始化相关设置
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        setupLayout()
        setupAutoLayout()
        setupAddSubViewAndAction()
    }
    
    private func initView() {
        view.backgroundColor = SceneColor.bgBlack
        titleBackground.backgroundColor = SceneColor.bgBlack
        navBar.setTitle(FavoriteViewController.name)
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")
        
        view.addSubview(titleBackground)
        view.addSubview(collectionView)
        titleBackground.addSubview(cityBtn)
        titleBackground.addSubview(sightBtn)
        titleBackground.addSubview(contentBtn)
        titleBackground.addSubview(selectView)
        view.addSubview(slideView)
    }
    
    private func setupAddSubViewAndAction() {
        addChildViewController(cityController)
        addChildViewController(contentController)
        addChildViewController(sightViewController)
        
        cityBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: .TouchUpInside)
        sightBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: .TouchUpInside)
        contentBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: .TouchUpInside)
        
        contentBtn.tag = 0
        sightBtn.tag   = 1
        cityBtn.tag    = 2
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.bounces    = false
        collectionView.backgroundColor = UIColor.randomColor()
        collectionView.registerClass(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: "FavoriteCollectionViewCell")
    }
    
    // 初始化collection布局
    private func setupLayout() {
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64 - 36)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing      = 0
        layout.scrollDirection         = .Horizontal
        collectionView.pagingEnabled   = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupAutoLayout() {
        
        automaticallyAdjustsScrollViewInsets = false
        titleBackground.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, 36), offset: CGPointMake(0, 64))
        sightBtn.ff_AlignInner(.CenterCenter, referView: titleBackground, size: CGSizeMake(100, 36), offset: CGPointMake(0, 0))
        contentBtn.ff_AlignInner(.CenterLeft, referView: titleBackground, size: CGSizeMake(100, 36), offset: CGPointMake(0, 0))
        cityBtn.ff_AlignInner(.CenterRight, referView: titleBackground, size: CGSizeMake(100, 36), offset: CGPointMake(0, 0))
        collectionView.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - 64 - 36), offset: CGPointMake(0, 0))
        slideView.frame = CGRectMake(0, 100, 10, UIScreen.mainScreen().bounds.height - 100)
        selectView.frame = CGRectMake(11, 34, 73, 1.5)
    }
    
    // MARK: - collectionView 数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FavoriteCollectionViewCell", forIndexPath: indexPath) as! FavoriteCollectionViewCell
        cell.viewController.view.removeFromSuperview()
        if indexPath.row == 0 {
            slideView.hidden = false
            cell.viewController = contentController
        } else if indexPath.row == 1 {
            slideView.hidden = true
            cell.viewController = sightViewController
            slideView.hidden = true
        } else if indexPath.row == 2 {
            cell.viewController = cityController
        }
        
        return cell
    }
    
    /// MARK: - 切换收藏视图方法
    var selectedIndex: Int?
    func switchCollectButtonClick(sender: UIButton) {
        
        let indexPath = NSIndexPath(forItem: sender.tag, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let current = CGFloat(scrollView.contentOffset.x / scrollView.bounds.size.width)

        switch current {
        case 0:
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.selectView.center.x = self.contentBtn.center.x
            })
        case 1:
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.selectView.center.x = self.sightBtn.center.x
            })
        case 2:
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.selectView.center.x = self.cityBtn.center.x
            })
        default:
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.selectView.center.x = scrollView.contentOffset.x / CGFloat(3) + self.selectView.bounds.width * 0.5 + 11
            })
            break
        }
        slideView.hidden = selectView.center.x < UIScreen.mainScreen().bounds.width * 0.5 ? false : true
    }
}

