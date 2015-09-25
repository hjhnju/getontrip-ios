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
//    lazy var sightBottomView: UIView = UIView(color: SceneColor.sightGrey, alphaF: 1.0)
//
//    /// 热点景点文字
//    lazy var sightLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "热门景点", fontSize: 14)
//
//    /// 热门景点图标
//    lazy var sightIcon: UIButton = UIButton(icon: "", masksToBounds: false)
    
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
    }
    
    /// 添加控件
    private func setupAddProperty() {
        
        view.addSubview(tableView)
        view.addSubview(cityBackground)
        cityBackground.backgroundColor = UIColor.orangeColor()
        cityBackground.image = UIImage(named: "2.jpg")
        view.addSubview(pilotingIcon)
        view.addSubview(cityName)
        view.addSubview(collectBtn)
        view.addSubview(collectionView)
        view.backgroundColor = SceneColor.homeGrey
        tableView.backgroundColor = UIColor.clearColor()
        
        collectBtn.layer.borderWidth = 1.0
        collectBtn.layer.borderColor = UIColor.whiteColor().CGColor
        cityName.text = "灵极海"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: view.bounds.size, offset: CGPointMake(0, -64))
    }
    
    /// 设置布局
    private func setupAutoLayout() {
        
//        tableView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: UIScreen.mainScreen().bounds.size, offset: CGPointMake(0, 0))
        cityBackground.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 198), offset: CGPointMake(0, 0))
        pilotingIcon.ff_AlignInner(ff_AlignType.BottomLeft, referView: cityBackground, size: CGSizeMake(13, 17), offset: CGPointMake(9, -13))
        cityName.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: pilotingIcon, size: nil, offset: CGPointMake(8, 0))
        collectBtn.ff_AlignInner(ff_AlignType.BottomRight, referView: cityBackground, size: CGSizeMake(57, 29), offset: CGPointMake(-9, -10))
        collectionView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: cityBackground, size: CGSizeMake(view.bounds.width, 246), offset: CGPointMake(0, 8))
//        tableView.ff_Fill(view)
    }
    
    /// 发送反馈消息
    private func sendFeedBackMessage() {
        
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = HomeCityCenterRequest()
            lastSuccessAddRequest?.city = "北京"
        }
        
        lastSuccessAddRequest?.fetchFeedBackModels {[unowned self] (handler: NSDictionary) -> Void in
            self.dataSource = handler
            self.tableView.reloadData()
        }
    }
    
    // MARK: - collectionView代理及数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource!["sights"]?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeSightCollectionView_Cell", forIndexPath: indexPath) as! HomeSightCollectionViewCell
        let data = dataSource?.valueForKey("sights") as! NSArray
        cell.data = data[indexPath.row] as? HomeSight
        return cell
    }
    
    
    // MARK: - tableView代理及数据源
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((dataSource?.valueForKey("topics")!.count ?? 0)! + 1)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = UITableViewCell()
//            cell.data = dataSource
            return cell
        } else {
            let cell = HomeCityCententTopicCell()
            cell.data = dataSource?.valueForKey("topics") as? [HomeTopic]
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        
//        collectionView.frame.origin.y -= abs(scrollView.contentOffset.y)
    }
}

class HomeCityCenterTableViewCell: UITableViewCell {
    
    
    var data: NSDictionary? {
        didSet {
            
//            collectionView.reloadData()
        }
    }

}

// MARK: - 首页景点cell
/// 首页景点cell
class HomeSightCollectionViewCell: UICollectionViewCell {
    
    var icon: UIImageView = UIImageView()
    
    var title: UILabel = UILabel(color: UIColor.yellowColor(), title: "天坛", fontSize: 22, mutiLines: false)
    
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
    
    var data: [HomeTopic]? {
        didSet {
            
        }
    }
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    
}
