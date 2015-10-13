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
    lazy var cityName: UILabel = UILabel(color: UIColor.whiteColor(), fontSize: 26, mutiLines: true)
    
    //默认北京
    var cityID: String = "2"
    
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
    lazy var sightView: UIView = UIView(color: SceneColor.sightGrey, alphaF: 1.0)

    /// 热点景点文字
    lazy var sightLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "热门景点", fontSize: 14)

    /// 热门景点图标
    lazy var moreSightButton: UIButton = UIButton(icon: "city_more", masksToBounds: false)
    
    /// 热门内容
    lazy var tableView: UITableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
    
    /// 热门话题标题
    lazy var topicTopView: UIView = UIView(color: SceneColor.sightGrey, alphaF: 1.0)
    
    /// 热点话题文字
    lazy var topicTopLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "热门内容", fontSize: 14)
    
    /// 热门话题图标
    lazy var refreshTopicButton: UIButton = UIButton(icon: "city_refresh", masksToBounds: false)
    
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: HomeCityCenterRequest?
    
    /// 数据源
    var dataSource: NSDictionary?
    
    // MARK: - 初始化相关内容
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupAutoLayout()
        loadCityData()
    }
    
    /// 添加控件
    private func initView() {
        view.addSubview(tableView)
        view.addSubview(backgroundView)
        backgroundView.addSubview(cityBackground)
        backgroundView.addSubview(cityName)
        backgroundView.addSubview(favTextBtn)
        backgroundView.addSubview(favIconBtn)
        backgroundView.addSubview(collectionView)
        backgroundView.addSubview(sightView)
        sightView.addSubview(moreSightButton)
        sightView.addSubview(sightLabel)
        backgroundView.addSubview(topicTopView)
        topicTopView.addSubview(refreshTopicButton)
        topicTopView.addSubview(topicTopLabel)
        
        view.backgroundColor = SceneColor.homeGrey
        tableView.backgroundColor = UIColor.clearColor()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        backgroundView.userInteractionEnabled = true
        cityBackground.userInteractionEnabled = true
        collectionView.userInteractionEnabled = true
        
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(HomeCityCententTopicCell.self, forCellReuseIdentifier: "HomeCityCententTopic_Cell")
        collectionView.registerClass(HomeSightCollectionViewCell.self, forCellWithReuseIdentifier: "HomeSightCollectionView_Cell")
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
        cityName.ff_AlignInner(ff_AlignType.BottomLeft, referView: cityBackground, size: nil, offset: CGPointMake(9, -13))
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
    
    /// 发送反馈消息
    private func loadCityData() {
        
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = HomeCityCenterRequest()
            lastSuccessAddRequest?.city = cityID
        }
        
        lastSuccessAddRequest?.fetchFeedBackModels {[unowned self] (handler: NSDictionary) -> Void in
            self.loadProperty(handler.valueForKey("city") as! HomeCity)
            
            self.dataSource = handler
            
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }
    

    private func loadProperty(cityData: HomeCity) {
        cityBackground.sd_setImageWithURL(NSURL(string: cityData.image!))
        cityName.text = cityData.name
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    // MARK: - collectionView代理及数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataSource?.valueForKey("sights")!.count ?? 0)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeSightCollectionView_Cell", forIndexPath: indexPath) as! HomeSightCollectionViewCell
        let data = dataSource?.valueForKey("sights") as! NSArray
        cell.data = data[indexPath.row] as? HomeSight

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
        print("先中了这个景点")
        let vc = SightListController()
        let sightId = dataSource?.valueForKey("sights")?[indexPath.row] as! HomeSight
        vc.sightId = sightId.id
        addChildViewController(vc)
        view.addSubview(vc.view)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - tableView代理及数据源
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource?.valueForKey("topics")!.count ?? 0)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCityCententTopic_Cell", forIndexPath: indexPath) as! HomeCityCententTopicCell
        let homeTopic = dataSource?.valueForKey("topics") as? NSArray
        cell.data = homeTopic![indexPath.row] as? HomeTopic
        
        return cell
    }
    
    ///  tabview的行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 108 //indexPath.row == 0 ? CGRectGetMaxY(collectionView.frame) + 8 : 108
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let homeTopic = dataSource?.valueForKey("topics") as? NSArray
        let data = homeTopic![indexPath.row] as? HomeTopic
        
        let vc = TopicDetailController()
        vc.topicId = data!.id
//        http://123.57.46.229:8301/api/home?city=北京&deviceId=583C5CED-BDC2-4B7A-896F-64C2CAB8DBD2
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///  使整体上面的view可以上下滚动，而且左右滚动使之不影响
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 && scrollView.contentOffset.y != 0 {
            backgroundView.frame.origin.y = abs(scrollView.contentOffset.y) - backgroundViewH
        }
    }
}

// MARK: - 首页景点cell
/// 首页景点cell
class HomeSightCollectionViewCell: UICollectionViewCell {
    /// 图片
    var icon: UIImageView = UIImageView()
    /// 标题
    var title: UILabel = UILabel(color: UIColor.yellowColor(), title: "天坛", fontSize: 22, mutiLines: false)
    /// 内容及收藏
    var desc: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 09), title: "10个内容 | 480人收藏", fontSize: 10, mutiLines: false)
    
    var data: HomeSight? {
        didSet {
            icon.sd_setImageWithURL(NSURL(string: data!.image!))
            title.text = data?.name
            desc.text  = data?.desc
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(title)
        addSubview(desc)
        
        icon.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: self.bounds.size, offset: CGPointMake(0, 0))
        title.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
        desc.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: nil, offset: CGPointMake(0, -5))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

