//
//  CollectViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/6.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

// 收藏景点的cell
class CollectionSightViewCell: CitySightCollectionViewCell {
    
//    lazy var iconView: UIImageView = UIImageView()
//    
//    lazy var title: UILabel = UILabel(color: UIColor.whiteColor(), title: "北京", fontSize: 16, mutiLines: false)
//    
//    lazy var subtitle: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.7), title: "共10个话题", fontSize: 11, mutiLines: false)
    
//    var collectSight: CollectSight? {
//        didSet {
//            iconView.sd_setImageWithURL(NSURL(string: collectSight!.image), placeholderImage: PlaceholderImage.defaultSmall)
//            title.text = collectSight?.name
//            subtitle.text = collectSight?.topicNum
//        }
//    }
    
    override var data: AnyObject? {
        didSet {
            if let sight = data as? CollectSight {

                icon.sd_setImageWithURL(NSURL(string: sight.image), placeholderImage:PlaceholderImage.defaultSmall)
                title.text = sight.name
                let attr = NSMutableAttributedString()
                attr.appendAttributedString((sight.content.getAttributedStringHeadCharacterBig()))
                attr.appendAttributedString(NSAttributedString(string: " | "))
                attr.appendAttributedString((sight.collect.getAttributedStringHeadCharacterBig()))
                desc.attributedText = attr
                
            }
        }
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        addSubview(iconView)
//        addSubview(title)
//        addSubview(subtitle)
//        iconView.contentMode   = UIViewContentMode.ScaleAspectFill
//        iconView.clipsToBounds = true
//        setupAutoLayout()
//    }
//    
//    private func setupAutoLayout() {
//        
//        iconView.frame    = self.bounds
//        title.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
//        subtitle.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: nil, offset: CGPointMake(0, -11))
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}