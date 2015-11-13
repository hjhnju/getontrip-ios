//
//  SightListCityController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

let sightListCityIdentifier = "SightListCity_Cell"

class CitySightsViewController: UICollectionViewController {
    
    /// 自定义导航
    var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: UIColor.whiteColor(), titleSize: 18)
    
    /// 城市ID
    var cityId: String = ""
    
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
        view.backgroundColor = SceneColor.frontBlack
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        collectionView?.frame = CGRectMake(0, 44, view.bounds.width, view.bounds.height - 44)
        
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
        
        refresh()
    }
    
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        //获取数据更新tableview
        if lastRequest == nil {
            lastRequest = CitySightsRequest()
            lastRequest?.cityId = cityId
        }
        
        lastRequest?.fetchSightCityModels { (handler: [CitySightBrief]) -> Void in
            self.sightCityList = handler
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
        
        let sight = sightCityList[sender.tag] as CitySightBrief
        let type  = FavoriteContant.TypeSight
        let objid = sight.id
        Favorite.doFavorite(type, objid: objid, isFavorite: !sender.selected) {
            (result, status) -> Void in
            if status == RetCode.SUCCESS {
                sender.selected = !sender.selected
                SVProgressHUD.showInfoWithStatus(sender.selected ? "已收藏" : "已取消")
            } else {
                SVProgressHUD.showInfoWithStatus("收藏未成功，请稍后再试")
            }
        }
    }
}