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

class SightViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIChannelLabelDelegate {
    
    /// 自定义导航
    var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: UIColor.whiteColor(), titleSize: 18)
    
    /// 景点id
    var sightId: String = ""
    
    /// 景点名称
    var sightName: String = ""
    
    /// 数据
    var sightDataSource = Sight() {
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
    var currentIndex: Int = 0
    
    /// 左滑手势是否生效
    var isPopGesture: Bool = false
    
    /// 缓存cell
    lazy var collectionViewCellCache = [Int : [TopicBrief]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        loadSightData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.enabled = isPopGesture
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
    
    func initView() {
        view.backgroundColor = SceneColor.frontBlack
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(collectionView)
        view.addSubview(labelNavView)
        labelNavView.addSubview(labelScrollView)
        labelNavView.addSubview(indicateView)
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        
        navBar.setTitle(sightName)
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")
        navBar.setRightBarButton(UIImage(named: "search_icon"), title: nil, target: self, action: "searchAction:")
        navBar.setBlurViewEffect(false)
        navBar.setButtonTintColor(UIColor.yellowColor())
        navBar.backgroundColor = SceneColor.frontBlack
        
        labelScrollView.backgroundColor = SceneColor.bgBlack
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.registerClass(SightCollectionViewCell.self, forCellWithReuseIdentifier: "SightCollectionView_Cell")
        collectionView.bounces = false
        collectionView.backgroundColor = UIColor.whiteColor()
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
        let labels = sightDataSource.tags
        /// 间隔
        var x: CGFloat  = 0
        let h: CGFloat  = 36
        var lW: CGFloat = UIScreen.mainScreen().bounds.width / CGFloat(labels.count)
        if labels.count >= 7 {
            lW = UIScreen.mainScreen().bounds.width / CGFloat(7)
        } 
        var index: Int = 0
        for tag in labels {
            let channelLabel      = UIChannelLabel.channelLabelWithTitle(tag.name, width: lW, height: h, fontSize: 14)
            channelLabel.delegate = self
            channelLabel.tag      = index
            channelLabel.frame    = CGRectMake(x, 0, channelLabel.bounds.width, h)
            channelLabel.textColor       = UIColor.whiteColor()
            channelLabel.backgroundColor = UIColor.clearColor()
            x += channelLabel.bounds.width
            
            if indicateW == nil {
                indicateW = channelLabel.bounds.width
            }
            
            index++
            labelScrollView.addSubview(channelLabel)
        }
        
        indicateView.bounds = CGRectMake(0, 0, 56, 1.5)
        indicateView.center = CGPointMake(lW * 0.5, CGRectGetMaxY(labelScrollView.frame) - 1.5)
        labelScrollView.contentSize  = CGSizeMake(x, 0)
        labelScrollView.contentInset = UIEdgeInsetsZero
        collectionView.contentSize   = CGSizeMake(view.bounds.width * CGFloat(labels.count), view.bounds.height - h)
        
        currentIndex = 0
    }
    
    private func setupLayout() {
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64 - 36)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing      = 0
        layout.scrollDirection         = UICollectionViewScrollDirection.Horizontal
        collectionView.pagingEnabled   = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - collectionView 数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sightDataSource.tags.count
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
        
        cell.cellId = indexPath.row
        let labelData = sightDataSource.tags[indexPath.row]
        labelData.sightId = sightId
        cell.sightId      = sightId
        cell.labelData    = labelData
        
        let type = Int(cell.labelData?.type ?? "0")
        if type != CategoryLabel.sightLabel &&
           type != CategoryLabel.bookLabel  &&
           type != CategoryLabel.videoLabel {
            if let data = collectionViewCellCache[indexPath.row] {
                cell.topicVC.topics = data
                cell.topicVC.tableView.reloadData()
            } else {
                cell.topicVC.topics.removeAll()
                cell.topicVC.tableView.reloadData()
                cell.topicVC.tableView.header.beginRefreshing()
            }
        }
        
        return cell
    }
    
    // MARK: - scrollerView 代理方法
    func scrollViewDidScroll(scrollView: UIScrollView) {

        currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        let labCenter: UILabel = labelScrollView.subviews[currentIndex] as! UILabel
        
        // 计算当前选中标签的中心点
        var offset: CGFloat    = labCenter.center.x - labelScrollView.bounds.width * 0.5
        let maxOffset: CGFloat = labelScrollView.contentSize.width - labelScrollView.bounds.width
        if (offset < 0) {
            offset = 0
        } else if (offset > maxOffset) {
            offset = maxOffset
        }
        
        let lCount: Int = sightDataSource.tags.count >= 7 ? 7 : sightDataSource.tags.count
        let x: CGFloat  = scrollView.contentOffset.x / CGFloat(lCount)  - offset
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
    func labelDidSelected(label: UIChannelLabel) {
        currentIndex  = label.tag
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
                    self?.sightDataSource = sight
                }
            } else {
                SVProgressHUD.showErrorWithStatus("您的网络不给力!!!")
            }
        })
    }
    
    ///  搜索跳入之后消失控制器
    func dismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
