//
//  CollectionCityViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/6.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

// MARK: - CollectTopicCell
class CollectCityCell: BaseCollectionCell {
    
    var data: AnyObject? {
        didSet { // CollectCity
            if let sight = data as? CollectCity {
                
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
