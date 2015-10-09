//
//  SearchListTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class SearchListTableViewCell: UITableViewCell {

    // MARK: - 属性
    /// 底图
    lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "2.jpg"))
    
    /// 中部标题
    lazy var title: UIButton = UIButton(title: "北京", fontSize: 16, radius: 5, titleColor: UIColor(hex: 0x2A2D2E, alpha: 1.0))
    
    /// 遮罩
    lazy var shade: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.5)
    
    /// 收藏按钮
    lazy var btn1: UIButton = UIButton(image: "collect_star", title: "  15人收藏", fontSize: 10, titleColor: UIColor.whiteColor())
    
    /// 景点按钮
    lazy var btn2: UIButton = UIButton(image: "collect_star", title: "  8个景点", fontSize: 10, titleColor: UIColor.whiteColor())
    
    /// 话题按钮
    lazy var btn3: UIButton = UIButton(image: "collect_star", title: "  25个话题", fontSize: 10, titleColor: UIColor.whiteColor())
    
    lazy var btnBlackground: UIView = UIView(color: UIColor.whiteColor(), alphaF: 0.5)
    
    lazy var effect = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
    
    var data: SearchData? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: data!.image!))
            title.setTitle("   " + data!.name! + "   ", forState: UIControlState.Normal)
            btn1.setTitle("  " + data!.collect_num, forState: UIControlState.Normal)
            btn2.setTitle("  " + data!.sight_num, forState: UIControlState.Normal)
            btn3.setTitle("  " + data!.topic_num, forState: UIControlState.Normal)
        }
    }
    
    // MARK: - 初始化相关
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        addSubview(iconView)
        addSubview(btnBlackground)
        addSubview(effect)
        addSubview(title)
        addSubview(shade)
        addSubview(btn1)
        addSubview(btn2)
        addSubview(btn3)
        
        iconView.userInteractionEnabled = false
        effect.userInteractionEnabled = false
        shade.userInteractionEnabled = false
        btnBlackground.userInteractionEnabled = false
        title.userInteractionEnabled = false
        
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        iconView.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 190), offset: CGPointMake(0, 2))
        title.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
        shade.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 26), offset: CGPointMake(0, 0))
        btn1.ff_AlignInner(ff_AlignType.CenterCenter, referView: shade, size: nil, offset: CGPointMake(90, 0))
        btn2.ff_AlignInner(ff_AlignType.CenterCenter, referView: shade, size: nil, offset: CGPointMake(0, 0))
        btn3.ff_AlignInner(ff_AlignType.CenterCenter, referView: shade, size: nil, offset: CGPointMake(-90, 0))
        btnBlackground.ff_AlignInner(ff_AlignType.CenterCenter, referView: title, size: CGSizeMake(title.bounds.width, title.bounds.height), offset: CGPointMake(0, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        btnBlackground.frame = title.frame
        effect.frame = title.frame
        effect.layer.cornerRadius = 10
        effect.clipsToBounds = true
        btnBlackground.layer.cornerRadius = 10
        btnBlackground.clipsToBounds = true
    }
}
