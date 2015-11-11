//
//  CollectMotifViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/8.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

let collectCityViewIdentifier = "CollectCity_Cell"

class CollectCityViewController: UICollectionViewController {

    /// 网络请求加载数据
    var lastSuccessRequest: CollectSightRequest?
    
    let collectPrompt = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.3), title: "还木有内容...\n收藏点喜欢的吧(∩_∩)", fontSize: 13, mutiLines: true)
    
    /// 界面布局
    let layout = UICollectionViewFlowLayout()
    
    var collectCity = [CollectCity]() {
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
        
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.addSubview(collectPrompt)
        collectPrompt.ff_AlignInner(ff_AlignType.TopCenter, referView: collectionView!, size: nil, offset: CGPointMake(0, 135))
        collectPrompt.textAlignment = NSTextAlignment.Center

        let w: CGFloat = 170
        let h: CGFloat = 150
        // 每个item的大小
        layout.itemSize = CGSizeMake(w, h)
        // 行间距
        layout.minimumLineSpacing = 15
        // item之间水平间距
        let lw: CGFloat = (UIScreen.mainScreen().bounds.width - w * 2) / 3
        layout.minimumInteritemSpacing = lw

        layout.sectionInset = UIEdgeInsets(top: lw, left: lw, bottom: 0, right: lw)
        
        // Register cell classes
        collectionView?.registerClass(CollectCityCell.self, forCellWithReuseIdentifier: collectCityViewIdentifier)

        
        refresh()
    }
    
    private func refresh() {
        CollectSightRequest.sharedCollectType.fetchCollectionModels(3) { (handler) -> Void in
            self.collectCity = handler as! [CollectCity]
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectCity.count == 0 { collectPrompt.hidden = false } else { collectPrompt.hidden = true }
        return collectCity.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectCityViewIdentifier, forIndexPath: indexPath) as! CollectCityCell
        cell.collectBtn.addTarget(self, action: "favoriteAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.collectBtn.tag = indexPath.row
        cell.collectCity = collectCity[indexPath.row] as CollectCity

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let ct = collectCity[indexPath.row] as CollectCity
        let vc = CityViewController()
        vc.cityDataSource = City(id: ct.id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 收藏操作
    func favoriteAction(sender: UIButton) {
        let type  = FavoriteContant.TypeCity
        let city = collectCity[sender.tag] as CollectCity
        let objid = city.id
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