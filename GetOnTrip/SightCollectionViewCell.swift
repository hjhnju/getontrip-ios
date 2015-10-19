//
//  SightCollectionViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SightCollectionViewCell: UICollectionViewCell {
    
    /// 子控制器
    var vc: TopicTableViewController = TopicTableViewController()
    
    var type: Int? {
        didSet {
            vc.type = type
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(vc.view)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        vc.view.frame = bounds
    }

}
