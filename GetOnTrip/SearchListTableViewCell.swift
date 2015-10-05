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
    
    // MARK: - 初始化相关
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        title.backgroundColor = UIColor(patternImage: UIImage(named: "searchCity_Button")!)
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blur.frame = title.frame
//        for v in self.bgImageView.subviews {
//            v.removeFromSuperview()
//        }
        title.layer.addSublayer(blur.layer)
//        title.backgroundColor!.addSubview(blur)
        
        addSubview(iconView)
        addSubview(title)
        addSubview(shade)
        addSubview(btn1)
        addSubview(btn2)
        addSubview(btn3)

        
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        iconView.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 190), offset: CGPointMake(0, 2))
        title.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: CGSizeMake(75, 33), offset: CGPointMake(0, 0))
        shade.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 26), offset: CGPointMake(0, 0))
        btn1.ff_AlignInner(ff_AlignType.CenterCenter, referView: shade, size: nil, offset: CGPointMake(90, 0))
        btn2.ff_AlignInner(ff_AlignType.CenterCenter, referView: shade, size: nil, offset: CGPointMake(0, 0))
        btn3.ff_AlignInner(ff_AlignType.CenterCenter, referView: shade, size: nil, offset: CGPointMake(-90, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
