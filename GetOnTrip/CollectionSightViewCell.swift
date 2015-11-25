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
class CollectionSightViewCell: BaseCollectionCell {
    
    var data: AnyObject? {
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
}