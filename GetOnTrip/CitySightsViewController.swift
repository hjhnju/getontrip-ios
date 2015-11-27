//
//  SightListCityController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import MJRefresh

let sightListCityIdentifier = "SightListCity_Cell"

class CitySightsViewController: UICollectionViewController {
    
    /// 自定义导航
    var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: UIColor.whiteColor(), titleSize: 18)
    
    /// 城市ID
    var cityId: String {
        return cityDataSource?.id ?? ""
    }
    
    /// 城市数据
    var cityDataSource: City?
    
    /// 网络请求加载数据
    var lastRequest: CitySightsRequest?
    
    /// 界面布局
    let layout = UICollectionViewFlowLayout()
        
    var sightCityList = [CitySightBrief]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initRefresh()
    }
    
    private func initView() {
        view.backgroundColor = SceneColor.frontBlack
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        collectionView?.frame = CGRectMake(0, 44, view.bounds.width, view.bounds.height - 44)
        
        if let title = cityDataSource?.name {
            navBar.setTitle(title)
        }
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")
        navBar.setRightBarButton(UIImage(named: "search"), title: nil, target: self, action: "searchAction:")
        navBar.setBlurViewEffect(false)
        navBar.setButtonTintColor(UIColor.yellowColor())
        navBar.backgroundColor = SceneColor.frontBlack
        
        
        let w: CGFloat = (UIScreen.mainScreen().bounds.width - 18 * 3) * 0.5
        let h: CGFloat = w
        
        layout.itemSize = CGSizeMake(w, h)
        layout.minimumLineSpacing = 15
        let lw: CGFloat = 18
        layout.minimumInteritemSpacing = lw
        layout.sectionInset = UIEdgeInsets(top: lw, left: lw, bottom: 0, right: lw)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        collectionView?.userInteractionEnabled = true
        
        collectionView?.backgroundColor = SceneColor.bgBlack
        collectionView?.registerClass(CityAllSightCollectionViewCell.self, forCellWithReuseIdentifier: sightListCityIdentifier)
        collectionView?.alwaysBounceVertical = true
    }
    
    private func initRefresh() {
        //上拉刷新
        let tbHeaderView = MJRefreshNormalHeader(refreshingBlock: loadData)
        tbHeaderView.automaticallyChangeAlpha = true
        tbHeaderView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        tbHeaderView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbHeaderView.lastUpdatedTimeLabel?.font = UIFont.systemFontOfSize(11)
        tbHeaderView.stateLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.hidden = true
        tbHeaderView.stateLabel?.hidden = true
        tbHeaderView.arrowView?.image = UIImage()
        
        //上拉刷新
        let tbFooterView = MJRefreshAutoNormalFooter(refreshingBlock: loadMore)
        tbFooterView.automaticallyRefresh = true
        tbFooterView.automaticallyChangeAlpha = true
        tbFooterView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        tbFooterView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbFooterView.stateLabel?.textColor = SceneColor.lightGray
        
        
        collectionView?.mj_header = tbHeaderView
        collectionView?.mj_footer = tbFooterView
        
        if !collectionView!.mj_header.isRefreshing() {
            collectionView!.mj_header.beginRefreshing()
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sightCityList.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(sightListCityIdentifier, forIndexPath: indexPath) as! CityAllSightCollectionViewCell
        cell.collectBtn.addTarget(self, action: "favoriteAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.collectBtn.tag = indexPath.row
        cell.sightBrief = sightCityList[indexPath.row] as CitySightBrief
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = SightViewController()
        let brief = sightCityList[indexPath.row] as CitySightBrief
        let sight = Sight(id: brief.id)
        sight.name = brief.name
        vc.sightDataSource = sight
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 收藏操作
    func favoriteAction(sender: UIButton) {
        sender.selected = !sender.selected
        let sight = sightCityList[sender.tag] as CitySightBrief
        let type  = FavoriteContant.TypeSight
        let objid = sight.id
        Favorite.doFavorite(type, objid: objid, isFavorite: sender.selected) {
            (result, status) -> Void in
            if status == RetCode.SUCCESS {
                if result == nil {
                    sender.selected = !sender.selected
                } else {
                    ProgressHUD.showSuccessHUD(self.view, text: sender.selected ? "已收藏" : "已取消")
                }
            } else {
                ProgressHUD.showErrorHUD(self.view, text: "操作未成功，请稍后再试")
                sender.selected = !sender.selected
            }
        }
    }
    
    var isLoading:Bool = false

    private func loadData() {
        if self.isLoading {
            return
        }
        
        if lastRequest == nil {
            lastRequest = CitySightsRequest()
            lastRequest?.cityId = cityId
        }
        
        self.isLoading = true
        
        //清空footer的“加载完成”
        collectionView!.mj_footer.resetNoMoreData()
        
        lastRequest?.fetchFirstPageModels {[weak self] (data, status) -> Void in
            //处理异常状态
            if RetCode.SUCCESS != status {
                ProgressHUD.showErrorHUD(self?.view, text: "您的网络不给力!")
                self?.collectionView?.mj_header.endRefreshing()
                self?.isLoading = false
                return
            }
            
            if let dataSource = data {
                self?.sightCityList = dataSource
            }
            self?.collectionView?.mj_header.endRefreshing()
            self?.isLoading = false
        }
    }
    
    /// 底部加载更多
    func loadMore(){
        if self.isLoading {
            return
        }
        self.isLoading = true
        //请求下一页
        self.lastRequest?.fetchNextPageModels { [weak self] (data, status) -> Void in
            
            if let dataSource = data {

                if dataSource.count > 0 {
//                    if let cells = self?.recommendCells {
                        self?.sightCityList = self!.sightCityList + dataSource
//                    }
                    self?.collectionView?.mj_footer.endRefreshing()
                } else {
                    self?.collectionView?.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            self?.isLoading = false
        }
    }
}