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
    lazy var left: UILabel = UILabel(color: SceneColor.frontBlack, title: "名字", fontSize: 16, mutiLines: false)
    
    /// 设置底线
    lazy var baseline: UIView! = UIView(color: SceneColor.darkGrey, alphaF: 0.6)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(baseline)
        contentView.addSubview(left)
        backgroundColor = .whiteColor()
        selectionStyle = .None
        baseline.ff_AlignInner(.BottomCenter, referView: contentView, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
        left.ff_AlignInner(.CenterLeft, referView: contentView, size: nil, offset: CGPointMake(9, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
