//
//  HotCityTableViewHeaderView.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/19.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class HotCityTableViewHeaderView: UITableViewHeaderFooterView {

    lazy var titleLabel: UILabel = UILabel(color: SceneColor.frontBlackSix, title: "当前城市", fontSize: 14, mutiLines: true, fontName: Font.PingFangSCRegular)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = SceneColor.greyWhite
        contentView.addSubview(titleLabel)
        titleLabel.ff_AlignInner(.CenterLeft, referView: contentView, size: nil, offset: CGPointMake(9, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
