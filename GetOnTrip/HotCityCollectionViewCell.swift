//
//  HotCityCollectionViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/19.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class HotCityCollectionViewCell: BaseCollectionCell {

    var data: AnyObject? {
        didSet { // CollectCity
            if let data = data as? HotCity {
                
                icon.sd_setImageWithURL(NSURL(string: data.image), placeholderImage:PlaceholderImage.defaultSmall)
                title.text = data.name
                let attr = NSMutableAttributedString()
                attr.appendAttributedString((data.sight.getAttributedStringHeadCharacterBig()))
                attr.appendAttributedString(NSAttributedString(string: " | "))
                attr.appendAttributedString((data.topic.getAttributedStringHeadCharacterBig()))
                desc.attributedText = attr
            }
        }
    }
    
}
