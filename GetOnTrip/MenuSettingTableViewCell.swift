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

    lazy var titleLabel: UILabel = UILabel(color: SceneColor.whiteBlue, title: "", fontSize: 18, mutiLines: true, fontName: Font.PingFangSCLight)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        backgroundColor = .clearColor()
        titleLabel.ff_AlignInner(.CenterLeft, referView: contentView, size: nil, offset: CGPointMake(45, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
