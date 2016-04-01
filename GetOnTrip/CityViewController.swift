//
//  CityCenterPageController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

struct CityConstant {
    static let headerViewHeight:CGFloat = 198
    static let collectionViewHeight:CGFloat = 196
    static let subtitleButtonHeight:CGFloat = 34
    
    //city
    static let cityTopicTableViewCellID   = "CityHotTopicTableViewCellID"
    static let citySightCollectionViewCellID = "CitySightCollectionViewCellID"
}

/// 城市中间页
class CityViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIChannelLabelDelegate {
    
    /// 网络请求加载数据(添加)
    var lastRequest: CityRequest = CityRequest()
    /// 自定义导航
    var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: UIColor.whiteColor(), titleSize: 18)
    /// 景点id
    var cityId: String = "" {
        didSet {
            lastRequest.cityId = cityId
        }
    }
    /// 数据
    var sightDataSource = Sight(id: "") {
        didSet {
            if sightDataSource.cityid != "" {
                cityId = sightDataSource.cityid
            }
            initBaseTableViewController(sightDataSource.tags)
            if landscape != nil {
                labelDidSelected(landscape!)
            }
            collectionView.reloadData()
            navBar.rightButton.selected = sightDataSource.isFavorite() ? true : false
        }
    }
    
    /// 标签导航栏的主视图
    lazy var labelNavView: UIView = UIView()
    /// 指示view
    lazy var indicateView: UIView = UIView(color: UIColor.yellowColor())
    /// 标签导航栏的scrollView
    lazy var labelScrollView = UIScrollView()
    /// 流水布局
    lazy var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    /// 底部容器view
    lazy var collectionView: UICollectionView = { [weak self] in
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: self!.layout)
        return cv
        }()
    /// 索引
    lazy var currentIndex: Int = 0
    /// 左滑手势是否生效
    lazy var isPopGesture: Bool = false
    /// 更在加载中提示
    lazy var loadingView: LoadingView = LoadingView()
    
    lazy var dataControllers = [BaseTableViewController]()
    /// 是否是由城市控制器跳转进来的
    var isSuperCityController: Bool = false
    /// 播放图标
    lazy var pulsateView: PlayPulsateView = PlayPulsateView()
    /// 切换播放控制器
    lazy var switchPlayControl: UIControl = UIControl()
    /// 播放器控制器
    var playController = CityPlayRulsateView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupAutlLayout()
        loadSightData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        
        if event!.type == UIEventType.RemoteControl {
            if event!.subtype == UIEventSubtype.RemoteControlPlay {
                print("received remote play")
                playController.updatePlayOrPauseBtn(false)
            } else if event!.subtype == UIEventSubtype.RemoteControlPause {
                print("received remote pause")
                playController.updatePlayOrPauseBtn(true)
            } else if event!.subtype == UIEventSubtype.RemoteControlTogglePlayPause {
                print("received toggle")
            }
        }
    }

    /// 当出现内存警告时，清空缓存
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        playController.cache.removeAllObjects()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.enabled = isPopGesture
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        labelNavView.layoutIfNeeded()
        labelScrollView.layoutIfNeeded()
    }
    
    private func initView() {
        view.backgroundColor = SceneColor.frontBlack
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(collectionView)
        view.addSubview(labelNavView)
        labelNavView.addSubview(labelScrollView)
        labelNavView.addSubview(indicateView)
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        view.addSubview(loadingView)
        
        initNavBar()
        labelScrollView.backgroundColor = SceneColor.bgBlack
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.bounces    = false
        collectionView.backgroundColor = .whiteColor()
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    }
    
    private func initNavBar() {
        navBar.setTitle(sightDataSource.name)
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: #selector(CityViewController.popViewAction(_:)))
        navBar.setRightBarButton(UIImage(named: "collect_sight"), title: nil, target: self, action: #selector(CityViewController.favoriteAction(_:)))
        navBar.rightButton.setImage(UIImage(named: "collect_yellow")!, forState: UIControlState.Selected)
        navBar.setBlurViewEffect(false)
        navBar.setButtonTintColor(UIColor.yellowColor())
        navBar.backgroundColor = SceneColor.frontBlack
        
        navBar.addSubview(pulsateView)
        pulsateView.frame = CGRectMake(50, 50, 100, 100)
        pulsateView.backgroundColor = UIColor.whiteColor()
        pulsateView.color = .whiteColor()
        pulsateView.ff_AlignHorizontal(.CenterCenter, referView: navBar, size: CGSizeMake(17, 17), offset:
            CGPointMake((sightDataSource.name.sizeofStringWithFount(UIFont.systemFontOfSize(17), maxSize: CGSize(width: CGFloat.max, height: 17)).width ?? 0) * 0.5 , -73))
        pulsateView.playIconAction()
        playController.pulsateView = pulsateView
        pulsateView.hidden = true
        
        navBar.addSubview(switchPlayControl)
        switchPlayControl.backgroundColor = UIColor.clearColor()
        switchPlayControl.addTarget(self, action: #selector(CityViewController.switchPlayControllerAction), forControlEvents: .TouchUpInside)
        switchPlayControl.ff_AlignInner(.CenterCenter, referView: navBar, size: CGSizeMake(200, 40))
        playController.title = sightDataSource.name
    }
    
    func switchPlayControllerAction() {
        if playController.isPlay {
            let vc = SightDetailViewController()
            vc.cityPlayViewController = playController
            vc.dataSource = playController.playCell?.landscape ?? Landscape()
            vc.playCell = playController.playCell
            vc.index = playController.index
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupAutlLayout() {
        labelNavView.frame = CGRectMake(0, 64, view.bounds.width, 36)
        labelScrollView.frame = labelNavView.bounds
        collectionView.ff_AlignVertical(.BottomLeft, referView: labelNavView, size: CGSizeMake(view.bounds.width, view.bounds.height - CGRectGetMaxY(labelNavView.frame)), offset: CGPointMake(0, 0))
        loadingView.ff_AlignInner(.CenterCenter, referView: view, size: loadingView.getSize(), offset: CGPointMake(0, 0))
        setupLayout()
    }
    
    deinit {
        playController.stopTimer()
    }
    
    ///  设置频道标签
    var indicateW: CGFloat?
    var landscape: UIChannelLabel?
    func setupChannel(labels: [Tag]) {
        if labels.count == 0 || labelScrollView.subviews.count > 2 {
            return
        }
        /// 间隔
        var x: CGFloat  = 0
        let h: CGFloat  = 36
        var lW: CGFloat = Frame.screen.width / CGFloat(labels.count)
        var index: Int = 0
        for tag in labels {
            
            if labels.count >= 7 {
                lW = tag.name.sizeofStringWithFount(UIFont.systemFontOfSize(14), maxSize: CGSize(width: CGFloat.max, height: 14)).width + 20
            }
            if lW < Frame.screen.width / CGFloat(7) {
                lW = Frame.screen.width / CGFloat(7)
            }
            let channelLabel      = UIChannelLabel.channelLabelWithTitle(tag.name, width: lW, height: h, fontSize: 14)
            channelLabel.adjustsFontSizeToFitWidth = true
            channelLabel.delegate = self
            channelLabel.tag      = index
            channelLabel.frame    = CGRectMake(x, 0, channelLabel.bounds.width, h)
            channelLabel.textColor       = UIColor.whiteColor()
            channelLabel.backgroundColor = UIColor.clearColor()
            x += channelLabel.bounds.width
            
            if indicateW == nil { indicateW = channelLabel.bounds.width }
            index += 1
            labelScrollView.addSubview(channelLabel)
            if tag.type == SightLabelType.Landscape {
                landscape = channelLabel
            }
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
        navigationController?.interactivePopGestureRecognizer?.enabled = isPopGesture
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath)
        cell.addSubview(dataControllers[indexPath.row].tableView)
        dataControllers[indexPath.row].tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 90)
        return cell
    }
    
    // MARK: - scrollerView 代理方法
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        let labCenter: UILabel = (labelScrollView.subviews[currentIndex] as? UILabel) ?? UILabel()
        
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
        loadingView.start()
        lastRequest.fetchModels({ [weak self] (sight, status) -> Void in
            self?.loadingView.stop()
            if status == RetCode.SUCCESS {
                if let sight = sight {
                    if self?.navBar.titleLabel.text == "" {
                        self?.navBar.setTitle(sight.name)
                    }
                    self?.sightDataSource = sight
                    self?.setupChannel(sight.tags)
                }
            } else {
                //不再浮层提示  TODO://空白页面提示"无法连接网络"，想法：往后只有用户手动更新才会浮层显示，其他都在页面提示
                // ProgressHUD.showErrorHUD(self?.view, text: MessageInfo.NetworkError)
            }
            })

    }
    
    /// 初始化所需控制器
    private func initBaseTableViewController(tags: [Tag]) {
        for obj in tags {
            obj.sightId = cityId
            switch obj.type {
            case SightLabelType.Topic:
                let v = SightTopicViewController()
                v.lastRequest.enterInfo = "city"
                v.tagData = obj
                addChildViewController(v)
                dataControllers.append(v)
            case SightLabelType.Landscape:
                let v = CityLandscapeController()
                v.cityId = obj.sightId
                addChildViewController(v)
                dataControllers.append(v)
            case SightLabelType.Book:
                let v = SightBookViewController()
                v.lastRequest.enterInfo = "city"
                v.sightId = obj.sightId
                addChildViewController(v)
                dataControllers.append(v)
            case SightLabelType.Video:
                let v = SightVideoViewController()
                v.lastVideoRequest.enterInfo = "city"
                v.sightId = obj.sightId
                addChildViewController(v)
                dataControllers.append(v)
            case SightLabelType.food:
                let v = SightFoodViewController()
                v.lastRequest.enterInfo = "city"
                v.sightId = obj.sightId
                addChildViewController(v)
                dataControllers.append(v)
            case SightLabelType.specialty:
                let v = SightSpecialtyViewController()
                v.lastRequest.enterInfo = "city"
                v.sightId = obj.sightId
                addChildViewController(v)
                dataControllers.append(v)
            default:
                break
            }
        }
    }
    
    /// 收藏操作
    func favoriteAction(sender: UIButton) {
        Statistics.shareStatistics.event(Event.collect_eventid, labelStr: "city")
        sender.selected = !sender.selected
        let type  = FavoriteContant.TypeCity
        let objid = self.cityId
        Favorite.doFavorite(type, objid: objid, isFavorite: sender.selected) {
            (result, status) -> Void in
            if status == RetCode.SUCCESS {
                if result == nil {
                    sender.selected = !sender.selected
                } else {
                    ProgressHUD.showSuccessHUD(self.view, text: sender.selected ? "已收藏" : "已取消")
                }
            } else {
                ProgressHUD.showSuccessHUD(self.view, text: "操作未成功，请稍候再试!")
                sender.selected = !sender.selected
            }
        }
    }
}
