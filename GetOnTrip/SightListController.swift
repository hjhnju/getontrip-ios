//
//  SightListController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/28.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class SightListController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    /// 景点列表id
    var sightId: String?
    
    /// scrollView底部view
    lazy var scrollViewBottomView: UIView = UIView()
    
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
    var dataSource: NSDictionary? {
        didSet {
            channels = dataSource!.objectForKey("sightTags") as? NSArray
            setupChannel()
            collectionView.reloadData()
        }
    }
    
    /// 发送反馈消息
    private func loadSightData() {
        
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = SightListRequest()
            lastSuccessAddRequest?.sightId = sightId
        }
        
        lastSuccessAddRequest?.fetchSightListModels {[unowned self] (handler: NSDictionary) -> Void in
            self.dataSource = handler
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(scrollViewBottomView)
        scrollViewBottomView.addSubview(scrollerView)
        view.addSubview(collectionView)
        scrollerView.backgroundColor = UIColor.grayColor()
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        
        collectionView.registerClass(SightCollectionViewCell.self, forCellWithReuseIdentifier: "SightCollectionView_Cell")
        
        setupNavigationBar()
        loadSightData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewBottomView.frame = CGRectMake(0, 64, view.bounds.width, 36)
        scrollerView.ff_Fill(scrollViewBottomView)
        collectionView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: scrollViewBottomView, size: CGSizeMake(view.bounds.width, view.bounds.height - CGRectGetMaxY(scrollViewBottomView.frame)), offset: CGPointMake(0, 0))
        setupLayout()
    }
    
    func setupAutlLayout() {
        
//        scrollerView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 30), offset: CGPointMake(0, 64))
    }
    
    func setupNavigationBar() {

//        navigationController?.navigationBar.backIndicatorImage = nil
        navigationController?.navigationBar.barTintColor = SceneColor.black
        navigationController?.navigationBar.tintColor    = SceneColor.lightYellow
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : SceneColor.lightYellow]
    }
    
    ///  设置频道标签
    func setupChannel() {
       
        /// 间隔
        var x: CGFloat = 0
        let h: CGFloat = 36
        
        for label in channels! {
            let tag: SightListTags = label as! SightListTags
            let lab = UILabel.channelLabelWithTitle(tag.name!)
            
            lab.backgroundColor = UIColor.randomColor()
//            lab.tag = index
            lab.frame = CGRectMake(x, 0, lab.bounds.width, h)
            x += lab.bounds.width
            scrollerView.addSubview(lab)
        }
        
        scrollerView.contentSize = CGSizeMake(x, h)
        currentIndex = 0
    }


    private func setupLayout() {
        layout.itemSize = collectionView.bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - collectionView 数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if dataSource != nil {
            
//            SightListTags
            return (dataSource?.objectForKey("sightTags")?.count)!
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SightCollectionView_Cell", forIndexPath: indexPath) as! SightCollectionViewCell
        let dataType = dataSource?.objectForKey("sightTags") as! NSArray

        let data = dataType[indexPath.row] as! SightListTags
        
        cell.VC.sightId = data.id
        if (data.name == "文学" || data.name == "历史" || data.name == "地理") {
            
        } else if (data.name == "景观") {
            cell.urlString = "landscape"
        } else if (data.name == "书籍") {
            cell.urlString = "book"
        } else if (data.name == "视频") {
            cell.urlString = "video"
        } else {
            cell.urlString = "bbbb"
        }
        
        
        
        
        
        
        cell.backgroundColor = UIColor.randomColor()
//        if (!childViewControllers.contains(cell.VC)) {
//            
//            print("包含吗")
//            addChildViewController(cell.VC)
//            
//        }
        
        
        
        
        
        
        
        
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
