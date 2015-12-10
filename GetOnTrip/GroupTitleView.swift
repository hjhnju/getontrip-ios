//
//  GroupTitleView.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/9.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class GroupTitleView: UIView {
    
    /// 搜索历史标签
    lazy var recordLabel: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.7), title: "搜索历史", fontSize: 12, mutiLines: true)
    
    /// 清除按钮
    lazy var recordDelButton: UIButton = UIButton(title: "清除历史", fontSize: 10, radius: 0, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.7))
    
    /// 基线
    lazy var baseLine: UIView = UIView(color: UIColor(hex: 0xBDBDBD, alpha: 0.15))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(recordLabel)
        addSubview(recordDelButton)
        addSubview(baseLine)
        recordLabel.ff_AlignInner(.BottomLeft, referView: self, size: nil, offset: CGPointMake(9, -9))
        recordDelButton.ff_AlignInner(.BottomRight, referView: self, size: nil, offset: CGPointMake(-9, -5))
        baseLine.ff_AlignInner(.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
