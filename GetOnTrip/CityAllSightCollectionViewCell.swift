//
//  CitySightViewCell.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/11.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

// MARK: - SightListCityCell
class CityAllSightCollectionViewCell: UICollectionViewCell {
    
    lazy var iconView: UIImageView = UIImageView()
    
    lazy var cityName: UILabel = UILabel(color: UIColor.whiteColor(), title: "北京", fontSize: 16, mutiLines: true)
    
    lazy var topicNum: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.7), title: "共10个话题", fontSize: 11, mutiLines: false)
    
    lazy var collectBtn: CitySightCollectButton = CitySightCollectButton(image: "search_fav", title: "", fontSize: 0)
    
    lazy var shade: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.2)
    
    lazy var shadeTop: UIView = UIView(color: UIColor(hex: 0x747474, alpha: 0.7))
    
    lazy var shadeLeft: UIView = UIView(color: UIColor(hex: 0x747474, alpha: 0.7))
    
    lazy var shadeRight: UIView = UIView(color: UIColor(hex: 0x747474, alpha: 0.7))
    
    lazy var shadeBottom: UIView = UIView(color: UIColor(hex: 0x747474, alpha: 0.7))
    
    var sightBrief: CitySightBrief? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: sightBrief!.image), placeholderImage:PlaceholderImage.defaultSmall)
            cityName.text = sightBrief!.name
            topicNum.text = sightBrief!.topics
            
            if sightBrief!.collected != "" {
                collectBtn.selected = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAddProperty()
        setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAddProperty() {
        addSubview(iconView)
        addSubview(shade)
        addSubview(shadeTop)
        addSubview(shadeLeft)
        addSubview(shadeRight)
        addSubview(shadeBottom)
        addSubview(cityName)
        addSubview(topicNum)
        addSubview(collectBtn)
        
        collectBtn.setImage(UIImage(named: "collect_yellow"), forState: UIControlState.Selected)
        iconView.contentMode = UIViewContentMode.ScaleAspectFill
        iconView.clipsToBounds = true
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
        collectBtn.ff_AlignInner(ff_AlignType.TopRight, referView: self, size: CGSizeMake(40, 40), offset: CGPointMake(0, 0))
    }
}
