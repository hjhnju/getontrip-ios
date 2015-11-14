//
//  CitySightCollectionViewCell.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/14.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit
import FFAutoLayout
import SDWebImage

/// 首页景点cell
class CitySightCollectionViewCell: UICollectionViewCell {
    /// 图片
    var icon: UIImageView = UIImageView()
    /// 标题
    var title: UILabel = UILabel(color: SceneColor.white, title: "", fontSize: 16, mutiLines: false)
    /// 内容及收藏
    var desc: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.9), title: "", fontSize: 8, mutiLines: false)
    
    lazy var shade: UIView = UIView(color: SceneColor.bgBlack, alphaF: 0.35)
    
    var data: AnyObject? {
        didSet {
            if let sight = data as? Sight {
                icon.image = nil
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(shade)
        addSubview(title)
        addSubview(desc)
        icon.contentMode   = UIViewContentMode.ScaleAspectFill
        icon.clipsToBounds = true
        
        
        icon.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: bounds.size, offset: CGPointMake(0, 0))
        shade.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: bounds.size)
        title.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
        desc.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: nil, offset: CGPointMake(0, -5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}