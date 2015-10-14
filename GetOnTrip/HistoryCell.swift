//
//  HistoryCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/3/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class HistoryCell: UITableViewCell {
    
    /// 图片
    lazy var iconView: UIImageView = UIImageView()
    
    ///  副标题
    lazy var subtitleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "密道传说常年有", fontSize: 14, mutiLines: false)
    
    ///  标题
    lazy var titleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "故宫内真有密道吗？如果有入口在哪里？", fontSize: 18, mutiLines: false)
    
    ///  收藏
    lazy var collect: UIButton = UIButton(image: "eye", title: "  18", fontSize: 12)
    
    ///  预览
    lazy var preview: UIButton = UIButton(image: "eye", title: "  90", fontSize: 12)
    
    var otherData: SightListData? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: otherData!.image! + "@_\(133)w_\(84)h"))
            subtitleLabel.text = otherData?.subtitle
            titleLabel.text = otherData?.title
            collect.setTitle("  " + (otherData?.collect)!, forState: UIControlState.Normal)
            preview.setTitle("  " + (otherData?.visit)!, forState: UIControlState.Normal)
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        
        print("调用了几次呢")
        addSubview(iconView)
        addSubview(subtitleLabel)
        addSubview(titleLabel)
        addSubview(collect)
        addSubview(preview)
        
        titleLabel.numberOfLines = 2
        
        iconView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(133, 84), offset: CGPointMake(9, 0))
        subtitleLabel.ff_AlignHorizontal(ff_AlignType.TopRight, referView: iconView, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 133 - 18 - 6, 19), offset: CGPointMake(6, 0))
        titleLabel.ff_AlignVertical(ff_AlignType.BottomLeft, referView: subtitleLabel, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 133 - 18 - 6, 44), offset: CGPointMake(0, 1))
        collect.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPointMake(6, 0))
        preview.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: collect, size: nil, offset: CGPointMake(8, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
