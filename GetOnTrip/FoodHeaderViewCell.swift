//
//  FoodHeaderViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/19.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class FoodHeaderViewCell: UITableViewHeaderFooterView {

    /// 标题
    lazy var titleLabel: UILabel = UILabel(color: SceneColor.originYellow, title: "推荐名店", fontSize: 16, mutiLines: true, fontName: Font.PingFangTCMedium)
    /// 下一页
    lazy var BottomButton: UIButton = UIButton(title: "下一页", fontSize: 11, radius: 0, titleColor: UIColor(hex: 0x282828, alpha: 0.5), fontName: Font.PingFangSCLight)
    /// 上一页
    lazy var upButton: UIButton = UIButton(title: "上一页", fontSize: 11, radius: 0, titleColor: UIColor(hex: 0x282828, alpha: 0.5), fontName: Font.PingFangSCLight)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(titleLabel)
        contentView.addSubview(BottomButton)
        contentView.addSubview(upButton)
        
        titleLabel.ff_AlignInner(.CenterLeft, referView: contentView, size: nil, offset: CGPointMake(9, 0))
        BottomButton.ff_AlignInner(.CenterRight, referView: contentView, size: nil, offset: CGPointMake(-9, 0))
        upButton.ff_AlignHorizontal(.CenterLeft, referView: BottomButton, size: nil, offset: CGPointMake(-20, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
