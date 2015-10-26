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
    
    let collectPrompt = UILabel(color: UIColor.blackColor(), title: "还木有内容......\n收藏点喜欢的吧(n-n)", fontSize: 18, mutiLines: true)
    
    /// 界面布局
    let layout = UICollectionViewFlowLayout()
    
    var collectCity = [CollectCity]() {
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
        if collectCity.count == 0 { collectPrompt.hidden = true }
        return collectCity.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectCityViewIdentifier, forIndexPath: indexPath) as! CollectCityCell
        
        cell.collectCity = collectCity[indexPath.row] as CollectCity

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let ct = collectCity[indexPath.row] as CollectCity
        let vc = CityViewController()
        vc.cityId = ct.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

// MARK: - CollectTopicCell
class CollectCityCell: UICollectionViewCell {
    
    lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "2.jpg"))
    
    lazy var cityName: UILabel = UILabel(color: UIColor.whiteColor(), title: "北京", fontSize: 16, mutiLines: true)
    
    lazy var topicNum: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.7), title: "共10个话题", fontSize: 11, mutiLines: false)
    
    var collectCity: CollectCity? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: collectCity!.image), placeholderImage:PlaceholderImage.defaultSmall)
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
