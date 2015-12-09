//
//  SearchHotwordCollectionCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/9.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SearchHotwordCollectionCell: UICollectionViewCell {
    
    var hotwordButton = UIButton(title: "", fontSize: 16, radius: 12, titleColor: UIColor.whiteColor())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hotwordButton.layer.borderWidth = 1.0
        hotwordButton.layer.borderColor = UIColor(hex: 0xBDBDBD, alpha: 0.5).CGColor
        contentView.addSubview(hotwordButton)
        hotwordButton.ff_Fill(contentView)
        hotwordButton.enabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
