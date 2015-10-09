//
//  CollectMotifViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/8.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout


let collectCityViewIdentifier = "CollectCity_Cell"


class CollectCityViewController: UICollectionViewController {

    /// 网络请求加载数据
    var lastSuccessRequest: CollectSightRequest?
    
    /// 界面布局
    let layout = UICollectionViewFlowLayout()
    
    var collectCity = [CollectCity]()
    
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
        NSLog("notice:refreshing nearby data.")
        
        //获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = CollectSightRequest()
        }
        
        lastSuccessRequest?.fetchCollectMotifModels { (handler: [CollectCity]) -> Void in
            self.collectCity = handler as [CollectCity]
            self.collectionView!.reloadData()
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectCity.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectCityViewIdentifier, forIndexPath: indexPath) as! CollectCityCell
        
        cell.collectCity = collectCity[indexPath.row] as CollectCity

        return cell
    }
    
    
    
    
    
}

// MARK: - CollectTopicCell
class CollectCityCell: UICollectionViewCell {
    
    lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "2.jpg"))
    
    lazy var cityName: UILabel = UILabel(color: UIColor.whiteColor(), title: "北京", fontSize: 16, mutiLines: true)
    
    lazy var topicNum: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.7), title: "共10个话题", fontSize: 11, mutiLines: false)
    
    var collectCity: CollectCity? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: collectCity!.image!))
            cityName.text = collectCity!.name
            topicNum.text = collectCity!.topicNum
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(cityName)
        addSubview(topicNum)
        setupAutoLayout()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        iconView.frame = bounds
        cityName.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
        topicNum.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: nil, offset: CGPointMake(0, -11))
    }
    
}
