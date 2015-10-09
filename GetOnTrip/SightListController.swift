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
    
    /// 指示view
    lazy var indicate: UIView = UIView(color: UIColor.yellowColor())
    
    /// 标签视图
    lazy var scrollerViewLabel = UIScrollView()
    
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
    
    deinit {
        print("我走了\(__FUNCTION__)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(scrollViewBottomView)
        scrollViewBottomView.addSubview(scrollerViewLabel)
        view.addSubview(collectionView)
        scrollViewBottomView.addSubview(indicate)
        scrollerViewLabel.backgroundColor = SceneColor.sightGrey
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        
        collectionView.registerClass(SightCollectionViewCell.self, forCellWithReuseIdentifier: "SightCollectionView_Cell")
        
        setupNavigationBar()
        loadSightData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewBottomView.frame = CGRectMake(0, 64, view.bounds.width, 36)
        scrollerViewLabel.ff_Fill(scrollViewBottomView)
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
    var indicateW: CGFloat?
    func setupChannel() {
       
        /// 间隔
        var x: CGFloat = 0
        let h: CGFloat = 36
        
        for label in channels! {
            let tag: SightListTags = label as! SightListTags
            let lab = UILabel.channelLabelWithTitle(tag.name!)
            lab.textColor = UIColor.whiteColor()
            lab.backgroundColor = UIColor.clearColor()
//            lab.tag = index
            lab.frame = CGRectMake(x, 0, lab.bounds.width, h)
            x += lab.bounds.width
            
            if indicateW == nil {
                indicateW = lab.bounds.width
            }
            
            scrollerViewLabel.addSubview(lab)
        }
        
        indicate.frame = CGRectMake(0, CGRectGetMaxY(scrollerViewLabel.frame) - 2.5, indicateW!, CGFloat(1.5))
        scrollerViewLabel.contentSize = CGSizeMake(x, h)
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
        
        return dataSource != nil ? dataSource!.objectForKey("sightTags")!.count : 0
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
        
        if (!childViewControllers.contains(cell.VC)) {
            addChildViewController(cell.VC)
        }
        
        return cell
    }
    
    // MARK - scrollerView 代理方法
    var offset1: CGFloat = 0
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        _: UILabel = scrollerViewLabel.subviews[currentIndex!] as! UILabel
        var nextLabel: UILabel?
        
        let array = collectionView.indexPathsForVisibleItems()
        for path in array {
            if path.item != currentIndex {
                nextLabel = scrollerViewLabel.subviews[path.item] as? UILabel
                
            }
        }
        
        if nextLabel == nil {
            return
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        
        // 计算当前选中标签的中心点
        let l = scrollerViewLabel.subviews[currentIndex!]
        var offset: CGFloat = l.center.x - scrollerViewLabel.bounds.width * 0.5
        let maxOffset: CGFloat = scrollerViewLabel.contentSize.width - scrollerViewLabel.bounds.width
        
        if (offset < 0) {
            offset = 0
        } else if (offset > maxOffset) {
            offset = maxOffset
        }

        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.indicate.frame.origin.x = l.frame.origin.x
        })
        scrollerViewLabel.setContentOffset(CGPointMake(offset, 0), animated: true)
        UIView.animateWithDuration(0.5) { () -> Void in
            self.indicate.frame.origin.x -=  offset
        }
        offset1 = offset
    }
}
