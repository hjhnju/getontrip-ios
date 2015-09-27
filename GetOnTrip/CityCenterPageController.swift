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
class CityCenterPageController: BaseHomeController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - 属性
    /// 城市背影图片
    lazy var cityBackground: UIImageView = UIImageView()
    
    /// 地标图标
    lazy var pilotingIcon: UIImageView = UIImageView(image: UIImage(named: "current_location"))
    
    /// 城市名
    lazy var cityName: UILabel = UILabel(color: UIColor.whiteColor(), fontSize: 26, mutiLines: true)
    
    /// 收藏按钮
    lazy var collectBtn: UIButton = UIButton(title: "+ 收藏", fontSize: 14, radius: 10)
    
    /// 界面布局
    let layout = UICollectionViewFlowLayout()
    
    /// 热门景点内容
    lazy var collectionView: UICollectionView =  { [unowned self] in
        let collect = UICollectionView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 246), collectionViewLayout: self.layout)
        return collect
    }()
    
    /// 热门景点
    lazy var sightBottomView: UIView = UIView(color: SceneColor.sightGrey, alphaF: 1.0)

    /// 热点景点文字
    lazy var sightLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "热门景点", fontSize: 14)

    /// 热门景点图标
    lazy var sightIcon: UIButton = UIButton(icon: "", masksToBounds: false)
    
    /// 热门内容
    lazy var tableView: UITableView = UITableView()
    
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: HomeCityCenterRequest?
    /// 数据源
    var dataSource: NSDictionary?
    
    // MARK: - 初始化相关内容
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddProperty()
        setupAutoLayout()
        loadHomeData()
//        cityBackground.hidden = true
//        collectionView.hidden = true
    }
    
    /// 添加控件
    private func setupAddProperty() {
        
        view.addSubview(tableView)
        view.addSubview(cityBackground)
        view.addSubview(cityName)
        view.addSubview(collectBtn)
        view.addSubview(pilotingIcon)
        view.addSubview(collectionView)
        sightBottomView.addSubview(sightIcon)
        sightBottomView.addSubview(sightLabel)
        
        cityName.text = "极梦"
        collectBtn.layer.borderWidth = 1.0
        view.backgroundColor = SceneColor.homeGrey
        cityBackground.image = UIImage(named: "2.jpg")
        tableView.backgroundColor = UIColor.clearColor()
        cityBackground.backgroundColor = UIColor.orangeColor()
        collectBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerClass(HomeCityCententTopicCell.self, forCellReuseIdentifier: "HomeCityCententTopic_Cell")
    }
    
    /// 设置布局
    private func setupAutoLayout() {
        
//        tableView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: view.bounds.size, offset: CGPointMake(0, 40))
        tableView.frame = view.bounds
        cityBackground.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 198), offset: CGPointMake(0, 0))
        pilotingIcon.ff_AlignInner(ff_AlignType.BottomLeft, referView: cityBackground, size: CGSizeMake(13, 17), offset: CGPointMake(9, -13))
        cityName.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: pilotingIcon, size: nil, offset: CGPointMake(8, 0))
        collectBtn.ff_AlignInner(ff_AlignType.BottomRight, referView: cityBackground, size: CGSizeMake(57, 29), offset: CGPointMake(-9, -10))
        collectionView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: cityBackground, size: CGSizeMake(view.bounds.width, 246), offset: CGPointMake(0, 8))
        sightLabel.ff_AlignInner(ff_AlignType.CenterCenter, referView: sightBottomView, size: nil, offset: CGPointMake(0, 0))
        sightIcon.ff_AlignInner(ff_AlignType.CenterRight, referView: sightBottomView, size: CGSizeMake(8, 15), offset: CGPointMake(10, 0))
    }
    
    /// 发送反馈消息
    private func loadHomeData() {
        
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = HomeCityCenterRequest()
            lastSuccessAddRequest?.city = "北京"
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
    
    // MARK: - collectionView代理及数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataSource!["sights"]?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeSightCollectionView_Cell", forIndexPath: indexPath) as! HomeSightCollectionViewCell
        let data = dataSource?.valueForKey("sights") as! NSArray
        cell.data = data[indexPath.row] as? HomeSight
        return cell
    }
    
    ///  选中某一行
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    // MARK: - tableView代理及数据源
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource?.valueForKey("topics")!.count ?? 0)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        ///  第一行空的
//        if indexPath.row == 0 { return UITableViewCell() } else {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("HomeCityCententTopic_Cell", forIndexPath: indexPath) as! HomeCityCententTopicCell
            let homeTopic = dataSource?.valueForKey("topics") as? NSArray
            cell.data = homeTopic![indexPath.row] as? HomeTopic
            return cell
//        }
    }
    
    ///  热门景点的view
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sightBottomView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? CGRectGetMaxY(collectionView.frame) + 8 : 108
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
        
//        collectionView.frame.origin.y -= abs(scrollView.contentOffset.y)
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
        
        icon.ff_Fill(self)
        title.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
        desc.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: nil, offset: CGPointMake(0, 5))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 话题cell
/// 首页话题Cell
class HomeCityCententTopicCell: UITableViewCell {
    
    /// 图片
    var iconView: UIImageView = UIImageView()
    /// 标题
    var title: UILabel = UILabel(color: UIColor.whiteColor(), title: "北京什么时候叫做燕京的？又是什么时候改回来的？", fontSize: 15, mutiLines: true)
    /// 副标题
    var subTitle: UILabel = UILabel(color: SceneColor.whiteGrey, title: "明末崇祯年间当时首都叫什么叫燕京还是北京", fontSize: 11, mutiLines: false)
    /// 标签
    var label: UILabel = UILabel(color: SceneColor.whiteGrey, title: "故宫历史", fontSize: 9, mutiLines: false)
    /// 浏览数
    var visit: UIButton = UIButton(title: "  100", fontSize: 9, radius: 0, titleColor: SceneColor.whiteGrey)
    /// 底线
    var baseView: UIView = UIView(color: UIColor.whiteColor(), alphaF: 0.3)
    
    var data: HomeTopic? {
        didSet {

            iconView.sd_setImageWithURL(NSURL(string: data!.image!))
            title.text = data!.title
            subTitle.text = data!.subtitle
            label.text = data!.tag
            visit.setTitle("   " + data!.visit!, forState: UIControlState.Normal)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(title)
        addSubview(label)
        addSubview(visit)
        addSubview(baseView)
        addSubview(iconView)
        addSubview(subTitle)
        
        backgroundColor = UIColor.clearColor()
        label.alpha = 0.5
        visit.setImage(UIImage(named: "visit_white"), forState: UIControlState.Normal)
        
        iconView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(124, 84), offset: CGPointMake(9, 0))
        subTitle.ff_AlignHorizontal(ff_AlignType.TopRight, referView: iconView, size: CGSizeMake(bounds.width - 124 - 18, 0), offset: CGPointMake(6, 0))
        title.ff_AlignVertical(ff_AlignType.BottomLeft, referView: subTitle, size: CGSizeMake(bounds.width - 124 - 12, 0), offset: CGPointMake(0, 5))
        label.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPointMake(0, 0))
        visit.ff_AlignInner(ff_AlignType.BottomRight, referView: self, size: CGSizeMake(33, 11), offset: CGPointMake(-9, -10))
        baseView.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 19, 0.5), offset: CGPointMake(0, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
