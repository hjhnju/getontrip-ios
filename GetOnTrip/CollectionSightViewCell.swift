//
//  CollectViewCell.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/11.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

// 收藏景点的cell
class CollectionSightViewCell: UICollectionViewCell {
    
    lazy var iconView: UIImageView = UIImageView()
    
    lazy var title: UILabel = UILabel(color: UIColor.whiteColor(), title: "北京", fontSize: 16, mutiLines: false)
    
    lazy var subtitle: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.7), title: "共10个话题", fontSize: 11, mutiLines: false)
    
    lazy var collectBtn: CitySightCollectButton = CitySightCollectButton(image: "search_fav", title: "", fontSize: 0)
    
    var collectSight: CollectSight? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: collectSight!.image), placeholderImage: PlaceholderImage.defaultSmall)
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
        collectBtn.selected    = true
        iconView.contentMode   = UIViewContentMode.ScaleAspectFill
        iconView.clipsToBounds = true
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        
        iconView.frame    = self.bounds
        title.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
        subtitle.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: nil, offset: CGPointMake(0, -11))
        collectBtn.ff_AlignInner(ff_AlignType.TopRight, referView: self, size: CGSizeMake(50, 50))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}