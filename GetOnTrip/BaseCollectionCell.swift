//
//  BaseCollectionCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/24.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

// 相同样式采用继承方法，目前收藏中的景点、城市及城市中间页中的景点样式相同
class BaseCollectionCell: UICollectionViewCell {
    
    /// 图片
    lazy var icon: UIImageView = UIImageView()
    /// 标题
    lazy var title: UILabel = UILabel(color: SceneColor.white, title: "", fontSize: 16, mutiLines: false)
    /// 内容及收藏
    lazy var desc: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.9), title: "", fontSize: 8, mutiLines: false)
    /// 遮罩view
    lazy var shade: UIView = UIView(color: SceneColor.bgBlack, alphaF: 0.35)
    /// 图片宽
    var iconWidth: NSLayoutConstraint?
    /// 图片高
    var iconHeight: NSLayoutConstraint?
    /// 图片宽
    var shadeWidth: NSLayoutConstraint?
    /// 图片高
    var shadeHeight: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(shade)
        addSubview(title)
        addSubview(desc)
        
        icon .contentMode   = .ScaleAspectFill
        icon .clipsToBounds = true
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .Center
        let cons = icon .ff_AlignInner(.CenterCenter, referView: self, size: bounds.size, offset: CGPointMake(0, 0))
        iconWidth = icon.ff_Constraint(cons, attribute: .Width)
        iconHeight = icon.ff_Constraint(cons, attribute: .Height)
        let shadeCons = shade.ff_AlignInner(.CenterCenter, referView: self, size: bounds.size)
        shadeWidth = shade.ff_Constraint(shadeCons, attribute: .Width)
        shadeHeight = shade.ff_Constraint(shadeCons, attribute: .Height)
        desc .ff_AlignInner(.BottomCenter, referView: self, size: nil, offset: CGPointMake(0, -5))
        title.ff_AlignInner(.CenterCenter, referView: self, size: CGSizeMake(bounds.width, 16), offset: CGPointMake(0, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
