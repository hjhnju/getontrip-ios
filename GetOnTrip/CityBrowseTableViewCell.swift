//
//  CityBrowseTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/18.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CityBrowseTableViewCell: UITableViewCell {
    
    lazy var titleLabel = UILabel(color: SceneColor.frontBlack, title: "", fontSize: 16, mutiLines: true, fontName: Font.PingFangSCRegular)
    
    lazy var subtitleLabel = UILabel(color: SceneColor.frontBlackSix, title: "", fontSize: 12, mutiLines: true, fontName: Font.PingFangSCRegular)

    var dataSource: CityContent? {
        didSet {
            if let data = dataSource {
                titleLabel.text = data.name
                subtitleLabel.text = "\(data.sight)个景点，\(data.topic)篇内容"
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        titleLabel.ff_AlignInner(.CenterLeft, referView: contentView, size: nil, offset: CGPointMake(9, 0))
        subtitleLabel.ff_AlignHorizontal(.CenterRight, referView: titleLabel, size: nil, offset: CGPointMake(22, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
