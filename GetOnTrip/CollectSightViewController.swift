//
//  CollectSightViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/8.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

let collectionSightViewIdentifier = "CollectionSightView_Cell"


class CollectSightViewController: UICollectionViewController {
    
    /// 界面布局
    let layout = UICollectionViewFlowLayout()
    
    /// 网络请求加载数据
    var lastSuccessRequest: CollectSightRequest?

    /// 数据模型
    var collectSights = [CollectSight]()
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = UIColor.clearColor()

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
        NSLog("notice:refreshing nearby data.")
        
        //获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = CollectSightRequest()
            lastSuccessRequest?.type = 2
        }
        
        lastSuccessRequest?.fetchCollectTopicModels { (handler: [AnyObject]) -> Void in
            self.collectSights = handler as! [CollectSight]
            self.collectionView?.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectSights.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionSightViewIdentifier, forIndexPath: indexPath) as! CollectionSightViewCell

        
        cell.collectSight = collectSights[indexPath.row] as CollectSight
        return cell
    }
}


// 收藏景点的cell
class CollectionSightViewCell: UICollectionViewCell {
    
    lazy var iconView: UIImageView = UIImageView()
    
    lazy var title: UILabel = UILabel(color: UIColor.whiteColor(), title: "北京", fontSize: 16, mutiLines: false)
    
    lazy var subtitle: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.7), title: "共10个话题", fontSize: 11, mutiLines: false)

    
    var collectSight: CollectSight? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: collectSight!.image!))
            title.text = collectSight?.name
            subtitle.text = collectSight?.topicNum
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(title)
        addSubview(subtitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.frame    = self.bounds
        title.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
        subtitle.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: nil, offset: CGPointMake(0, -11))

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
