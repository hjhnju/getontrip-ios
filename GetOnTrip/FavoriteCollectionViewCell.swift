
//
//  FavoriteCollectionViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/24.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    var viewController = UIViewController() {
        didSet {
            addSubview(viewController.view)
            viewController.view.frame = bounds
            viewController.view.layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
