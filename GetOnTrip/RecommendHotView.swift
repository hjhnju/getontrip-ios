//
//  RecommendHotView.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/27.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class RecommendHotView: UIView {
    
    lazy var hotContentButton: UIButton = UIButton(title: "热门内容", fontSize: 17, radius: 0, titleColor: SceneColor.shallowWhiteGrey, fontName: Font.PingFangSCLight)
    
    lazy var hotSightButton: UIButton = UIButton(title: "推荐景点", fontSize: 17, radius: 0, titleColor: SceneColor.shallowWhiteGrey, fontName: Font.PingFangSCLight)
    
    lazy var topLine: UIView = UIView(color: SceneColor.lightYellow)
    
    lazy var selectView: UIView = UIView(color: SceneColor.lightYellow)
    
    var selectViewX: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = SceneColor.bgBlack
        addSubview(topLine)
        addSubview(selectView)
        addSubview(hotContentButton)
        addSubview(hotSightButton)
        
        hotContentButton.setTitleColor(SceneColor.lightYellow, forState: .Selected)
        hotSightButton.setTitleColor(SceneColor.lightYellow, forState: .Selected)
        hotContentButton.selected = true
        
        let w: CGFloat = UIScreen.mainScreen().bounds.width * 0.5
        hotContentButton.ff_AlignInner(.CenterLeft, referView: self, size: CGSizeMake(w, 45))
        hotSightButton.ff_AlignInner(.CenterRight, referView: self, size: CGSizeMake(w, 45))
        topLine.ff_AlignInner(.TopLeft, referView: self, size: CGSizeMake(w * 2, 0.5))
        selectView.frame = CGRectMake(0, 0, w, 3)
//        let cons = selectView.ff_AlignInner(.TopLeft, referView: self, size: CGSizeMake(w, 3))
//        selectViewX = selectView.ff_Constraint(cons, attribute: .CenterX)
        
        hotContentButton.tag = 3
        hotSightButton.tag = 4
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
