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
    var VC: HistoryTableViewController = HistoryTableViewController()
    
    var type: Int? {
        didSet {
            VC.type = type
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(VC.view)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        VC.view.frame = bounds
    }

}
