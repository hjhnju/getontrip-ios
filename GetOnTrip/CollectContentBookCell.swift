
//
//  CollectContentBookCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/24.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class CollectContentBookCell: BaseTableViewCell {
    
    // 添加属性
    lazy var iconBottomView: UIView = UIView(color:UIColor(hex: 0xEDEDED, alpha: 1.0))
    
    // 赋值对象
    override var data: AnyObject? {
        didSet {
            if let collectContent = data as? CollectContent {
                iconView.sd_setImageWithURL(NSURL(string: collectContent.image))
                titleLabel.text = collectContent.subtitle
                subtitleLabel.text = collectContent.title
                collect.setTitle(" " + collectContent.collect ?? "", forState: .Normal)
                visit.setTitle(" " + collectContent.visit ?? "", forState: .Normal)
            }
        }
    }
    
    // 重写布局方法
    override func setupAutoLayout() {
        iconBottomView.ff_AlignInner(.CenterLeft, referView: self, size: CGSizeMake(120, 91), offset: CGPointMake(9, 0))
        iconView     .ff_AlignInner(.CenterCenter, referView: iconBottomView, size: CGSizeMake(62, 86.5))
        titleLabel   .ff_AlignHorizontal(.TopRight, referView: iconBottomView, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 120 - 27, 13), offset: CGPointMake(9, 0))
        subtitleLabel.ff_AlignVertical(.BottomLeft, referView: titleLabel, size: nil, offset: CGPointMake(0, 5))
        collect      .ff_AlignHorizontal(.BottomRight, referView: iconBottomView, size: nil, offset: CGPointMake(6, 0))
        visit        .ff_AlignHorizontal(.CenterRight, referView: collect, size: nil, offset: CGPointMake(8, 0))
        baseline     .ff_AlignInner(.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }

    
    // 父类给子类需要重写的方法，在此方法中添加想添加的属性及方法
    override func overrideAfterAction() {
        initView()
    }
    
    private func initView() {
        
        addSubview(iconBottomView)
        titleLabel.font = UIFont.systemFontOfSize(16)
        titleLabel.textColor = UIColor.blackColor()
    }
}
