//
//  FoodHeaderViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/19.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class FoodHeaderContentViewCell: UITableViewHeaderFooterView {
    
    lazy var contentLabel = UILabel(color: SceneColor.frontBlack, title: "炒肝。", fontSize: 18, mutiLines: true, fontName: Font.PingFangSCLight)
    
    var data = "" {
        didSet {
            contentLabel.attributedText = data.getAttributedString(0, lineSpacing: 7,
                breakMode: .ByTruncatingTail, fontName: Font.PingFangSCLight, fontSize: 18)
        }
    }
    
    class func heightWithString(data: String) -> CGFloat {
        return data.sizeofStringWithFount(UIFont(name: Font.PingFangSCLight, size: 18) ?? UIFont(name: Font.ios8Font, size: 18)!,
            maxSize: CGSizeMake(Frame.screen.width - 18, CGFloat.max), lineSpacing: 7).height + 15
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(contentLabel)
        contentLabel.ff_AlignInner(.TopLeft, referView: contentView, size: nil, offset: CGPointMake(9, 15))
        contentLabel.preferredMaxLayoutWidth = Frame.screen.width - 18
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
