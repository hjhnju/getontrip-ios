//
//  SearchHotwordCollectionCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/9.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SearchHotwordCollectionCell: UICollectionViewCell {
    
    
    var hotwordButton = UIButton(title: "", fontSize: 16, radius: 12, titleColor: .whiteColor(), fontName: Font.PingFangSCLight)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hotwordButton.layer.borderWidth = 1.0
        hotwordButton.layer.borderColor = UIColor(hex: 0xBDBDBD, alpha: 0.5).CGColor
        contentView.addSubview(hotwordButton)
        hotwordButton.ff_Fill(contentView)
        hotwordButton.enabled = false
        
        if #available(iOS 9.0, *) {
            hotwordButton.titleLabel?.font = UIFont(name: Font.PingFangSCLight, size: 16)
        } else {
            hotwordButton.titleLabel?.font = UIFont(name: Font.ios8Font, size: 16)
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
