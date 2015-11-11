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

let collectionSightViewIdentifier = "CollectionSightView_Cell"

class CollectSightViewController: UICollectionViewController {
    
    /// 界面布局
    let layout = UICollectionViewFlowLayout()

    let collectPrompt = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.3), title: "还木有内容...\n收藏点喜欢的吧(∩_∩)", fontSize: 13, mutiLines: true)
    /// 数据模型
    var collectSights = [CollectSight]() {
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
        
        layout.itemSize = CGSizeMake(w, h)
        layout.minimumLineSpacing = 15
        let lw: CGFloat = (UIScreen.mainScreen().bounds.width - w * 2) / 3
        layout.minimumInteritemSpacing = lw

        layout.sectionInset = UIEdgeInsets(top: lw, left: lw, bottom: 0, right: lw)

        // Register cell classes
        collectionView?.registerClass(CollectionSightViewCell.self, forCellWithReuseIdentifier: collectionSightViewIdentifier)


        refresh()
    }
    

    
    private func refresh() {

        CollectSightRequest.sharedCollectType.fetchCollectionModels(2) { (handler) -> Void in
            self.collectSights = handler as! [CollectSight]
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
        //vc.sightDataSource = collectSights[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    
    }
    
    /// 收藏操作
    func favoriteAction(sender: UIButton) {
        let type  = FavoriteContant.TypeSight
        let sight = collectSights[sender.tag] as CollectSight
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
