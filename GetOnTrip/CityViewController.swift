//
//  CityCenterPageController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

/// 城市中间页
class CityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /// 顶部的背景高度
    let backgroundViewH: CGFloat = 198 + 24 + 34 + 196 + 34 + 8
    
    // MARK: - 属性
    /// collectionview及imageView底部的view
    lazy var backgroundView: UIView = UIView()
    
    /// 城市背影图片
    lazy var cityBackground: UIImageView = UIImageView()
    
    /// 城市名
    lazy var cityNameLabel: UILabel = UILabel(color: UIColor.whiteColor(), fontSize: 26, mutiLines: true)
    
    var cityName: String = "" {
        didSet {
            cityNameLabel.text = cityName
        }
    }
    
    //默认无
    var cityId: String = ""
    
    /// 收藏按钮
    lazy var favTextBtn: UIButton = UIButton(title: "收藏", fontSize: 12, radius: 0)
    
    /// 收藏按钮
    lazy var favIconBtn: UIButton = UIButton(icon: "city_star", masksToBounds: false)
    
    /// 界面布局
    let layout = UICollectionViewFlowLayout()
    
    /// 热门景点内容
    lazy var collectionView: UICollectionView =  { [unowned self] in
        let collect = UICollectionView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 246), collectionViewLayout: self.layout)
        return collect
    }()
    
    /// 热门景点
    lazy var sightView: UIView = UIView(color: SceneColor.frontBlack, alphaF: 1.0)

    /// 热点景点文字
    lazy var sightLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "热门景点", fontSize: 14)

    /// 热门景点图标
    lazy var moreSightButton: UIButton = UIButton(icon: "city_more", masksToBounds: false)
    
    /// 热门内容
    lazy var tableView: UITableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
    
    /// 热门话题标题
    lazy var topicTopView: UIView = UIView(color: SceneColor.frontBlack, alphaF: 1.0)
    
    /// 热点话题文字
    lazy var topicTopLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "热门内容", fontSize: 14)
    
    /// 热门话题图标
    lazy var refreshTopicButton: UIButton = UIButton(icon: "city_refresh", masksToBounds: false)
    
    /// 网络请求加载数据(添加)
    var lastRequest: CityRequest?
    
    /// 数据源
    var dataSource: NSDictionary?
    
    // MARK: - 初始化相关内容
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nav bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = SceneColor.frontBlack.colorWithAlphaComponent(0)
        
        initView()
        setupAutoLayout()
        loadCityData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    /// 添加控件
    private func initView() {
        view.backgroundColor = SceneColor.bgBlack
        view.addSubview(tableView)
        view.addSubview(backgroundView)
        
        backgroundView.addSubview(cityBackground)
        backgroundView.addSubview(cityNameLabel)
        backgroundView.addSubview(favTextBtn)
        backgroundView.addSubview(favIconBtn)
        backgroundView.addSubview(collectionView)
        backgroundView.addSubview(sightView)
        sightView.addSubview(moreSightButton)
        sightView.addSubview(sightLabel)
        backgroundView.addSubview(topicTopView)
        topicTopView.addSubview(refreshTopicButton)
        topicTopView.addSubview(topicTopLabel)
        
        backgroundView.userInteractionEnabled = true
        cityBackground.userInteractionEnabled = true
        collectionView.userInteractionEnabled = true
        
        tableView.backgroundColor = UIColor.clearColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(CityHotTopicTableViewCell.self, forCellReuseIdentifier: StoryBoardIdentifier.CityHotTopicTableViewCellID)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.registerClass(CitySightCollectionViewCell.self, forCellWithReuseIdentifier: StoryBoardIdentifier.CitySightCollectionViewCellID)
        
        refreshTopicButton.addTarget(self, action: "topicRefreshButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // 每个item的大小
        layout.itemSize = CGSizeMake(186, 196)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
    }
    
    ///  话题刷新
    func topicRefreshButton(btn: UIButton) {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = -CGFloat(M_PI * 2);
        anim.removedOnCompletion = false
        anim.fillMode = kCAFillModeBackwards;
        anim.duration = 2;
        anim.repeatCount = 10
        btn.layer.addAnimation(anim, forKey: "transform.rotation")
    }
    
    /// 设置布局
    private func setupAutoLayout() {
        backgroundView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, backgroundViewH), offset: CGPointMake(0, 0))
        cityBackground.ff_AlignInner(ff_AlignType.TopLeft, referView: backgroundView, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 198), offset: CGPointMake(0, 0))
        cityNameLabel.ff_AlignInner(ff_AlignType.BottomLeft, referView: cityBackground, size: nil, offset: CGPointMake(9, -13))
        favTextBtn.ff_AlignInner(ff_AlignType.BottomRight, referView: cityBackground, size: CGSizeMake(24, 14), offset: CGPointMake(-9, -14))
        favIconBtn.ff_AlignVertical(ff_AlignType.TopCenter, referView: favTextBtn, size: CGSizeMake(21, 20), offset:CGPointMake(0, -5))
        
        sightView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: cityBackground, size: CGSizeMake(view.bounds.width, 34), offset: CGPointMake(0, 8))
        sightLabel.ff_AlignInner(ff_AlignType.CenterCenter, referView: sightView, size: nil, offset: CGPointMake(0, 0))
        moreSightButton.ff_AlignInner(ff_AlignType.CenterRight, referView: sightView, size: CGSizeMake(8, 15), offset: CGPointMake(-10, 0))
        
        collectionView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: sightView, size: CGSizeMake(view.bounds.width, 196 + 16), offset: CGPointMake(0, 8))
        topicTopView.ff_AlignInner(ff_AlignType.BottomLeft, referView: backgroundView, size: CGSizeMake(view.bounds.width, 34), offset: CGPointMake(0, 8))
        topicTopLabel.ff_AlignInner(ff_AlignType.CenterCenter, referView: topicTopView, size: nil, offset: CGPointMake(0, 0))
        refreshTopicButton.ff_AlignInner(ff_AlignType.CenterRight, referView: topicTopView, size: CGSizeMake(15, 15), offset: CGPointMake(-9, 0))
        tableView.contentInset = UIEdgeInsets(top: (backgroundViewH - 64), left: 0, bottom: 0, right: 0)
    }
    
    //请求数据
    private func loadCityData() {
        
        if lastRequest == nil {
            lastRequest = CityRequest()
            lastRequest?.city = cityId
        }
        
        lastRequest?.fetchFeedBackModels {[unowned self] (handler: NSDictionary) -> Void in
            if let city = handler.valueForKey("city") as? City {
                self.cityBackground.sd_setImageWithURL(NSURL(string: city.image))
                self.cityNameLabel.text = city.name
            }
            
            self.dataSource = handler
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - collectionView代理及数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataSource?.valueForKey("sights")!.count ?? 0)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StoryBoardIdentifier.CitySightCollectionViewCellID, forIndexPath: indexPath) as! CitySightCollectionViewCell
        let data = dataSource?.valueForKey("sights") as! NSArray
        cell.data = data[indexPath.row] as? Sight

        layout.prepareLayout()

        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if (dataSource?.valueForKey("sights")?.count == 0) { return CGSizeZero }
        
        switch dataSource!.valueForKey("sights")!.count {
        case 1:
            return CGSizeMake(collectionView.bounds.width - 16, collectionView.bounds.height)
        case 2:
            return CGSizeMake(collectionView.bounds.width * 0.5 - 8, collectionView.bounds.height)
        case 3:
            if indexPath.row == 0 {
                return CGSizeMake(collectionView.bounds.width * 0.5 - 16, collectionView.bounds.height)
            } else {
                return CGSizeMake(collectionView.bounds.width * 0.5 - 16, collectionView.bounds.height * 0.5 - 6)
            }
        default:
            if indexPath.row % 3 == 0 {
                return CGSizeMake(collectionView.bounds.width * 0.5, collectionView.bounds.height)
            } else {
                return CGSizeMake(113, 100)
            }
        }
    }
    
    ///  选中某一行
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = SightListController()
        let sightId = dataSource?.valueForKey("sights")?[indexPath.row] as! Sight
        vc.sightId = sightId.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - tableView代理及数据源
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource?.valueForKey("topics")!.count ?? 0)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.CityHotTopicTableViewCellID, forIndexPath: indexPath) as! CityHotTopicTableViewCell
        let homeTopic = dataSource?.valueForKey("topics") as? NSArray
        cell.data = homeTopic![indexPath.row] as? CityHotTopic
        
        return cell
    }
    
    ///  tabview的行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 108 //indexPath.row == 0 ? CGRectGetMaxY(collectionView.frame) + 8 : 108
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let hotTopic = dataSource?.valueForKey("topics") as? NSArray
        let data = hotTopic![indexPath.row] as? CityHotTopic
        
        let vc = TopicDetailController()
        vc.topicId = data!.id!

        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: ScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //使整体上面的view可以上下滚动，而且左右滚动使之不影响
        if scrollView.contentOffset.x == 0 && scrollView.contentOffset.y != 0 {
            backgroundView.frame.origin.y = abs(scrollView.contentOffset.y) - backgroundViewH
        }
        
        //导航变化
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0 {
            let alpha:CGFloat = 1 - ((64 - offsetY) / 64);
            navigationController?.navigationBar.backgroundColor = SceneColor.frontBlack.colorWithAlphaComponent(alpha)
        } else {
            navigationController?.navigationBar.backgroundColor = SceneColor.frontBlack.colorWithAlphaComponent(0)
        }
    }
    
}