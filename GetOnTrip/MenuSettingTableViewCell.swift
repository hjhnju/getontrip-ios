//
//  MenuSettingTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class MenuSettingTableViewCell: UITableViewCell {

    lazy var titleLabel: UILabel = UILabel(color: UIColor.whiteColor(), fontSize: 16, mutiLines: true)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(baseline)
        addSubview(titleLabel)
        
        backgroundColor = UIColor.clearColor()
        baseline.ff_AlignInner(ff_AlignType.BottomLeft, referView: self, size: CGSizeMake(bounds.width, 0.5), offset: CGPointMake(0, 0))
        titleLabel.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置底线
    lazy var baseline: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(white: 0xFFFFFF, alpha: 0.3)
        return baselineView
        }()
}
