//
//  CityBrowseTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/18.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CityBrowseTableViewCell: UITableViewCell {
    
    lazy var titleLabel = UILabel(color: SceneColor.frontBlack, title: "", fontSize: 16, mutiLines: true, fontName: Font.PingFangSCLight)
    
    lazy var subtitleLabel = UILabel(color: SceneColor.frontBlackSix, title: "", fontSize: 12, mutiLines: true, fontName: Font.PingFangSCLight)

    lazy var baseLine: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.3)
    
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
        contentView.addSubview(baseLine)
        titleLabel.ff_AlignInner(.CenterLeft, referView: contentView, size: nil, offset: CGPointMake(9, 0))
        subtitleLabel.ff_AlignHorizontal(.CenterRight, referView: titleLabel, size: nil, offset: CGPointMake(22, 0))
        baseLine.ff_AlignInner(.BottomLeft, referView: contentView, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(9, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {

        // Configure the view for the selected state
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }

}
