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
    static let Topic = "1"
    /// 景观
    static let Landscape = "2"
    /// 书籍
    static let Book  = "3"
    /// 视频
    static let Video = "4"
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
            initBaseTableViewController(sightDataSource.tags)
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
    lazy var currentIndex: Int = 0
    
    /// 左滑手势是否生效
    lazy var isPopGesture: Bool = false
    
    /// 更在加载中提示
    lazy var loadingView: LoadingView = LoadingView()
    
    lazy var dataControllers = [BaseTableViewController]()
    /// 切换城市和收藏景点
    lazy var menuSwitchView: MenuSwitchView = MenuSwitchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupAutlLayout()
        loadSightData()
        initMenuSwitch()
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
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")
        navBar.setRightBarButton(UIImage(named: "moreSelect_sight"), title: nil, target: self, action: "showMoreSelect")
        navBar.setBlurViewEffect(false)
        navBar.setButtonTintColor(UIColor.yellowColor())
        navBar.backgroundColor = SceneColor.frontBlack
    }
    
    func setupAutlLayout() {
        labelNavView.frame = CGRectMake(0, 64, view.bounds.width, 36)
        labelScrollView.frame = labelNavView.bounds
        collectionView.ff_AlignVertical(.BottomLeft, referView: labelNavView, size: CGSizeMake(view.bounds.width, view.bounds.height - CGRectGetMaxY(labelNavView.frame)), offset: CGPointMake(0, 0))
        loadingView.ff_AlignInner(.CenterCenter, referView: view, size: loadingView.getSize(), offset: CGPointMake(0, 0))
        setupLayout()
    }
    
    private func initMenuSwitch() {
        menuSwitchView.initPoint = CGPointMake(Frame.screen.width - 23, 56)
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
                //不再浮层提示  TODO://空白页面提示"无法连接网络"，想法：往后只有用户手动更新才会浮层显示，其他都在页面提示
                // ProgressHUD.showErrorHUD(self?.view, text: MessageInfo.NetworkError)
            }
        })
    }
    
    /// 初始化所需控制器
    private func initBaseTableViewController(tags: [Tag]) {
        for obj in tags {
            obj.sightId = sightId
            switch obj.type {
            case SightLabelType.Topic:
                let v = SightTopicViewController()
                v.tagData = obj
                addChildViewController(v)
                dataControllers.append(v)
            case SightLabelType.Landscape:
                let v = SightLandscapeController()
                v.sightId = obj.sightId
                addChildViewController(v)
                dataControllers.append(v)
            case SightLabelType.Book:
                let v = SightBookViewController()
                v.sightId = obj.sightId
                addChildViewController(v)
                dataControllers.append(v)
            case SightLabelType.Video:
                let v = SightVideoViewController()
                v.sightId = obj.sightId
                addChildViewController(v)
                dataControllers.append(v)
            default:
                break
            }
        }
    }
    

    

    
    /// 显示更多选择
    func showMoreSelect() {
        menuSwitchView.showSwitchAction()
    }
    
    // 切换城市和收藏景点方法
    func selectSwitchAction(sender: UIButton) {
        if sender.tag == 1 {
            cityAction()
        } else if sender.tag == 2 {
            for item in menuSwitchView.subviews {
                if item.tag == 2 {
                    if let btn = item as? UIButton {
                        favoriteAction((btn))
                    }
                }
            }
        }
    }
    
    /// 跳至城市页
    func cityAction() {
        let cityViewController = CityViewController()
        let city = City(id: self.sightDataSource.cityid)
        cityViewController.cityDataSource = city
        navigationController?.pushViewController(cityViewController, animated: true)
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
}
