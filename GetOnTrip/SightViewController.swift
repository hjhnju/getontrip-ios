//
//  SightListController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/28.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class SightViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SightLabelDelegate {

    /// 景点列表id
    var sightId: String?
    
    //景点名称
    var sightName: String = ""
    
    //标签导航栏的主视图
    lazy var labelNavView: UIView = UIView()
    
    //指示view
    lazy var indicateView: UIView = UIView(color: UIColor.yellowColor())
    
    //标签导航栏的scrollView
    lazy var labelScrollView = UIScrollView()
    
    /// 标签数组
    var channels: NSArray?
    
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: SightListRequest?
    
    /// 流水布局
    lazy var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    /// 底部容器view
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nav bar
        view.backgroundColor = SceneColor.frontBlack //barStyle=Opaque时决定了导航颜色
        navigationItem.title = sightName
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.yellowColor()

        view.addSubview(labelNavView)
        labelNavView.addSubview(labelScrollView)
        labelNavView.addSubview(indicateView)
        labelScrollView.backgroundColor = SceneColor.bgBlack
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.registerClass(SightCollectionViewCell.self, forCellWithReuseIdentifier: "SightCollectionView_Cell")
        
        loadSightData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupAutlLayout()
        labelNavView.layoutIfNeeded()
        labelScrollView.layoutIfNeeded()
    }
    
    func setupAutlLayout() {
        labelNavView.frame = CGRectMake(0, 64, view.bounds.width, 36)
        labelScrollView.frame = labelNavView.bounds
        collectionView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: labelNavView, size: CGSizeMake(view.bounds.width, view.bounds.height - CGRectGetMaxY(labelNavView.frame)), offset: CGPointMake(0, 0))
        setupLayout()
    }
    
    ///  设置频道标签
    var indicateW: CGFloat?
    func setupChannel() {
       
        /// 间隔
        var x: CGFloat = 0
        let h: CGFloat = 36
        var lW: CGFloat?
        lW = UIScreen.mainScreen().bounds.width / CGFloat(channels!.count)
        if channels!.count >= 7 {
            lW = UIScreen.mainScreen().bounds.width / CGFloat(7)
        } 
        var index: Int = 0
        for label in channels! {
            let tag: SightListTags = label as! SightListTags
            let lab = SightLabel.channelLabelWithTitle(tag.name!, width: lW!, height: h, fontSize: 14) 
                //fontSize: CGFloat(UIScreen.mainScreen().bounds.width / CGFloat(channels!.count)))
            
            lab.delegate = self
            lab.textColor = UIColor.whiteColor()
            lab.backgroundColor = UIColor.clearColor()
            lab.tag = index
            lab.frame = CGRectMake(x, 0, lab.bounds.width, h)
            x += lab.bounds.width
            
            if indicateW == nil {
                indicateW = lab.bounds.width
            }
            
            index++
            labelScrollView.addSubview(lab)
        }
        
        indicateView.frame = CGRectMake(0, CGRectGetMaxY(labelScrollView.frame) - 2.5, indicateW!, CGFloat(1.5))
        labelScrollView.contentSize = CGSizeMake(x, h)
        labelScrollView.setContentOffset(CGPointMake(0, 18), animated: false)
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
        
        cell.VC.sightId = sightId!
        let labId = channels![indexPath.row] as! SightListTags
        cell.VC.tagId = labId.id!
         if (data.name == "景观") {
            cell.urlString = "landscape"
        } else if (data.name == "书籍") {
            cell.urlString = "book"
        } else if (data.name == "视频") {
            cell.urlString = "video"
        } else {
            cell.urlString = "其他"
        }
        
        if (!childViewControllers.contains(cell.VC)) {
            addChildViewController(cell.VC)
        }
        
        return cell
    }
    
    // MARK - scrollerView 代理方法
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        let labCenter : UILabel = labelScrollView.subviews[currentIndex!] as! UILabel
        var nextLabel: UILabel?
        
        let array = collectionView.indexPathsForVisibleItems()
        for path in array {
            if path.item != currentIndex {
                nextLabel = labelScrollView.subviews[path.item] as? UILabel
            }
        }
        
        if nextLabel == nil { return }
    
        // 计算当前选中标签的中心点
        var offset: CGFloat = labCenter.center.x - labelScrollView.bounds.width * 0.5
        let maxOffset: CGFloat = labelScrollView.contentSize.width - labelScrollView.bounds.width
        if (offset < 0) {
            offset = 0
        } else if (offset > maxOffset) {
            offset = maxOffset
        }
        
        labelScrollView.setContentOffset(CGPointMake(offset, 0), animated: true)
        let lCount: Int = channels!.count >= 7 ? 7 : channels!.count
        let x: CGFloat = scrollView.contentOffset.x / CGFloat(lCount) - offset
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.indicateView.frame.origin.x = x
        })
    }
    
    ///  标签选中方法
    func sightLabelDidSelected(label: SightLabel) {
        
        currentIndex = label.tag
        let indexPath = NSIndexPath(forItem: label.tag, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        
    }
    
    //获取数据
    private func loadSightData() {
        
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = SightListRequest()
            lastSuccessAddRequest?.sightId = sightId
        }
        
        lastSuccessAddRequest?.fetchSightListModels {[unowned self] (handler: NSDictionary) -> Void in
            self.dataSource = handler
        }
    }
}
