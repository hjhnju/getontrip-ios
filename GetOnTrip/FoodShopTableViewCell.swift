//
//  FoodTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/19.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class FoodShopTableViewCell: UITableViewCell {

    /// 图片
    lazy var iconView: UIImageView = UIImageView()
    ///  标题
    lazy var titleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 18, mutiLines: false)
    ///  地扯
    lazy var addrLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 14, mutiLines: false)
    /// 星一
    lazy var starOne = UIImageView(image: UIImage(named: "icon_not_star")!)
    /// 星二
    lazy var starTwo = UIImageView(image: UIImage(named: "icon_not_star")!)
    /// 星三
    lazy var starThree = UIImageView(image: UIImage(named: "icon_not_star")!)
    /// 星四
    lazy var starFour = UIImageView(image: UIImage(named: "icon_not_star")!)
    /// 星五
    lazy var starFive = UIImageView(image: UIImage(named: "icon_not_star")!)
    /// 评分
    lazy var scoreLabel: UILabel = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.6), title: "1分", fontSize: 10, mutiLines: true, fontName: Font.PingFangSCLight)
    /// 价格
    lazy var priceLabel: UILabel = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.6), title: "人均：120元", fontSize: 10, mutiLines: true, fontName: Font.PingFangSCLight)
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
                addrLabel.text = cellData.addr
                let scoreInt = Float(cellData.score) ?? 0
                
                for var i = 0; i<Int(scoreInt); i++ {
                   scoreSwitch(i, imageStr: "icon_star")
                }
                if Float(cellData.score ?? "0")! % Float(scoreInt) > 0 {
                    scoreSwitch(Int(scoreInt), imageStr: "icon_star_falf")
                }
                scoreLabel.text = cellData.score + "分"
                priceLabel.text = "人均: " + cellData.price + "元"
            }
        }
    }
    
    private func scoreSwitch(i: Int, imageStr: String) {
        switch i {
        case 0:
            starOne.image = UIImage(named: imageStr)
        case 1:
            starTwo.image = UIImage(named: imageStr)
        case 2:
            starThree.image = UIImage(named: imageStr)
        case 3:
            starFour.image = UIImage(named: imageStr)
        case 4:
            starFive.image = UIImage(named: imageStr)
        default:
            break
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = SceneColor.greyWhite
        
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(addrLabel)
        contentView.addSubview(starOne)
        contentView.addSubview(starTwo)
        contentView.addSubview(starThree)
        contentView.addSubview(starFour)
        contentView.addSubview(starFive)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(baseLine)
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 133 - 24
        titleLabel.numberOfLines = 2
        titleLabel.preferredMaxLayoutWidth = w
        
        iconView.ff_AlignInner(.CenterLeft, referView: contentView, size: CGSizeMake(124, 84), offset: CGPointMake(9, 0))
        titleLabel.ff_AlignHorizontal(.TopRight, referView: iconView, size: CGSizeMake(w, 19), offset: CGPointMake(6, -1.5))
        addrLabel.ff_AlignHorizontal(.BottomRight, referView: iconView, size: nil, offset: CGPointMake(6, 0))
        baseLine.ff_AlignInner(.BottomCenter, referView: contentView, size: CGSizeMake(Frame.screen.width - 18, 0.5))
        starOne.ff_AlignVertical(.BottomLeft, referView: titleLabel, size: CGSizeMake(12, 11), offset: CGPointMake(0, 7))
        starTwo.ff_AlignHorizontal(.CenterRight, referView: starOne, size: CGSizeMake(12, 11), offset: CGPointMake(1, 0))
        starThree.ff_AlignHorizontal(.CenterRight, referView: starTwo, size: CGSizeMake(12, 11), offset: CGPointMake(1, 0))
        starFour.ff_AlignHorizontal(.CenterRight, referView: starThree, size: CGSizeMake(12, 11), offset: CGPointMake(1, 0))
        starFive.ff_AlignHorizontal(.CenterRight, referView: starFour, size: CGSizeMake(12, 11), offset: CGPointMake(1, 0))
        scoreLabel.ff_AlignHorizontal(.CenterRight, referView: starFive, size: nil, offset: CGPointMake(6, 0))
        priceLabel.ff_AlignHorizontal(.CenterRight, referView: scoreLabel, size: nil, offset: CGPointMake(27, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}
