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
    
    lazy var label1: UIButton = UIButton(title: "", fontSize: 10, radius: 0, titleColor: UIColor(hex: 0x2A2D2E, alpha: 0.7))
    
    lazy var label2: UIButton = UIButton(title: "", fontSize: 10, radius: 0, titleColor: UIColor(hex: 0x2A2D2E, alpha: 0.7))
    
    lazy var label3: UIButton = UIButton(title: "", fontSize: 10, radius: 0, titleColor: UIColor(hex: 0x2A2D2E, alpha: 0.7))
    
    lazy var label4: UIButton = UIButton(title: "", fontSize: 10, radius: 0, titleColor: UIColor(hex: 0x2A2D2E, alpha: 0.7))
    /// 垂直线
    lazy var vertical1: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.7)
    
    lazy var vertical2: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.7)
    
    lazy var vertical3: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.7)
    
    lazy var baseLine: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.3)
    
    var superNavigation: UINavigationController?
    
    var landscape: Landscape? {
        didSet {
            if let landscape = landscape {
                iconView.image = nil
                iconView.sd_setImageWithURL(NSURL(string: landscape.image), placeholderImage: PlaceholderImage.defaultSmall)
                titleLabel.text = landscape.name
                subtitleLabel.attributedText = landscape.content.getAttributedString(0, lineSpacing: 7, breakMode: NSLineBreakMode.ByTruncatingTail)
                
                var index: Int = 0
                
                for (name, _) in landscape.catalogs {
                    if index == 0 { label1.setTitle(name, forState: .Normal)}
                    if index == 1 { label2.setTitle(name, forState: .Normal)}
                    if index == 2 { label3.setTitle(name, forState: .Normal)}
                    if index == 3 { label4.setTitle(name, forState: .Normal)}
                    index += 1
                }
                
                if label2.titleLabel?.text == nil {
                    vertical1.hidden = true
                }
                if label3.titleLabel?.text == nil {
                    vertical2.hidden = true
                }
                if label4.titleLabel?.text == nil {
                    vertical3.hidden = true
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
        
        label1.titleLabel?.adjustsFontSizeToFitWidth = true
        label2.titleLabel?.adjustsFontSizeToFitWidth = true
        label3.titleLabel?.adjustsFontSizeToFitWidth = true
        label4.titleLabel?.adjustsFontSizeToFitWidth = true
        
        label1.tag = 1
        label2.tag = 2
        label3.tag = 3
        label4.tag = 4
        
        subtitleLabel.numberOfLines      = 2
        label1.titleLabel!.textAlignment = NSTextAlignment.Center
        label2.titleLabel!.textAlignment = NSTextAlignment.Center
        label3.titleLabel!.textAlignment = NSTextAlignment.Center
        label4.titleLabel!.textAlignment = NSTextAlignment.Center
        iconView.contentMode             = UIViewContentMode.ScaleAspectFill
        iconView.clipsToBounds           = true
        
        label1.addTarget(self, action: "labelCorrespondingAction:", forControlEvents: .TouchUpInside)
        label2.addTarget(self, action: "labelCorrespondingAction:", forControlEvents: .TouchUpInside)
        label3.addTarget(self, action: "labelCorrespondingAction:", forControlEvents: .TouchUpInside)
        label4.addTarget(self, action: "labelCorrespondingAction:", forControlEvents: .TouchUpInside)
    }
    
    private func setupAutoLayout() {
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 119 - 15 - 6
        iconView.ff_AlignInner(ff_AlignType.CenterRight, referView: self, size: CGSizeMake(119, 84), offset: CGPointMake(-9, 0))
        titleLabel.ff_AlignHorizontal(ff_AlignType.TopLeft, referView: iconView, size: CGSizeMake(w, 21), offset: CGPointMake(0, 0))
        subtitleLabel.ff_AlignVertical(ff_AlignType.BottomLeft, referView: titleLabel, size: CGSizeMake(w - 10, 50), offset: CGPointMake(0, 5))
        labelBottomBackground.ff_AlignHorizontal(ff_AlignType.BottomLeft, referView: iconView, size: CGSizeMake(w - 9 , 10), offset: CGPointMake(-9, 0))
        labelBottomBackground.ff_HorizontalTile([labelView1, labelView2, labelView3, labelView4], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        label1.ff_AlignInner(ff_AlignType.CenterLeft, referView: labelView1, size: nil, offset: CGPointMake(0, 0))
        vertical1.ff_AlignInner(ff_AlignType.CenterRight, referView: labelView1, size: CGSizeMake(0.5, 10), offset: CGPointMake(-10, 0))
        label2.ff_AlignInner(ff_AlignType.CenterCenter, referView: labelView2, size:nil, offset: CGPointMake(-5, 0))
        vertical2.ff_AlignInner(ff_AlignType.CenterRight, referView: labelView2, size: CGSizeMake(0.5, 10), offset: CGPointMake(0, 0))
        label3.ff_AlignInner(ff_AlignType.CenterCenter, referView: labelView3, size: nil, offset: CGPointMake(5, 0))
        label4.ff_AlignInner(ff_AlignType.CenterRight, referView: labelView4, size: nil, offset: CGPointMake(0, 0))
        vertical3.ff_AlignInner(ff_AlignType.CenterLeft, referView: labelView4, size: CGSizeMake(0.5, 10), offset: CGPointMake(10, 0))
        baseLine.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }
    
    ///  标签跳转对应链接的方法
    func labelCorrespondingAction(btn: UIButton) {

        let sc = DetailWebViewController()
        let array = Array(landscape!.catalogs.values)
        sc.url = landscape!.url + array[btn.tag - 1]! ?? ""
        sc.title = landscape!.name
        superNavigation?.pushViewController(sc, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}

class LandscapeCell1: LandscapeCell {
    
    override func setupAutoLayout() {
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 119 - 15 - 9
        iconView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(119, 84), offset: CGPointMake(9, 0))
        titleLabel.ff_AlignHorizontal(ff_AlignType.TopRight, referView: iconView, size: CGSizeMake(w, 21), offset: CGPointMake(9, 0))
        subtitleLabel.ff_AlignVertical(ff_AlignType.BottomRight, referView: titleLabel, size: CGSizeMake(w, 50), offset: CGPointMake(0, 0))
        labelBottomBackground.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: iconView, size: CGSizeMake(w - 9 , 10), offset: CGPointMake(9, 0))
        labelBottomBackground.ff_HorizontalTile([labelView1, labelView2, labelView3, labelView4], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        label1.ff_AlignInner(ff_AlignType.CenterLeft, referView: labelView1, size: nil, offset: CGPointMake(0, 0))
        vertical1.ff_AlignInner(ff_AlignType.CenterRight, referView: labelView1, size: CGSizeMake(0.5, 10), offset: CGPointMake(-10, 0))
        label2.ff_AlignInner(ff_AlignType.CenterCenter, referView: labelView2, size: nil, offset: CGPointMake(-5, 0))
        vertical2.ff_AlignInner(ff_AlignType.CenterRight, referView: labelView2, size: CGSizeMake(0.5, 10), offset: CGPointMake(0, 0))
        label3.ff_AlignInner(ff_AlignType.CenterCenter, referView: labelView3, size: nil, offset: CGPointMake(5, 0))
        label4.ff_AlignInner(ff_AlignType.CenterRight, referView: labelView4, size: nil, offset: CGPointMake(0, 0))
        vertical3.ff_AlignInner(ff_AlignType.CenterLeft, referView: labelView4, size: CGSizeMake(0.5, 10), offset: CGPointMake(10, 0))
        baseLine.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }
}
