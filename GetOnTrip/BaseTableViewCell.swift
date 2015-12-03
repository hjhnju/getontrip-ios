//
//  BaseTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/24.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class BaseTableViewCell: UITableViewCell {
    
    /// 图片
    lazy var iconView: UIImageView = UIImageView()
    
    /// 标题
    lazy var titleLabel: UILabel = UILabel(color: UIColor(hex: 0x939393, alpha: 1.0), title: "密道传说常年有", fontSize: 13, mutiLines: false)
    
    /// 副标题
    lazy var subtitleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "故宫内真有密道吗？入口在哪里？", fontSize: 16, mutiLines: false)
    
    /// 底线
    lazy var baseline: UIView = UIView(color: UIColor(hex: 0x979797, alpha: 0.3))
    
    //收藏
    lazy var collect: UIButton = UIButton(image: "icon_star_gray", title: " 1", fontSize: 12, titleColor: UIColor(hex: 0x2A2D2E, alpha: 0.6))
    
    //浏览
    lazy var visit: UIButton = UIButton(image: "icon_eye_gray", title: " 1", fontSize: 12, titleColor: UIColor(hex: 0x2A2D2E, alpha: 0.6))
    
    var data: AnyObject?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        overrideBeforeAction()
        setupProperty()
        setupAutoLayout()
        overrideAfterAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProperty() {
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(collect)
        addSubview(visit)
        addSubview(baseline)
        
        iconView.contentMode    = UIViewContentMode.ScaleAspectFill
        iconView.clipsToBounds  = true
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 120 - 27
        titleLabel.preferredMaxLayoutWidth    = w
        subtitleLabel.preferredMaxLayoutWidth = w
        titleLabel.numberOfLines    = 1
        subtitleLabel.numberOfLines = 3
    }
    
    func setupAutoLayout() {
        
        iconView  .ff_AlignInner(.CenterLeft, referView: self, size: CGSizeMake(120, 73), offset: CGPointMake(9, 0))
        titleLabel.ff_AlignHorizontal(.TopRight, referView: iconView, size: nil, offset: CGPointMake(9, 0))
        subtitleLabel.ff_AlignVertical(.BottomLeft, referView: titleLabel, size: nil, offset: CGPointMake(0, 5))
        collect   .ff_AlignHorizontal(.BottomRight, referView: iconView, size: nil, offset: CGPointMake(6, 0))
        visit     .ff_AlignHorizontal(.CenterRight, referView: collect, size: nil, offset: CGPointMake(8, 0))
        baseline  .ff_AlignInner(.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }
    
    func overrideBeforeAction() {
        
    }
    
    func overrideAfterAction() {
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
