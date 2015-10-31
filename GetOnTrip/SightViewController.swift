//
//  SightListController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/28.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

class SightViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SightLabelDelegate {
    
    /// 景点id
    var sightId: String = ""
    
    /// 景点名称
    var sightName: String = ""
    
    /// 数据
    var sight = Sight() {
        didSet {
            setupChannel()
            collectionView.reloadData()
        }
    }
    
    /// 标签导航栏的主视图
    lazy var labelNavView: UIView = UIView()
    
    /// 指示view
    lazy var indicateView: UIView = UIView(color: UIColor.yellowColor())
    
    /// 标签导航栏的scrollView
    lazy var labelScrollView = UIScrollView()
    
    /// 网络请求加载数据(添加)
    var lastRequest: SightRequest?
    
    /// 流水布局
    lazy var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    /// 底部容器view
    lazy var collectionView: UICollectionView = { [weak self] in
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: self!.layout)
        return cv
    }()
    
    /// 索引
    var currentIndex: Int?
    
    /// 左滑手势是否生效
    var isPopGesture: Bool = false
    
    /// 缓存cell
    lazy var collectionViewCellCache = [String : NSArray]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SceneColor.frontBlack
        
        //nav bar
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = sightName
        navigationItem.backBarButtonItem  = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButtonClicked:")

        view.addSubview(labelNavView)
        labelNavView.addSubview(labelScrollView)
        labelNavView.addSubview(indicateView)
        labelScrollView.backgroundColor = SceneColor.bgBlack
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.registerClass(SightCollectionViewCell.self, forCellWithReuseIdentifier: "SightCollectionView_Cell")
        collectionView.bounces = false
        loadSightData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let channels = sight.tags
        /// 间隔
        var x: CGFloat  = 0
        let h: CGFloat  = 36
        var lW: CGFloat = UIScreen.mainScreen().bounds.width / CGFloat(channels.count)
        if channels.count >= 7 {
            lW = UIScreen.mainScreen().bounds.width / CGFloat(7)
        } 
        var index: Int = 0
        for tag in channels {
            let lab = SightLabel.channelLabelWithTitle(tag.name, width: lW, height: h, fontSize: 14)
            
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
        
        indicateView.bounds = CGRectMake(0, 0, 56, 1.5)
        indicateView.center = CGPointMake(lW * 0.5, CGRectGetMaxY(labelScrollView.frame) - 1.5)
        labelScrollView.contentSize = CGSizeMake(x, 0)
        labelScrollView.contentInset = UIEdgeInsetsZero
        collectionView.contentSize = CGSizeMake(view.bounds.width * CGFloat(channels.count), view.bounds.height - h)
        
        currentIndex = 0
    }
    
    private func setupLayout() {
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64 - 36)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - collectionView 数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sight.tags.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        isPopGesture = indexPath.row == 0 ? true : false
        self.navigationController?.interactivePopGestureRecognizer?.enabled = isPopGesture
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SightCollectionView_Cell", forIndexPath: indexPath) as! SightCollectionViewCell
        if (!childViewControllers.contains(cell.landscapeVC)) {
            addChildViewController(cell.landscapeVC)
        }
        if (!childViewControllers.contains(cell.bookVC)) {
            addChildViewController(cell.bookVC)
        }
        if (!childViewControllers.contains(cell.videoVC)) {
            addChildViewController(cell.videoVC)
        }
        if (!childViewControllers.contains(cell.topicVC)) {
            addChildViewController(cell.topicVC)
        }
        
        let tag      = sight.tags[indexPath.row]
        cell.label   = tag
        cell.tagId   = sight.tags[indexPath.row].id
        cell.type    = Int(tag.type)
        cell.sightId = sightId
        return cell
    }
    
    func collectionViewCellCache(data: NSArray, type: String) {
        collectionViewCellCache[type] = data
    }
    
    
    // MARK: - scrollerView 代理方法
    func scrollViewDidScroll(scrollView: UIScrollView) {

        currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        let labCenter : UILabel = labelScrollView.subviews[currentIndex!] as! UILabel
        
        // 计算当前选中标签的中心点
        var offset: CGFloat = labCenter.center.x - labelScrollView.bounds.width * 0.5
        let maxOffset: CGFloat = labelScrollView.contentSize.width - labelScrollView.bounds.width
        if (offset < 0) { offset = 0 }
        else if (offset > maxOffset) { offset = maxOffset }
        
        let lCount: Int = sight.tags.count >= 7 ? 7 : sight.tags.count
        let x: CGFloat = scrollView.contentOffset.x / CGFloat(lCount)  - offset
        let x1: CGFloat = scrollView.contentOffset.x / CGFloat(lCount) + labCenter.bounds.width * 0.5
        if (offset == 0) || (offset == maxOffset) {
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                if lCount >= 7 { self.indicateView.frame.origin.x = x }
                else { self.indicateView.center.x = x1 }
                self.labelScrollView.setContentOffset(CGPointMake(offset, 0), animated: true)
            })
        } else {
            self.labelScrollView.setContentOffset(CGPointMake(offset, 0), animated: true)
            if self.indicateView.center.x != UIScreen.mainScreen().bounds.width * 0.5 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.indicateView.center.x = UIScreen.mainScreen().bounds.width * 0.5
                })
            }
        }
    }

    // MARK: - 自定义方法
    
    ///  标签选中方法
    func sightLabelDidSelected(label: SightLabel) {
        
        currentIndex = label.tag
        let indexPath = NSIndexPath(forItem: label.tag, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        
    }
    
    //获取数据
    private func loadSightData() {
        
        if lastRequest == nil {
            lastRequest = SightRequest()
            lastRequest?.sightId = sightId
        }
        
        lastRequest?.fetchFirstPageModels({ [weak self] (sight, status) -> Void in
            if status == RetCode.SUCCESS {
                if let sight = sight {
                    self?.sight = sight
                }
            } else {
                SVProgressHUD.showErrorWithStatus("您的网络不给力!!!")
            }
        })
    }

    func searchButtonClicked(button: UIBarButtonItem) {
        presentViewController(SearchViewController(), animated: true, completion: nil)
    }
    
    ///  搜索跳入之后消失控制器
    func dismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
