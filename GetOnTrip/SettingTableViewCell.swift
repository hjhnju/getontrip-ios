//
//  SettingTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/6.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

// MARK: - settingTableViewCell
class SettingTableViewCell: UITableViewCell {
    
    /// 左标签
    lazy var left: UILabel = UILabel(color: UIColor.blackColor(), title: "名字", fontSize: 16, mutiLines: false)
    
    /// 设置底线
    lazy var baseline: UIView! = UIView(color: SceneColor.shallowGrey, alphaF: 0.3)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(baseline)
        addSubview(left)
        backgroundColor = .whiteColor()
        selectionStyle = .None
        baseline.ff_AlignInner(.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
        left.ff_AlignInner(.CenterLeft, referView: self, size: nil, offset: CGPointMake(9, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
