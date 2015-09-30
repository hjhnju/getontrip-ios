//
//  SightListController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/28.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class SightListController: UIViewController {

    /// 景点列表id
    var sightId: String?
    
    /// 标签视图
    lazy var scrollerView = UIScrollView()
    
    /// 标签数组
    var channels: NSArray?
    
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: SightListRequest?
    
    /// 标签底部view
    lazy var labelBottomView: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.5)
    
    /// 流水布局
    lazy var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    /// 底部view
    lazy var collectionView: UICollectionView = { [unowned self] in
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
        return cv
    }()
    
    /// 索引
    var currentIndex: Int?
    
    /// 数据
    var dataSource: NSDictionary?
    
    /// 发送反馈消息
    private func loadSightData() {
        
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = SightListRequest()
            lastSuccessAddRequest?.sightId = sightId
        }
        
        lastSuccessAddRequest?.fetchSightListModels {[unowned self] (handler: NSDictionary) -> Void in
            self.dataSource = handler
            
            self.channels = handler.objectForKey("sightTags") as? NSArray
            self.setupChannel()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(scrollerView)
        view.addSubview(collectionView)
        
        scrollerView.backgroundColor = UIColor.grayColor()
        collectionView.registerClass(SightCollectionViewCell.self, forCellWithReuseIdentifier: "SightCollectionView_Cell")
        
        setupNavigationBar()
        setupAutlLayout()
        loadSightData()
        
    }
    
    func setupAutlLayout() {
        
        scrollerView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 30), offset: CGPointMake(0, 64))
    }
    
    func setupNavigationBar() {

//        navigationController?.navigationBar.backIndicatorImage = nil
        navigationController?.navigationBar.barTintColor = SceneColor.black
        navigationController?.navigationBar.tintColor    = SceneColor.lightYellow
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : SceneColor.lightYellow]
    }
    
    ///  设置频道标签
    func setupChannel() {
        
       
        automaticallyAdjustsScrollViewInsets = false
        /// 间隔
        var x: CGFloat = 50
        let h: CGFloat = scrollerView.bounds.size.height
        
        for label in channels! {
            let tag: SightListTags = label as! SightListTags
            let lab = UILabel(color: UIColor.blackColor(), title: tag.name!, fontSize: 14, mutiLines: false)
            
            lab.tag = index
            lab.frame = CGRectMake(x, 0, 50, h)
            x += 100
            scrollerView.addSubview(lab)
        }
        
        scrollerView.contentSize = CGSizeMake(CGFloat(100 * Int(channels!.count) + 50), 30)
        currentIndex = 0
    }


    private func setupLayout() {
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - collectionView 数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (dataSource?.objectForKey("sightTags")?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SightCollectionView_Cell", forIndexPath: indexPath) as! SightCollectionViewCell
        
        cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256) / 255), green: CGFloat(CGFloat(arc4random_uniform(256) / 255)), blue: CGFloat(CGFloat(arc4random_uniform(256) / 255)), alpha: 1.0)

//        if childViewControllers.contains(cell.UICollectionView) {
//        addChildViewController(cell.)
//        }
        // 添加子视图控制器，注意这句话一定要有，否则会打断响应者链条
//        if (![self.childViewControllers containsObject:cell.newsVC]) {
//            [self addChildViewController:(UIViewController *)cell.newsVC];
//        }
//        cell.URLString = [self.channels[indexPath.item] URLString];
        return cell
    }
    
    // scrollerView 代理方法
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
    }
}
