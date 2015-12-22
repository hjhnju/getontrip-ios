//
//  SettingDatumTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit



class SettingDatumTableViewCell: UITableViewCell {
    
    var currentRow: Int = 0 {
        didSet {
            if currentRow == 0 {
                leftButton.setImage(UIImage(named: "collect_my"), forState: .Normal)
                leftButton.setImage(UIImage(named: "collect_my"), forState: .Disabled)
                leftButton.setTitle("  我的收藏", forState: .Normal)
                baseLine.hidden = false
            } else if currentRow == 1 {
                leftButton.setImage(UIImage(named: "commit_my"), forState: .Normal)
                leftButton.setImage(UIImage(named: "commit_my"), forState: .Disabled)
                leftButton.setTitle("  我的评论", forState: .Normal)
                baseLine.hidden = true
            } else if currentRow == 2 {
                leftButton.setImage(UIImage(named: "photo_my"), forState: .Normal)
                leftButton.setImage(UIImage(named: "photo_my"), forState: .Disabled)
                leftButton.setTitle("  我的图册", forState: .Normal)
                baseLine.hidden = true
            }
        }
    }

    private lazy var leftButton = UIButton(image: "collect_my", title: "  我的收藏", fontSize: 16, titleColor: SceneColor.frontBlack, fontName: Font.PingFangSCLight)
    
    internal lazy var rightImageView = UIImageView(image: UIImage(named: "arrowhead_my")!)
    
    lazy var baseLine = UIView(color: SceneColor.darkGrey)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        baseLine.hidden = true
        contentView.addSubview(leftButton)
        contentView.addSubview(baseLine)
        contentView.addSubview(rightImageView)
        leftButton.enabled = false
        leftButton.ff_AlignInner(.CenterLeft, referView: contentView, size: nil, offset: CGPointMake(9, 0))
        baseLine.ff_AlignInner(.BottomCenter, referView: contentView, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5))
        rightImageView.ff_AlignInner(.CenterRight, referView: contentView, size: nil, offset: CGPointMake(-10, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {

    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }

}
