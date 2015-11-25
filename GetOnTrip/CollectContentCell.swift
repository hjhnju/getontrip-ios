
//
//  CollectContentCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/24.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class CollectContentCell: BaseTableViewCell {
    
    override var data: AnyObject? {
        didSet {
            if let collectContent = data as? CollectContent {
                iconView.sd_setImageWithURL(NSURL(string: collectContent.image))
                titleLabel.text = collectContent.subtitle
                subtitleLabel.text = collectContent.title
                collect.setTitle(" " + collectContent.collect ?? "", forState: .Normal)
                visit.setTitle(" " + collectContent.visit ?? "", forState: .Normal)
            }
        }
    }
}
