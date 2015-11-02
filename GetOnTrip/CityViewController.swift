//
//  CityCenterPageController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

struct CityConstant {
    static let headerViewHeight:CGFloat = 198
    static let collectionViewHeight:CGFloat = 196
    static let subtitleButtonHeight:CGFloat = 34
}

/// 城市中间页
class CityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: Properties and Outlets
    
    var cityName: String = "" {
        didSet {
            cityNameLabel.text = cityName
            titleLabel.text = cityName
        }
    }
    
    /// 默认无
    var cityId: String = ""
    
    /// 导航标题
    var titleLabel = UILabel()
    
    /// 顶部图片url
    var headerImageUrl:String = "" {
        didSet {
            headerImageView.sd_setImageWithURL(NSURL(string: headerImageUrl), placeholderImage:PlaceholderImage.defaultLarge)
        }
    }
    
    /// 城市背影图片
    var headerImageView: UIImageView = UIImageView()
    
    //头部视图高度约束
    var headerHeightConstraint: NSLayoutConstraint?
    
    /// collectionview及imageView底部的view
    lazy var tableHeaderView: UIView = UIView()
    
    /// 热门景点＋热门内容
    lazy var tableView: UITableView = UITableView()
    
    /// 城市名
    lazy var cityNameLabel: UILabel = UILabel(color: UIColor.whiteColor(), fontSize: 26, mutiLines: true)
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
    lazy var moreSightsButton: homeSightButton = homeSightButton(image: "city_more", title: "热门景点", fontSize: 14, titleColor: .whiteColor())
    
    /// 热门话题标题
    lazy var hotTopBarButton: UIButton = UIButton(title: "热门内容", fontSize: 14, radius: 0, titleColor: .whiteColor())

    /// 热门话题图标
    lazy var refreshTopicButton: UIButton = UIButton(icon: "city_refresh", masksToBounds: false)
    
    /// 网络请求加载数据(添加)
    var lastRequest: CityRequest?
    
    /// 刷新话题请求
    var refreshTopicRequest: TopicRefreshRequest?
    
    var pageNumber: Int = 1
    
    /// 数据源
    var tableViewDataSource: [BriefTopic]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var collectionDataSource: [Sight]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //导航透明度
    var navBarAlpha:CGFloat = 0.0
    
    //原导航底图
    var oldBgImage: UIImage?
    
    // MARK: - 初始化相关内容
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //原则：如果和默认设置不同，controller自己定义新值，退出时自己还原
        oldBgImage = navigationController?.navigationBar.backgroundImageForBarMetrics(UIBarMetrics.Default)
            
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButtonClicked:")
        
        titleLabel.frame = CGRectMake(0, 0, 100, 21)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.hidden = true //设置alpha=0会有Fade Out
        
        headerImageView.userInteractionEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.contentSize = CGSizeMake(200, 100)
        initView()
        setupAutoLayout()
        loadCityData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //在viewDidDisappear中无法生效
        navigationController?.navigationBar.setBackgroundImage(oldBgImage, forBarMetrics: UIBarMetrics.Default)
        navigationItem.titleView = nil
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func refreshBar(){
        //设置导航样式
        titleLabel.alpha = navBarAlpha
        if navBarAlpha > 0.2 {
            titleLabel.hidden = false //设置alpha=0会有Fade Out
        } else {
            titleLabel.hidden = true
        }
        navigationItem.titleView = titleLabel
        
        let bgImage = UIKitTools.imageWithColor(SceneColor.frontBlack.colorWithAlphaComponent(navBarAlpha))
        navigationController?.navigationBar.setBackgroundImage(bgImage, forBarMetrics: UIBarMetrics.Default)
        
        //headerImage标题
        cityNameLabel.alpha = 1 - navBarAlpha
        favIconBtn.alpha = 1 - navBarAlpha
        favTextBtn.alpha = 1 - navBarAlpha
    }
    
    /// 添加控件
    private func initView() {
        view.backgroundColor = SceneColor.bgBlack
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(headerImageView)
        view.addSubview(tableView)
        view.bringSubviewToFront(headerImageView)
        
        titleLabel.textColor = UIColor.whiteColor()
        
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
//        moreSightsButton.addTarget(self, action: "topicRefreshButton:", forControlEvents: UIControlEvents.TouchUpInside)
        refreshTopicButton.addTarget(self, action: "topicRefreshButton:", forControlEvents: UIControlEvents.TouchUpInside)

        favIconBtn.addTarget(self, action: "favIconBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        favIconBtn.setImage(UIImage(named: "collect_yellow"), forState: UIControlState.Selected)
        
        tableView.tableHeaderView = tableHeaderView
        tableView.backgroundColor = UIColor.clearColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(CityHotTopicTableViewCell.self, forCellReuseIdentifier: StoryBoardIdentifier.CityHotTopicTableViewCellID)
        
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
        collectionView.registerClass(CitySightCollectionViewCell.self, forCellWithReuseIdentifier: StoryBoardIdentifier.CitySightCollectionViewCellID)
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
        let cons = headerImageView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, CityConstant.headerViewHeight), offset: CGPointMake(0, 0))
        headerHeightConstraint = headerImageView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        cityNameLabel.ff_AlignInner(ff_AlignType.BottomLeft, referView: headerImageView, size: nil, offset: CGPointMake(9, -13))
        favTextBtn.ff_AlignInner(ff_AlignType.BottomRight, referView: headerImageView, size: CGSizeMake(24, 14), offset: CGPointMake(-9, -14))
        favIconBtn.ff_AlignVertical(ff_AlignType.TopCenter, referView: favTextBtn, size: CGSizeMake(21, 20), offset:CGPointMake(0, -5))
        
        moreSightsButton.ff_AlignInner(.TopLeft, referView: tableHeaderView, size: CGSizeMake(view.bounds.width, CityConstant.subtitleButtonHeight), offset: CGPointMake(0, 8))
        collectionView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: moreSightsButton, size: CGSizeMake(view.bounds.width, CityConstant.collectionViewHeight), offset: CGPointMake(0, 8))
        hotTopBarButton.ff_AlignVertical(ff_AlignType.BottomLeft, referView: collectionView, size: CGSizeMake(view.bounds.width, CityConstant.subtitleButtonHeight), offset: CGPointMake(0, 8))
        refreshTopicButton.ff_AlignInner(ff_AlignType.CenterRight, referView: hotTopBarButton, size: CGSizeMake(15, 15), offset: CGPointMake(-9, 0))
    }
    
    //请求数据
    private func loadCityData() {
        if lastRequest == nil {
            lastRequest = CityRequest()
            lastRequest?.city = cityId
        }

        lastRequest?.fetchModels { [weak self]
            (handler: NSDictionary) -> Void in

            if let city = handler.valueForKey("city") as? City {
                self?.headerImageUrl = city.image
                self?.cityName = city.name
                self?.favIconBtn.selected = city.collected == "" ? false : true
            }
            self?.collectionDataSource = handler.valueForKey("sights") as? [Sight]
            self?.tableViewDataSource = handler.valueForKey("topics") as? [BriefTopic]
            self?.pageNumber = handler.valueForKey("pageNum")!.integerValue
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
        
        refreshTopicRequest?.fetchModels { [weak self] (handler: [BriefTopic]) -> Void in
            self?.tableViewDataSource = handler
           self!.refreshTopicButton.layer.removeAllAnimations()

        }
    }
    
    // MARK: - collectionView代理及数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionDataSource == nil { return 0 }
        return collectionDataSource!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StoryBoardIdentifier.CitySightCollectionViewCellID, forIndexPath: indexPath) as! CitySightCollectionViewCell
        cell.icon.image = nil
        cell.data = collectionDataSource![indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let dataSource = collectionDataSource {
            let width:CGFloat = collectionView.bounds.width
            let height:CGFloat = collectionView.bounds.height
            
            switch dataSource.count {
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
        return CGSizeZero
    }
    
    ///  选中某一行
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let vc       = SightViewController()
        let sight    = collectionDataSource![indexPath.row]
        vc.sightId   = sight.id
        vc.sightName = sight.name
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
        if tableViewDataSource == nil { return 0 }
        return tableViewDataSource!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.CityHotTopicTableViewCellID, forIndexPath: indexPath) as! CityHotTopicTableViewCell
        
        //cell无选中效果
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.topic = tableViewDataSource![indexPath.row]
        
        return cell
    }
    
    ///  tabview的行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 108 //indexPath.row == 0 ? CGRectGetMaxY(collectionView.frame) + 8 : 108
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let topic = tableViewDataSource![indexPath.row]
        let vc    = TopicViewController()
        vc.topicId    = topic.id
        vc.topicTitle = topic.title
        vc.sightName  = topic.sight
        vc.headerImageUrl = topic.image
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
        vc.title  = cityName
        vc.cityId = cityId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func favIconBtnClick(sender: UIButton) {
        if sharedUserAccount == nil {
            LoginView.sharedLoginView.addLoginFloating({ (result, error) -> () in
                let resultB = result as! Bool
                if resultB == true {
                    
                    CollectAddAndCancel.sharedCollectAddCancel.fetchCollectionModels(3, objid: self.cityId, isAdd: !sender.selected, handler: { (result, status) -> Void in
                        if status == RetCode.SUCCESS {
                            if result == "1" {
                                sender.selected = !sender.selected
                                SVProgressHUD.showInfoWithStatus(sender.selected ? "已收藏" : "已取消")
                            } else {
                                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                            }
                        }
                    })
                }
            })
        } else {
            
            CollectAddAndCancel.sharedCollectAddCancel.fetchCollectionModels(3, objid: self.cityId, isAdd: !sender.selected, handler: { (result, status) -> Void in
                if status == RetCode.SUCCESS {
                    if result == "1" {
                        sender.selected = !sender.selected
                        SVProgressHUD.showInfoWithStatus(sender.selected ? "已收藏" : "已取消")
                    } else {
                        SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                    }
                }
            })
        }
        
    }
    
    ///  搜索跳入之后消失控制器
    func dismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 搜索(下一个控制器)
    func searchButtonClicked(button: UIBarButtonItem) {
        
        let svc = SearchViewController()
        svc.searchResult.rootNav = self.navigationController
        presentViewController(SearchViewController(), animated: true, completion: nil)
    }
}
