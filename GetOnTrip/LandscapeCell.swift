//
//  LandscapeCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/3/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class LandscapeCell: UITableViewCell {
    
    lazy var iconView: UIImageView = UIImageView(image: UIImage())
    
    lazy var titleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 20, mutiLines: true)
    
    lazy var subtitleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 12, mutiLines: true)
    
    /// 标签底部view
    lazy var labelBottomBackground: UIView = UIView()
    /// 标签平均底view
    lazy var labelView1: UIView = UIView()
    
    lazy var labelView2: UIView = UIView()
    
    lazy var labelView3: UIView = UIView()
    
    lazy var labelView4: UIView = UIView()
    
    lazy var label1: UILabel = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.7), title: "建制沿革", fontSize: 10, mutiLines: true)
    
    lazy var label2: UILabel = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.7), title: "历史事件", fontSize: 10, mutiLines: true)
    
    lazy var label3: UILabel = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.7), title: "主要景点", fontSize: 10, mutiLines: true)
    
    lazy var label4: UILabel = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.7), title: "园藏文物", fontSize: 10, mutiLines: true)
    /// 垂直线
    lazy var vertical1: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.7)
    
    lazy var vertical2: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.7)
    
    lazy var vertical3: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.7)
    
    lazy var baseLine: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.3)
    
    var landscape: SightLandscape? {
        didSet {
            if let landscape = landscape {
                iconView.image = nil
                iconView.sd_setImageWithURL(NSURL(string: landscape.image), placeholderImage: PlaceholderImage.defaultSmall)
                titleLabel.text = landscape.name
                subtitleLabel.text = landscape.content
                for (var i: Int = 0; i < landscape.catalogs!.count; i++ ) {
                    let tagsLabel: String = landscape.catalogs![i] as! String
                    if (i == 0){
                        label1.text = tagsLabel
                    } else if(i == 1){
                        label2.text = tagsLabel
                    } else if (i == 2){
                        label3.text = tagsLabel
                    } else if(i == 3){
                        label4.text = tagsLabel
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupProperty()
        setupAutoLayout()
    }
    
    private func setupProperty() {
        backgroundColor = UIColor.clearColor()
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(labelBottomBackground)
        labelBottomBackground.addSubview(labelView1)
        labelBottomBackground.addSubview(labelView2)
        labelBottomBackground.addSubview(labelView3)
        labelBottomBackground.addSubview(labelView4)
        labelView1.addSubview(label1)
        labelView1.addSubview(vertical1)
        labelView2.addSubview(label2)
        labelView2.addSubview(vertical2)
        labelView3.addSubview(label3)
        labelView4.addSubview(vertical3)
        labelView4.addSubview(label4)
        addSubview(baseLine)
        
        subtitleLabel.numberOfLines = 2
        label1.textAlignment = NSTextAlignment.Center
        label2.textAlignment = NSTextAlignment.Center
        label3.textAlignment = NSTextAlignment.Center
        label4.textAlignment = NSTextAlignment.Center

    }
    
    private func setupAutoLayout() {
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 119 - 15 - 6
        iconView.ff_AlignInner(ff_AlignType.CenterRight, referView: self, size: CGSizeMake(119, 84), offset: CGPointMake(-9, 0))
        titleLabel.ff_AlignHorizontal(ff_AlignType.TopLeft, referView: iconView, size: CGSizeMake(w, 21), offset: CGPointMake(0, 0))
        subtitleLabel.ff_AlignVertical(ff_AlignType.BottomLeft, referView: titleLabel, size: CGSizeMake(w, 36), offset: CGPointMake(0, 0))
        labelBottomBackground.ff_AlignHorizontal(ff_AlignType.BottomLeft, referView: iconView, size: CGSizeMake(w - 9 , 10), offset: CGPointMake(-9, 0))
        labelBottomBackground.ff_HorizontalTile([labelView1, labelView2, labelView3, labelView4], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        label1.ff_AlignInner(ff_AlignType.CenterLeft, referView: labelView1, size: nil, offset: CGPointMake(0, 0))
        vertical1.ff_AlignInner(ff_AlignType.CenterRight, referView: labelView1, size: CGSizeMake(0.5, 10), offset: CGPointMake(-3, 0))
        label2.ff_AlignInner(ff_AlignType.CenterCenter, referView: labelView2, size:nil, offset: CGPointMake(0, 0))
        vertical2.ff_AlignInner(ff_AlignType.CenterRight, referView: labelView2, size: CGSizeMake(0.5, 10), offset: CGPointMake(0, 0))
        label3.ff_AlignInner(ff_AlignType.CenterCenter, referView: labelView3, size: nil, offset: CGPointMake(0, 0))
        label4.ff_AlignInner(ff_AlignType.CenterCenter, referView: labelView4, size: nil, offset: CGPointMake(0, 0))
        vertical3.ff_AlignInner(ff_AlignType.CenterLeft, referView: labelView4, size: CGSizeMake(0.5, 10), offset: CGPointMake(0, 0))
        baseLine.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LandscapeCell1: UITableViewCell {
    
    lazy var iconView: UIImageView = UIImageView(image: UIImage())
    
    lazy var titleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "颐和园", fontSize: 18, mutiLines: true)
    
    lazy var subtitleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "圆明园是坐落在北京西北郊，与颐和园相邻，由圆明园、长春园和万春园组成，也叫圆明三园…", fontSize: 12, mutiLines: true)
    
    /// 标签底部view
    lazy var labelBottomBackground: UIView = UIView()
    /// 标签平均底view
    lazy var labelView1: UIView = UIView()
    
    lazy var labelView2: UIView = UIView()
    
    lazy var labelView3: UIView = UIView()
    
    lazy var labelView4: UIView = UIView()
    
    lazy var label1: UILabel = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.7), title: "建制沿革", fontSize: 10, mutiLines: true)
    
    lazy var label2: UILabel = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.7), title: "历史事件", fontSize: 10, mutiLines: true)
    
    lazy var label3: UILabel = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.7), title: "主要景点", fontSize: 10, mutiLines: true)
    
    lazy var label4: UILabel = UILabel(color: UIColor(hex: 0x2A2D2E, alpha: 0.7), title: "园藏文物", fontSize: 10, mutiLines: true)
    /// 垂直线
    lazy var vertical1: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.7)
    
    lazy var vertical2: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.7)
    
    lazy var vertical3: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.7)
    
    lazy var baseLine: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.3)
    
    var landscape: SightLandscape? {
        didSet {
            if let landscape = landscape {
                iconView.sd_setImageWithURL(NSURL(string: landscape.image), placeholderImage:PlaceholderImage.defaultSmall)
                titleLabel.text = landscape.name
                subtitleLabel.text = landscape.content
                for (var i: Int = 0; i < landscape.catalogs!.count; i++ ) {
                    let tagsLabel: String = landscape.catalogs![i] as! String
                    if (i == 0){
                        label1.text = tagsLabel
                    } else if(i == 1){
                        label2.text = tagsLabel
                    } else if (i == 2){
                        label3.text = tagsLabel
                    } else if(i == 3){
                        label4.text = tagsLabel
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        setupProperty()
        setupAutoLayout()
    }
    
    private func setupProperty() {
        
        backgroundColor = UIColor.clearColor()
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(labelBottomBackground)
        labelBottomBackground.addSubview(labelView1)
        labelBottomBackground.addSubview(labelView2)
        labelBottomBackground.addSubview(labelView3)
        labelBottomBackground.addSubview(labelView4)
        labelView1.addSubview(label1)
        labelView1.addSubview(vertical1)
        labelView2.addSubview(label2)
        labelView2.addSubview(vertical2)
        labelView3.addSubview(label3)
        labelView4.addSubview(vertical3)
        labelView4.addSubview(label4)
        addSubview(baseLine)

        subtitleLabel.numberOfLines = 2
        label1.textAlignment = NSTextAlignment.Center
        label2.textAlignment = NSTextAlignment.Center
        label3.textAlignment = NSTextAlignment.Center
        label4.textAlignment = NSTextAlignment.Center
    }
    
    private func setupAutoLayout() {
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 119 - 15 - 9
        iconView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(119, 84), offset: CGPointMake(9, 0))
        titleLabel.ff_AlignHorizontal(ff_AlignType.TopRight, referView: iconView, size: CGSizeMake(w, 21), offset: CGPointMake(9, 0))
        subtitleLabel.ff_AlignVertical(ff_AlignType.BottomRight, referView: titleLabel, size: CGSizeMake(w, 36), offset: CGPointMake(0, 0))
        labelBottomBackground.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: iconView, size: CGSizeMake(w - 9 , 10), offset: CGPointMake(9, 0))
        labelBottomBackground.ff_HorizontalTile([labelView1, labelView2, labelView3, labelView4], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        label1.ff_AlignInner(ff_AlignType.CenterLeft, referView: labelView1, size: nil, offset: CGPointMake(0, 0))
        vertical1.ff_AlignInner(ff_AlignType.CenterRight, referView: labelView1, size: CGSizeMake(0.5, 10), offset: CGPointMake(-3, 0))
        label2.ff_AlignInner(ff_AlignType.CenterCenter, referView: labelView2, size: nil, offset: CGPointMake(0, 0))
        vertical2.ff_AlignInner(ff_AlignType.CenterRight, referView: labelView2, size: CGSizeMake(0.5, 10), offset: CGPointMake(0, 0))
        label3.ff_AlignInner(ff_AlignType.CenterCenter, referView: labelView3, size: nil, offset: CGPointMake(0, 0))
        label4.ff_AlignInner(ff_AlignType.CenterCenter, referView: labelView4, size: nil, offset: CGPointMake(0, 0))
        vertical3.ff_AlignInner(ff_AlignType.CenterLeft, referView: labelView4, size: CGSizeMake(0.5, 10), offset: CGPointMake(0, 0))
        baseLine.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
