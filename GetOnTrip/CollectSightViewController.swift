//
//  CollectSightViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/8.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD
import MJRefresh

let collectionSightViewIdentifier = "CollectionSightView_Cell"

class CollectSightViewController: UICollectionViewController, UIAlertViewDelegate {
    
    /// 网络请求加载数据
    var lastRequest: CollectSightRequest?
    
    /// 界面布局
    let layout = UICollectionViewFlowLayout()

    let collectPrompt = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.3), title: "还木有内容...\n收藏点喜欢的吧(∩_∩)", fontSize: 13, mutiLines: true)
    /// 数据模型
    var collectSights = [CollectSight]() {
        didSet {
            if collectSights.count == 0 {
                collectPrompt.hidden = true
            } else {
                collectPrompt.hidden = false
            }
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
        
        initProperty()
    }
    
    private func initProperty() {
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.addSubview(collectPrompt)
        collectPrompt.ff_AlignInner(ff_AlignType.TopCenter, referView: collectionView!, size: nil, offset: CGPointMake(0, 135))
        collectPrompt.textAlignment = NSTextAlignment.Center
        collectPrompt.hidden = true
        
        let w: CGFloat = (UIScreen.mainScreen().bounds.width - 18 * 3) * 0.5
        let h: CGFloat = w
        
        layout.itemSize = CGSizeMake(w, h)
        layout.minimumLineSpacing = 15
        let lw: CGFloat = 18
        layout.minimumInteritemSpacing = lw
        layout.sectionInset = UIEdgeInsets(top: lw, left: lw, bottom: 0, right: lw)
        
        // Register cell classes
        collectionView?.registerClass(CollectionSightViewCell.self, forCellWithReuseIdentifier: collectionSightViewIdentifier)
        
        //上拉刷新
        let tbHeaderView = MJRefreshNormalHeader(refreshingBlock: loadData)
        tbHeaderView.automaticallyChangeAlpha = true
        tbHeaderView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        tbHeaderView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbHeaderView.lastUpdatedTimeLabel?.font = UIFont.systemFontOfSize(11)
        tbHeaderView.stateLabel?.textColor = SceneColor.lightGray
        tbHeaderView.lastUpdatedTimeLabel?.textColor = SceneColor.lightGray
        
        //下拉刷新
        let tbFooterView = MJRefreshAutoNormalFooter(refreshingBlock: loadMore)
        tbFooterView.automaticallyRefresh = true
        tbFooterView.automaticallyChangeAlpha = true
        tbFooterView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        tbFooterView.stateLabel?.font = UIFont.systemFontOfSize(12)
        tbFooterView.stateLabel?.textColor = SceneColor.lightGray
        
        
        self.collectionView!.mj_header = tbHeaderView
        self.collectionView!.mj_footer = tbFooterView
        
        if !collectionView!.mj_header.isRefreshing() {
            collectionView?.mj_header.beginRefreshing()
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectSights.count == 0 { collectPrompt.hidden = false } else { collectPrompt.hidden = true }
        return collectSights.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionSightViewIdentifier, forIndexPath: indexPath) as! CollectionSightViewCell

        cell.collectBtn.addTarget(self, action: "favoriteAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.collectBtn.tag = indexPath.row
        cell.collectSight = collectSights[indexPath.row] as CollectSight
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = SightViewController()
        //TODO: CollectSight to Sight
        let collectSight = collectSights[indexPath.row]
        let sight = Sight(id: collectSight.id)
        sight.image = collectSight.image
        sight.name  = collectSight.name
        vc.sightDataSource = sight
        navigationController?.pushViewController(vc, animated: true)
    
    }
    
    /// 收藏操作
    var collectTempButton: UIButton?
    func favoriteAction(sender: UIButton) {
        
        let alert = UIAlertView(title: "取消收藏", message: "", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消")
        alert.show()
        collectTempButton = sender
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 0 {
            let data = collectSights[collectTempButton!.tag] as CollectSight
            let type  = FavoriteContant.TypeSight
            
            let objid = data.id
            Favorite.doFavorite(type, objid: objid, isFavorite: false) {
                (result, status) -> Void in
                if status == RetCode.SUCCESS {
                    self.collectTempButton!.selected = false
                    SVProgressHUD.showInfoWithStatus("已取消")
                    self.collectionView!.mj_header.beginRefreshing()
                } else {
                    SVProgressHUD.showInfoWithStatus("网络联连失败，请稍候再试！")
                }
            }
        }
    }
    
    /// 是否正在加载中
    var isLoading:Bool = false
    
    /// 注意：不能在loadData中进行beginRefreshing, beginRefreshing会自动调用loadData
    private func loadData() {
        if self.isLoading {
            return
        }
        
        self.isLoading = true
        
        //清空footer的“加载完成”
        self.collectionView!.mj_footer.resetNoMoreData()
        if lastRequest == nil {
            lastRequest = CollectSightRequest()
            lastRequest?.type = 2
        }
        
        lastRequest?.fetchFirstPageModels {[weak self] (data, status) -> Void in
            //处理异常状态
            if RetCode.SUCCESS != status {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                self?.collectionView!.mj_header.endRefreshing()
                self?.isLoading = false
                return
            }
            
            if let dataSource = data as? [CollectSight] {
                
                self?.collectionView!.mj_header.endRefreshing()
                //有数据才更新
                self?.collectSights = dataSource

            }
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
            
            if let dataSource = data as? [CollectSight] {
                if dataSource.count > 0 {
                    if let cells = self?.collectSights {
                        self?.collectSights = cells + dataSource
                    }
                    self?.collectionView!.mj_footer.endRefreshing()
                } else {
                    self?.collectionView!.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            self?.isLoading = false
        }
    }
}
