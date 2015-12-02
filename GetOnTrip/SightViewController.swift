//
//  SightListController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/28.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

struct SightLabelType {
    /// 话题
    static let Topic = 1
    /// 景观
    static let Landscape = 2
    /// 书籍
    static let Book  = 3
    /// 视频
    static let Video = 4
}

class SightViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIChannelLabelDelegate {
    
    /// 自定义导航
    var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: UIColor.whiteColor(), titleSize: 18)
    
    /// 景点id
    var sightId: String {
        return sightDataSource.id
    }
    
    /// 数据
    var sightDataSource = Sight(id: "") {
        didSet {
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
    
    /// 更在加载中提示
    var loadingView: LoadingView = LoadingView()
    
    /// 缓存cell
    lazy var collectionViewCellCache = [Int : [TopicBrief]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupAutlLayout()
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
        view.addSubview(loadingView)
        
        navBar.setTitle(sightDataSource.name)
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")
        navBar.setRightBarButton(UIImage(named: "bar_collect"), title: nil, target: self, action: "favoriteAction:")
        navBar.rightButton.setImage(UIImage(named: "bar_collect_select"), forState: UIControlState.Selected)
        navBar.setRight2BarButton(UIImage(named: "bar_city"), title: nil, target: self, action: "cityAction:")
        navBar.setBlurViewEffect(false)
        navBar.setButtonTintColor(UIColor.yellowColor())
        navBar.backgroundColor = SceneColor.frontBlack
        
        labelScrollView.backgroundColor = SceneColor.bgBlack
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.bounces    = false
        collectionView.backgroundColor = .whiteColor()
        collectionView.registerClass(SightCollectionViewCell.self, forCellWithReuseIdentifier: "SightCollectionView_Cell")
    }
    
    func setupAutlLayout() {
        labelNavView.frame = CGRectMake(0, 64, view.bounds.width, 36)
        labelScrollView.frame = labelNavView.bounds
        collectionView.ff_AlignVertical(.BottomLeft, referView: labelNavView, size: CGSizeMake(view.bounds.width, view.bounds.height - CGRectGetMaxY(labelNavView.frame)), offset: CGPointMake(0, 0))
        loadingView.ff_AlignInner(.CenterCenter, referView: view, size: loadingView.getSize(), offset: CGPointMake(0, 0))
        setupLayout()
    }
    
    ///  设置频道标签
    var indicateW: CGFloat?
    
    func setupChannel(labels: [Tag]) {
        if labels.count == 0 || labelScrollView.subviews.count > 2 {
            return
        }
        /// 间隔
        var x: CGFloat  = 0
        let h: CGFloat  = 36
        var lW: CGFloat = UIScreen.mainScreen().bounds.width / CGFloat(labels.count)
        var index: Int = 0
        for tag in labels {
            
            if labels.count >= 7 {
                lW = tag.name.sizeofStringWithFount(UIFont.systemFontOfSize(14), maxSize: CGSize(width: CGFloat.max, height: 14)).width + 20
            }
            if lW < UIScreen.mainScreen().bounds.width / CGFloat(7) {
                lW = UIScreen.mainScreen().bounds.width / CGFloat(7)
            }
            let channelLabel      = UIChannelLabel.channelLabelWithTitle(tag.name, width: lW, height: h, fontSize: 14)
            channelLabel.adjustsFontSizeToFitWidth = true
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
        
        indicateView.bounds = CGRectMake(0, 0, lW, 1.5)
        indicateView.center = CGPointMake(lW * 0.5, CGRectGetMaxY(labelScrollView.frame) - 1.5)
        labelScrollView.contentSize  = CGSizeMake(x, 0)
        labelScrollView.contentInset = UIEdgeInsetsZero
        labelScrollView.bounces = false
        labelScrollView.showsHorizontalScrollIndicator = false
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
        let tagObject = sightDataSource.tags[indexPath.row]
        tagObject.sightId = sightId
        cell.tagData      = tagObject
        
        let type = Int(tagObject.type)
        if type == SightLabelType.Topic {
            if let data = collectionViewCellCache[indexPath.row] {
                cell.topicVC.topics = data
                cell.topicVC.tableView.reloadData()
            } else {
                cell.topicVC.topics.removeAll()
                cell.topicVC.tableView.reloadData()
                cell.topicVC.tableView.mj_header.beginRefreshing()
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
        
        var nextLabel: UILabel?
        let array = collectionView.indexPathsForVisibleItems()
        for path in array {
            if path.item != currentIndex {
                nextLabel = labelScrollView.subviews[path.item] as? UILabel
            }
        }
        if nextLabel == nil { nextLabel = UILabel() }
        self.labelScrollView.setContentOffset(CGPointMake(offset, 0), animated: true)
        UIView.animateWithDuration(0.5) { () -> Void in
            self.indicateView.center.x = (scrollView.contentOffset.x % self.view.bounds.width) / (nextLabel!.center.x - labCenter.center.x) + labCenter.center.x - offset
            self.indicateView.bounds = CGRectMake(0, 0, labCenter.bounds.width, 1.5)
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
        loadingView.start()
        lastRequest?.fetchModels({ [weak self] (sight, status) -> Void in
            self?.loadingView.stop()
            if status == RetCode.SUCCESS {
                if let sight = sight {
                    self?.sightDataSource = sight
                    self?.setupChannel(sight.tags)
                    self?.navBar.rightButton.selected = sight.isFavorite()
                }
            } else {
                ProgressHUD.showErrorHUD(self?.view, text: "您的网络不给力!")
            }
        })
    }
    
    /// 收藏操作
    func favoriteAction(sender: UIButton) {
        
        sender.selected = !sender.selected
        let type  = FavoriteContant.TypeSight
        let objid = self.sightDataSource.id
        Favorite.doFavorite(type, objid: objid, isFavorite: sender.selected) {
            (result, status) -> Void in
            if status == RetCode.SUCCESS {
                if result == nil {
                    sender.selected = !sender.selected
                } else {
                    ProgressHUD.showSuccessHUD(self.view, text: sender.selected ? "已收藏" : "已取消")
                }
            } else {
                sender.selected = !sender.selected
                ProgressHUD.showErrorHUD(self.view, text: "操作未成功，请稍后再试")
            }
        }
    }
    
    /// 跳至城市页
    func cityAction(sender: UIButton) {
        let cityViewController = CityViewController()
        let city = City(id: self.sightDataSource.cityid)
        cityViewController.cityDataSource = city
        navigationController?.pushViewController(cityViewController, animated: true)
    }
}
