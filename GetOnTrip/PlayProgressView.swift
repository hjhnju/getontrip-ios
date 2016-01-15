//
//  PlayProgressView.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/13.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class PlayProgressView: UIView {

    /// 现在的时间标志
    lazy var currentTimeLabel = UILabel(color: SceneColor.frontBlack, title: "00.00", fontSize: 12, mutiLines: true, fontName: Font.HelveticaNeueThin)
    /// 总共时间
    lazy var entirelyTimeLabel = UILabel(color: SceneColor.frontBlack, title: "00.00", fontSize: 12, mutiLines: true, fontName: Font.HelveticaNeueThin)
    /// 进度底view
    lazy var progressBottomView = UIView(color: UIColor(hex: 0xD5D5D7, alpha: 1.0))
    /// 进度中view
    lazy var progressView = UIView(color: .blackColor(), alphaF: 0.5)
    /// 进度播放按钮
    lazy var playProgressButten = UIButton(image: "sight_landscape_playProgress", title: "", fontSize: 0)
    /// 进度中宽度
    var progressW: NSLayoutConstraint?
    /// 播放按钮x
    var playProgressX: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        initAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        addSubview(currentTimeLabel)
        addSubview(entirelyTimeLabel)
        addSubview(progressBottomView)
        progressBottomView.addSubview(progressView)
        addSubview(playProgressButten)
        
        currentTimeLabel.text = "00:00"
        entirelyTimeLabel.text = "99:00"
    }
    
    private func initAutoLayout() {
        currentTimeLabel.ff_AlignInner(.CenterLeft, referView: self, size: nil)
        entirelyTimeLabel.ff_AlignInner(.CenterRight, referView: self, size: nil)
        progressBottomView.ff_AlignInner(.CenterCenter, referView: self, size: CGSizeMake(Frame.screen.width - 85 * 2, 1.62))
        let cons = progressView.ff_AlignInner(.CenterLeft, referView: progressBottomView, size: CGSizeMake(0, 1.62))
        progressW = progressView.ff_Constraint(cons, attribute: .Width)
        playProgressButten.ff_AlignInner(.CenterRight, referView: progressView, size: CGSizeMake(14, 14))
    }
}
