//
//  HomeCityCententTopicCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class HomeCityCententTopicCell: UITableViewCell {

    /// 图片
    var iconView: UIImageView = UIImageView()
    /// 标题
    var title: UILabel = UILabel(color: UIColor.whiteColor(), title: "北京什么时候叫做燕京的？又是什么时候改回来的？", fontSize: 15, mutiLines: true)
    /// 副标题
    var subTitle: UILabel = UILabel(color: SceneColor.whiteGrey, title: "明末崇祯年间当时首都叫什么叫燕京还是北京", fontSize: 11, mutiLines: false)
    /// 标签
    var label: UILabel = UILabel(color: SceneColor.whiteGrey, title: "故宫历史", fontSize: 9, mutiLines: false)
    /// 浏览数
    var visit: UIButton = UIButton(title: "  100", fontSize: 9, radius: 0, titleColor: SceneColor.whiteGrey)
    /// 底线
    var baseView: UIView = UIView(color: UIColor.whiteColor(), alphaF: 0.3)
    
    var data: HomeTopic? {
        didSet {
            
            iconView.sd_setImageWithURL(NSURL(string: data!.image!))
            title.text = data!.title
            subTitle.text = data!.subtitle
            label.text = data!.tag
            visit.setTitle("   " + data!.visit!, forState: UIControlState.Normal)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(title)
        addSubview(label)
        addSubview(visit)
        addSubview(baseView)
        addSubview(iconView)
        addSubview(subTitle)
        
        backgroundColor = UIColor.clearColor()
        label.alpha = 0.5
        visit.setImage(UIImage(named: "visit_white"), forState: UIControlState.Normal)
        
        iconView.ff_AlignInner(ff_AlignType.CenterLeft, referView: self, size: CGSizeMake(124, 84), offset: CGPointMake(9, 0))
        subTitle.ff_AlignHorizontal(ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPointMake(6, 0))
        title.ff_AlignVertical(ff_AlignType.BottomLeft, referView: subTitle, size: nil, offset: CGPointMake(0, 5))
        label.ff_AlignHorizontal(ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPointMake(9, 0))
        visit.ff_AlignInner(ff_AlignType.BottomRight, referView: self, size: CGSizeMake(33, 11), offset: CGPointMake(-9, -10))
        baseView.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 19, 0.5), offset: CGPointMake(0, 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
