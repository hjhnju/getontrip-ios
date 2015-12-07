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
class CitySightCollectionViewCell: BaseCollectionCell {
    
    var size: CGSize = CGSizeZero
    
    var data: AnyObject? {
        didSet {
            if let sight = data as? Sight {
                iconWidth?.constant = size.width
                iconHeight?.constant = size.height
                shadeWidth?.constant = size.width
                shadeHeight?.constant = size.height
                icon.sd_setImageWithURL(NSURL(string: sight.image), placeholderImage:PlaceholderImage.defaultSmall)
                
                title.text = sight.name
                
                let attr = NSMutableAttributedString()
                attr.appendAttributedString((sight.content.getAttributedStringHeadCharacterBig()))
                attr.appendAttributedString(NSAttributedString(string: " | "))
                attr.appendAttributedString((sight.collect.getAttributedStringHeadCharacterBig()))
                desc.attributedText = attr
                self.clipsToBounds = true
            }
        }
    }    
}