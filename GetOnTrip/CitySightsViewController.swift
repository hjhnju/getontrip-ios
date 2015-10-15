//
//  SightListCityController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

let sightListCityIdentifier = "SightListCity_Cell"

class CitySightsViewController: UICollectionViewController {
    
    /// 城市ID
    var cityId: String?
    
    /// 网络请求加载数据
    var lastSuccessRequest: SightListCityRequest?
    
    /// 界面布局
    let layout = UICollectionViewFlowLayout()
    
    var sightCityList: [SightCityList]? {
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
        view.backgroundColor = UIColor(patternImage: UIImage(named: "feedBack_background")!)

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
        collectionView?.registerClass(SightListCityCell.self, forCellWithReuseIdentifier: sightListCityIdentifier)
        
        
        refresh()
    }
    
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        //获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = SightListCityRequest()
            lastSuccessRequest?.cityId = cityId
        }
        
        lastSuccessRequest?.fetchSightCityModels { (handler: [SightCityList]) -> Void in
            self.sightCityList = handler
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (sightCityList == nil) { return 0 }
        return sightCityList!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(sightListCityIdentifier, forIndexPath: indexPath) as! SightListCityCell
        cell.sightCity = sightCityList![indexPath.row] as SightCityList
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = SightViewController()
        let sight = sightCityList![indexPath.row] as SightCityList
        vc.sightId = sight.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
    
// MARK: - SightListCityCell
class SightListCityCell: UICollectionViewCell {
    
    lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "2.jpg"))
    
    lazy var cityName: UILabel = UILabel(color: UIColor.whiteColor(), title: "北京", fontSize: 16, mutiLines: true)
    
    lazy var topicNum: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.7), title: "共10个话题", fontSize: 11, mutiLines: false)
    
    lazy var collectBtn: UIButton = UIButton(image: "search_fav", title: "", fontSize: 0)
    
    lazy var shade: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.2)
    
    lazy var shadeTop: UIView = UIView(color: UIColor(hex: 0x747474, alpha: 0.7))
    
    lazy var shadeLeft: UIView = UIView(color: UIColor(hex: 0x747474, alpha: 0.7))
    
    lazy var shadeRight: UIView = UIView(color: UIColor(hex: 0x747474, alpha: 0.7))
    
    lazy var shadeBottom: UIView = UIView(color: UIColor(hex: 0x747474, alpha: 0.7))
    
    var sightCity: SightCityList? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: sightCity!.image!))
            cityName.text = sightCity!.name
            topicNum.text = sightCity!.topics
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(shade)
        addSubview(shadeTop)
        addSubview(shadeLeft)
        addSubview(shadeRight)
        addSubview(shadeBottom)
        addSubview(cityName)
        addSubview(topicNum)
        addSubview(collectBtn)
        setupAutoLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        iconView.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: bounds.size, offset: CGPointMake(0, 0))
        cityName.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
        topicNum.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: nil, offset: CGPointMake(0, -11))
        shade.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: bounds.size, offset: CGPointMake(0, 0))
        shadeTop.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: CGSizeMake(bounds.width, 2), offset: CGPointMake(0, 0))
        shadeLeft.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(2, bounds.height), offset: CGPointMake(0, 0))
        shadeRight.ff_AlignInner(ff_AlignType.CenterRight, referView: self, size: CGSizeMake(2, bounds.height), offset: CGPointMake(0, 0))
        shadeBottom.ff_AlignInner(ff_AlignType.BottomLeft, referView: self, size: CGSizeMake(bounds.width, 2), offset: CGPointMake(0, 0))
        collectBtn.ff_AlignInner(ff_AlignType.TopRight, referView: self, size: nil, offset: CGPointMake(-8, 8))
    }
        
}
