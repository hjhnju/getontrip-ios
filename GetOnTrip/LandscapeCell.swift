//
//  LandscapeCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/3/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class LandscapeCell1: UITableViewCell {
    
    lazy var iconView: UIImageView = UIImageView(image: UIImage())
    
    lazy var titleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 20, mutiLines: true)
    
    lazy var subtitleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 12, mutiLines: true)
    
    lazy var baseLine: UIView = UIView(color: SceneColor.shallowGrey, alphaF: 0.3)
    
    var superNavigation: UINavigationController?
    
    var landscape: Landscape? {
        didSet {
            if let landscape = landscape {
                iconView.image = nil
                iconView.sd_setImageWithURL(NSURL(string: landscape.image), placeholderImage: PlaceholderImage.defaultSmall)
                titleLabel.text = landscape.name
                subtitleLabel.attributedText = landscape.content.getAttributedString(0, lineSpacing: 7, breakMode: NSLineBreakMode.ByTruncatingTail)
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
        addSubview(baseLine)
        
        subtitleLabel.numberOfLines  = 3
        iconView.contentMode         = UIViewContentMode.ScaleAspectFill
        iconView.clipsToBounds       = true
    }
    
    private func setupAutoLayout() {
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width - 119 - 15 - 6
        iconView.ff_AlignInner(.CenterRight, referView: self, size: CGSizeMake(119, 84), offset: CGPointMake(-9, 0))
        titleLabel.ff_AlignHorizontal(.TopLeft, referView: iconView, size: CGSizeMake(w, 21), offset: CGPointMake(0, 0))
        subtitleLabel.ff_AlignVertical(.BottomLeft, referView: titleLabel, size: CGSizeMake(w - 10, 57), offset: CGPointMake(0, 5))
        baseLine.ff_AlignInner(.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5), offset: CGPointMake(0, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
}

class LandscapeCell: LandscapeCell1 {
    
    override var landscape: Landscape? {
        didSet {
            if let landscape = landscape {
                
                iconView.sd_setImageWithURL(NSURL(string: landscape.image), placeholderImage: PlaceholderImage.defaultSmall, completed: { (image, error, cacheType, url) -> Void in
                    if image != nil {
                        self.iconView.image = UIImageView.imageByApplyingImage(image, blurRadius: 0.14577)
                    }
                })
                titleLabel.text = landscape.name
                subtitleLabel.attributedText = landscape.content.getAttributedString(0, lineSpacing: 7, breakMode: NSLineBreakMode.ByTruncatingTail)
            }
        }
    }
    
    /// 图片模糊
    lazy var coverView = UIView(color: UIColor.blackColor())
    
    override func setupAutoLayout() {
        initProperty()
        iconView.ff_AlignInner(.CenterCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width + 20, 140 + 20))
        coverView.ff_AlignInner(.CenterCenter, referView: iconView, size: CGSizeMake(UIScreen.mainScreen().bounds.width + 20, 140 + 20))
        titleLabel.ff_AlignInner(.TopCenter, referView: self, size: nil, offset: CGPointMake(0, 17))
        subtitleLabel.ff_AlignInner(.TopLeft, referView: self, size: nil, offset: CGPointMake(38, 53))
    }
    
    /// 初始化相关属性
    private func initProperty() {
        iconView.addSubview(coverView)
        coverView.alpha = 0.4
        clipsToBounds = true
        
        titleLabel.textColor    = UIColor.whiteColor()
        subtitleLabel.textColor = UIColor.whiteColor()
        subtitleLabel.numberOfLines = 3
        subtitleLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 76
        baseLine.hidden = true
        iconView.contentMode = .ScaleAspectFit
        if #available(iOS 9.0, *) {
            titleLabel.font = UIFont(name: Font.PingFangSCRegular, size: 22)
            subtitleLabel.font = UIFont(name: Font.PingFangSCRegular, size: 14)
        } else {
            titleLabel.font = UIFont.systemFontOfSize(22)
            subtitleLabel.font = UIFont.systemFontOfSize(14)
        }
    }
}
