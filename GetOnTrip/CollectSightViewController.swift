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

    let collectPrompt = UILabel(color: UIColor.blackColor(), title: "还木有内容......\n收藏点喜欢的吧(n-n)", fontSize: 18, mutiLines: true)
    /// 数据模型
    var collectSights = [CollectSight]() {
        didSet {
            collectPrompt.hidden = true
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
        collectPrompt.ff_AlignInner(ff_AlignType.TopCenter, referView: collectionView!, size: nil, offset: CGPointMake(0, 150))
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
        if collectSights.count == 0 { collectPrompt.hidden = true }
        return collectSights.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionSightViewIdentifier, forIndexPath: indexPath) as! CollectionSightViewCell

        cell.collectBtn.addTarget(self, action: "collectButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.collectBtn.tag = indexPath.row
        cell.collectSight = collectSights[indexPath.row] as CollectSight
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cs = collectSights[indexPath.row] as CollectSight
        
        let vc = SightViewController()
        vc.sightId = cs.id
        // TODO: 未生效
        vc.title = cs.name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///  收藏功能
    ///
    ///  - parameter sender: 收藏按钮
    func collectButtonClick(sender: UIButton) {
        
        let sight = collectSights[sender.tag] as CollectSight
        if sharedUserAccount == nil {
            LoginView.sharedLoginView.addLoginFloating({ (result, error) -> () in
                let resultB = result as! Bool
                if resultB == true {
                    CollectAddAndCancel.sharedCollectAddCancel.fetchCollectionModels(2, objid:sight.id, isAdd: !sender.selected) { (handler) -> Void in
                        print(handler)
                        if handler as! String == "1" {
                            sender.selected = !sender.selected
                            SVProgressHUD.showInfoWithStatus(sender.selected ? "已收藏" : "已取消")
                        } else {
                            SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                        }
                        
                    }
                }
            })
        } else {
            CollectAddAndCancel.sharedCollectAddCancel.fetchCollectionModels(2, objid:sight.id, isAdd: !sender.selected) { (handler) -> Void in
                print(handler)
                if handler as! String == "1" {
                    sender.selected = !sender.selected
                    SVProgressHUD.showInfoWithStatus(sender.selected ? "已收藏" : "已取消")
                } else {
                    SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                }
                
            }
        }
    }

}


// 收藏景点的cell
class CollectionSightViewCell: UICollectionViewCell {
    
    lazy var iconView: UIImageView = UIImageView()
    
    lazy var title: UILabel = UILabel(color: UIColor.whiteColor(), title: "北京", fontSize: 16, mutiLines: false)
    
    lazy var subtitle: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.7), title: "共10个话题", fontSize: 11, mutiLines: false)

    lazy var collectBtn: UIButton = UIButton(image: "search_fav", title: "", fontSize: 0)
    
    var collectSight: CollectSight? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: collectSight!.image))
            title.text = collectSight?.name
            subtitle.text = collectSight?.topicNum
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(title)
        addSubview(subtitle)
        addSubview(collectBtn)
        collectBtn.setImage(UIImage(named: "collect_yellow"), forState: UIControlState.Selected)
        collectBtn.selected = true
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        
        iconView.frame    = self.bounds
        title.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
        subtitle.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: nil, offset: CGPointMake(0, -11))
        collectBtn.ff_AlignInner(ff_AlignType.TopRight, referView: self, size: nil, offset: CGPointMake(-8, 8))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
