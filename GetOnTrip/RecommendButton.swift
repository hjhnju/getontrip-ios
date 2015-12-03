//
//  RecommendButton.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/3.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class RecommendButton: UIButton {
    
    lazy var numLabel: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "", fontSize: 14, mutiLines: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(numLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
