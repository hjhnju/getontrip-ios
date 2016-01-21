//
//  SpecialtyTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/19.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class SpecialtyTableViewCell: UITableViewCell {

    /// 图片
    lazy var iconView: UIImageView = UIImageView()
    ///  标题
    lazy var titleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 15, mutiLines: false, fontName: Font.PingFangSCRegular)
    /// 价格
    lazy var priceLabel: UILabel = UILabel(color: SceneColor.originYellow, title: "¥ 98", fontSize: 14, mutiLines: true, fontName: Font.PingFangSCRegular)
    /// 购买链接
    lazy var buyButton: UIButton = UIButton(title: "   购买链接   ", fontSize: 12, radius: 15, titleColor: SceneColor.frontBlack, fontName: Font.PingFangSCLight)
    /// 基线
    lazy var baseLine: UIView = UIView(color: UIColor(hex: 0x979797, alpha: 0.3))
    
    var data: ShopDetail? {
        didSet {
            if let cellData = data {
                iconView.backgroundColor = cellData.bgColor
                //是否加载网络图片
                if UserProfiler.instance.isShowImage() {
                    iconView.sd_setImageWithURL(NSURL(string: cellData.image))
                }
                titleLabel.text = cellData.title
                priceLabel.text = "¥ " + cellData.price
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = SceneColor.greyWhite
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(buyButton)
        contentView.addSubview(baseLine)
        
        titleLabel.numberOfLines = 2
        titleLabel.preferredMaxLayoutWidth = Frame.screen.width - 139
        
        buyButton.backgroundColor = SceneColor.lightYellow
        buyButton.userInteractionEnabled = false
        
        iconView.ff_AlignInner(.CenterLeft, referView: contentView, size: CGSizeMake(124, 80), offset: CGPointMake(9, 0))
        titleLabel.ff_AlignHorizontal(.TopRight, referView: iconView, size: nil, offset: CGPointMake(6, -2))
        priceLabel.ff_AlignHorizontal(.BottomRight, referView: iconView, size: nil, offset: CGPointMake(6, 2))
        buyButton.ff_AlignInner(.BottomRight, referView: contentView, size: CGSizeMake(91, 34), offset: CGPointMake(-9, -15))
        baseLine.ff_AlignInner(.BottomCenter, referView: contentView, size: CGSizeMake(Frame.screen.width - 18, 0.5))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
