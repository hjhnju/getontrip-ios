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
class CityViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: Properties and Outlets
    
    /// 自定义导航
    var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: UIColor.whiteColor(), titleSize: 18)
    
    /// 城市背影图片
    var headerImageView: UIImageView = UIImageView()
    
    //头部视图高度约束
    var headerHeightConstraint: NSLayoutConstraint?
    
    /// collectionview及imageView底部的view
    lazy var tableHeaderView: UIView = UIView()
    
    /// 热门景点＋热门内容
    lazy var tableView: UITableView = UITableView()
    
    /// 城市名
    lazy var cityNameLabel: UILabel = UILabel(color: SceneColor.white, fontSize: 26, mutiLines: true)
    /// 收藏按钮
    lazy var favTextBtn: UIButton = UIButton(title: "收藏", fontSize: 12, radius: 0)
    /// 收藏按钮
    lazy var favIconBtn: UIButton = UIButton(icon: "city_star", masksToBounds: false)
    
    /// 界面布局
    let layout = UICollectionViewFlowLayout()
    
    /// 热门景点内容
    lazy var collectionView: UICollectionView =  { [weak self] in
        let collect = UICollectionView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, CityConstant.collectionViewHeight), collectionViewLayout: (self?.layout)!)
        return collect
    }()
    
    /// 热门景点
    lazy var moreSightsButton: homeSightButton = homeSightButton(image: "city_more", title: "热门景点", fontSize: 17, titleColor: SceneColor.white)
    
    /// 热门话题标题
    lazy var hotTopBarButton: UIButton = UIButton(title: "热门内容", fontSize: 17, radius: 0, titleColor: SceneColor.white)

    /// 热门话题图标
    lazy var refreshTopicButton: UIButton = UIButton(icon: "city_refresh", masksToBounds: false)
    
    /// 网络请求加载数据(添加)
    var lastRequest: CityRequest?
    
    /// 刷新话题请求
    var refreshTopicRequest: TopicRefreshRequest?
    
    var pageNumber: Int = 1
    
    // MARK: 数据源

    var cityId: String {
        return cityDataSource?.id ?? ""
    }
    
    var cityDataSource : City? {
        didSet {
            if let city = cityDataSource {
                //用已有image占位，这样转场传递小图不会被默认图覆盖
                headerImageView.sd_setImageWithURL(NSURL(string: city.image), placeholderImage:headerImageView.image)
                cityNameLabel.text = city.name
                navBar.titleLabel.text = city.name
                favIconBtn.selected = city.collected == "" ? false : true
            }
        }
    }
    
    var tableViewContentOffset: CGPoint = CGPointZero
    var tableViewDataSource = [TopicBrief]() {
        didSet {
            tableViewContentOffset = tableView.contentOffset
            tableView.reloadData()
            tableView.setContentOffset(tableViewContentOffset, animated: false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        tableViewContentOffset = tableView.contentOffset
    }
    
    var collectionDataSource = [Sight]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //导航透明度
    var navBarAlpha:CGFloat = 0.0
    
    // MARK: - 初始化相关内容
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupAutoLayout()
        loadCityData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshBar()
    }
    
    func refreshBar(){
        //设置导航样式
        navBar.titleLabel.alpha = navBarAlpha
        if navBarAlpha > 0.2 {
            navBar.titleLabel.hidden = false //设置alpha=0会有Fade Out
        } else {
            navBar.titleLabel.hidden = true
        }
        
        //headerImage标题
        cityNameLabel.alpha = 1 - navBarAlpha
        favIconBtn.alpha = 1 - navBarAlpha
        favTextBtn.alpha = 1 - navBarAlpha
        
        //navBar.setBlurViewEffectColor(SceneColor.frontBlack, alpha: navBarAlpha)
        navBar.backgroundColor = SceneColor.frontBlack.colorWithAlphaComponent(navBarAlpha)
    }
    
    /// 添加控件
    private func initView() {
        view.backgroundColor = SceneColor.bgBlack
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(headerImageView)
        view.addSubview(tableView)
        view.bringSubviewToFront(headerImageView)
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")
        navBar.setBlurViewEffect(false)
        navBar.setButtonTintColor(UIColor.yellowColor())
        navBar.backgroundColor = SceneColor.frontBlack.colorWithAlphaComponent(navBarAlpha)
        navBar.titleLabel.hidden = true
        
        
        headerImageView.userInteractionEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.contentSize = CGSizeMake(200, 100)
        
        headerImageView.contentMode = UIViewContentMode.ScaleAspectFill
        headerImageView.clipsToBounds = true
        headerImageView.addSubview(cityNameLabel)
        headerImageView.addSubview(favTextBtn)
        headerImageView.addSubview(favIconBtn)
        
        tableHeaderView.addSubview(moreSightsButton)
        tableHeaderView.addSubview(collectionView)
        tableHeaderView.addSubview(hotTopBarButton)
        hotTopBarButton.addSubview(refreshTopicButton)

        moreSightsButton.backgroundColor = SceneColor.frontBlack
        hotTopBarButton.backgroundColor = SceneColor.frontBlack
        moreSightsButton.addTarget(self, action: "sightButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        refreshTopicButton.addTarget(self, action: "topicRefreshButton:", forControlEvents: UIControlEvents.TouchUpInside)

        favIconBtn.addTarget(self, action: "favoriteAction:", forControlEvents: UIControlEvents.TouchUpInside)
        favIconBtn.setImage(UIImage(named: "collect_yellow"), forState: UIControlState.Selected)
        
        tableView.tableHeaderView = tableHeaderView
        tableView.backgroundColor = UIColor.clearColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(CityTopicTableViewCell.self, forCellReuseIdentifier: CityConstant.cityTopicTableViewCellID)
        
        //内容初始位置偏移
        tableView.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
        tableView.contentInset = UIEdgeInsets(top: CityConstant.headerViewHeight, left: 0, bottom: 0, right: 0)
        
        moreSightsButton.backgroundColor = SceneColor.frontBlack
        hotTopBarButton.backgroundColor = SceneColor.frontBlack
        moreSightsButton.addTarget(self, action: "sightButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        hotTopBarButton.addTarget(self, action: "topicRefreshButton:", forControlEvents: UIControlEvents.TouchUpInside)
        refreshTopicButton.addTarget(self, action: "topicRefreshButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.registerClass(CitySightCollectionViewCell.self, forCellWithReuseIdentifier: CityConstant.citySightCollectionViewCellID)
        collectionView.userInteractionEnabled = true
        
        // 每个item的大小
        layout.itemSize = CGSizeMake(186, CityConstant.collectionViewHeight)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
    }
    
    ///  话题刷新
    func topicRefreshButton(btn: UIButton) {
        refreshSightListData()
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = -CGFloat(M_PI * 2);
        anim.removedOnCompletion = false
        anim.fillMode = kCAFillModeBackwards;
        anim.duration = 2;
        anim.repeatCount = MAXFLOAT
        refreshTopicButton.layer.addAnimation(anim, forKey: "transform.rotation")
    }
    
    /// 设置布局
    private func setupAutoLayout() {
        let cons = headerImageView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, CityConstant.headerViewHeight), offset: CGPointMake(0, 0))
        headerHeightConstraint = headerImageView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        cityNameLabel.ff_AlignInner(.BottomLeft, referView: headerImageView, size: nil, offset: CGPointMake(9, -13))
        favTextBtn.ff_AlignInner(.BottomRight, referView: headerImageView, size: CGSizeMake(24, 14), offset: CGPointMake(-9, -14))
        favIconBtn.ff_AlignVertical(.TopCenter, referView: favTextBtn, size: CGSizeMake(21, 20), offset:CGPointMake(0, -5))
        
        moreSightsButton.ff_AlignInner(.TopLeft, referView: tableHeaderView, size: CGSizeMake(view.bounds.width, CityConstant.subtitleButtonHeight), offset: CGPointMake(0, 8))
        collectionView.ff_AlignVertical(.BottomLeft, referView: moreSightsButton, size: CGSizeMake(view.bounds.width, CityConstant.collectionViewHeight), offset: CGPointMake(0, 8))
        hotTopBarButton.ff_AlignVertical(.BottomLeft, referView: collectionView, size: CGSizeMake(view.bounds.width, CityConstant.subtitleButtonHeight), offset: CGPointMake(0, 8))
        refreshTopicButton.ff_AlignInner(.CenterRight, referView: hotTopBarButton, size: CGSizeMake(15, 15), offset: CGPointMake(-9, 0))
    }
    
    //请求数据
    private func loadCityData() {
        if lastRequest == nil {
            lastRequest = CityRequest()
            lastRequest?.cityId = cityId
        }

        lastRequest?.fetchModels { [weak self]
            (handler: NSDictionary) -> Void in
            self?.cityDataSource = handler.valueForKey("city") as? City
            if let sights = handler.valueForKey("sights") as? [Sight] {
                self?.collectionDataSource = sights
            }
            if let topics = handler.valueForKey("topics") as? [TopicBrief] {
                self?.tableViewDataSource = topics
            }
            self?.pageNumber = handler.valueForKey("pageNum")?.integerValue ?? 0
        }
    }
    
    private func refreshSightListData() {
        
        refreshTopicRequest?.page++
        if refreshTopicRequest?.page > pageNumber {
            refreshTopicRequest?.page = 1
        }
        
        if refreshTopicRequest == nil {
            refreshTopicRequest = TopicRefreshRequest()
            refreshTopicRequest?.city = cityId
        }
        
        refreshTopicRequest?.fetchModels { [weak self] (handler: [TopicBrief]) -> Void in
            self?.tableViewDataSource = handler
           self!.refreshTopicButton.layer.removeAllAnimations()

        }
    }
    
    // MARK: - collectionView代理及数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CityConstant.citySightCollectionViewCellID, forIndexPath: indexPath) as! CitySightCollectionViewCell
        
        cell.size = getIndexPathItemSize(indexPath)
        cell.data = collectionDataSource[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return getIndexPathItemSize(indexPath)
    }
    
    /// 获取对应行的size大小
    private func getIndexPathItemSize(indexPath: NSIndexPath) -> CGSize {
        let width:CGFloat = collectionView.bounds.width
        let height:CGFloat = collectionView.bounds.height
        
        switch collectionDataSource.count {
        case 0: return CGSizeZero
        case 1:
            return CGSizeMake(width - 16, height)
        case 2:
            return CGSizeMake((width - 24) * 0.5, height)
        case 3:
            if indexPath.row == 0 {
                return CGSizeMake((width - 24) * 0.5, height)
            } else {
                return CGSizeMake((width - 24) * 0.5, (height - 8) * 0.5)
            }
        default:
            var size = CGSizeZero
            if indexPath.row % 3 == 0 {
                size = CGSizeMake((width - 24) * 0.5, height)
            } else if indexPath.row % 3 == 1 {
                size = CGSizeMake(113, (height - 8) * 0.5 + 8)
            } else {
                size = CGSizeMake(113, (height - 8) * 0.5 - 8)
            }
            return size
        }
    }
    
    ///  选中某一行
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = SightViewController()
        vc.sightDataSource = collectionDataSource[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - tableView代理及数据源
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CityConstant.collectionViewHeight + 2 * CityConstant.subtitleButtonHeight + 3 * 8
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return tableViewDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CityConstant.cityTopicTableViewCellID, forIndexPath: indexPath) as! CityTopicTableViewCell
        
        //cell无选中效果
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.topic = tableViewDataSource[indexPath.row]
//        tableViewScrollToIndex = indexPath
        return cell
    }
    
    ///  tabview的行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 108
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let topic = tableViewDataSource[indexPath.row]
        let vc    = TopicViewController()
        vc.topicDataSource = Topic.fromBrief(topic)
        navigationController?.pushViewController(vc, animated: true)

    }
    
    //MARK: ScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        if offsetY != 0 { //防止collectionView 左右滑动
            
            //导航变化
            let gap = CityConstant.headerViewHeight + offsetY
            if gap > 0 {
                let threshold = CityConstant.headerViewHeight - 64 - 40
                navBarAlpha = gap / threshold
                if navBarAlpha > 0.8 {
                    navBarAlpha = 1
                } else if navBarAlpha < 0.2 {
                    navBarAlpha = 0
                }
            }
            refreshBar()
            
            //headerView高度动态变化
            let navigationBarHeight: CGFloat = 64
            let height = max(-offsetY, navigationBarHeight)
            headerHeightConstraint?.constant = height
        }
    }
    
    // MARK: 景点列表页
    func sightButtonClick(btn: UIButton) {
        let vc    = CitySightsViewController()
        vc.cityDataSource = cityDataSource
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 收藏操作
    func favoriteAction(sender: UIButton) {
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
