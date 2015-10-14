//
//  SearchListTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class SearchRecommendTableViewCell: UITableViewCell {
    
    static let RowHeight:CGFloat = 192

    // MARK: - 属性
    //底图
    lazy var iconView: UIImageView = UIImageView()
    
    //中部标题
    lazy var title: UIButton = UIButton(title: "北京", fontSize: 16, radius: 5, titleColor: SceneColor.bgBlack)
    
    //标题底
    lazy var titleBackgroud: UIView = UIView(color: UIColor.whiteColor(), alphaF: 0.5)
    
    //底部遮罩
    lazy var shade: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.5)
    
    //按钮1
    lazy var btn1: UIButton = UIButton()
    
    //按钮2
    lazy var btn2: UIButton = UIButton()
    
    //按钮3
    lazy var btn3: UIButton = UIButton()
    
    lazy var effect = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
    
    var data: RecommendCellData? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: data!.image!))
            title.setTitle("   " + data!.name + "   ", forState: UIControlState.Normal)
            btn1.setTitle(" " + data!.param1, forState: UIControlState.Normal)
            btn2.setTitle(" " + data!.param2, forState: UIControlState.Normal)
            btn3.setTitle(" " + data!.param3, forState: UIControlState.Normal)
            
            if data!.isTypeCity() {
                btn1.setImage(UIImage(named: "search_sight"), forState: UIControlState.Normal)
                btn2.setImage(UIImage(named: "search_topic"), forState: UIControlState.Normal)
                btn3.setImage(UIImage(named: "search_fav"), forState: UIControlState.Normal)
            } else {
                btn1.setImage(UIImage(named: "search_topic"), forState: UIControlState.Normal)
                btn2.setImage(UIImage(named: "search_comment"), forState: UIControlState.Normal)
                btn3.setImage(UIImage(named: "search_fav"), forState: UIControlState.Normal)
            }
        }
    }
    
    // MARK: - 初始化相关
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //防止选择时白底
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        let titleFont = UIFont(name: SceneFont.heiti, size: 10)
        btn1.titleLabel?.font = titleFont
        btn2.titleLabel?.font = titleFont
        btn3.titleLabel?.font = titleFont
        btn1.titleLabel?.textColor = UIColor.whiteColor()
        btn2.titleLabel?.textColor = UIColor.whiteColor()
        btn3.titleLabel?.textColor = UIColor.whiteColor()
        
        addSubview(iconView)
        addSubview(titleBackgroud)
        addSubview(effect)
        addSubview(title)
        addSubview(shade)
        addSubview(btn1)
        addSubview(btn2)
        addSubview(btn3)
        
        iconView.userInteractionEnabled = false
        effect.userInteractionEnabled = false
        shade.userInteractionEnabled = false
        titleBackgroud.userInteractionEnabled = false
        title.userInteractionEnabled = false
        
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        iconView.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width, SearchRecommendTableViewCell.RowHeight-2), offset: CGPointMake(0, 2))
        title.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
        shade.ff_AlignInner(ff_AlignType.BottomCenter, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 26), offset: CGPointMake(0, 0))
        btn1.ff_AlignInner(ff_AlignType.CenterCenter, referView: shade, size: nil, offset: CGPointMake(-80, 0))
        btn2.ff_AlignInner(ff_AlignType.CenterCenter, referView: shade, size: nil, offset: CGPointMake(0, 0))
        btn3.ff_AlignInner(ff_AlignType.CenterCenter, referView: shade, size: nil, offset: CGPointMake(80, 0))
        titleBackgroud.ff_AlignInner(ff_AlignType.CenterCenter, referView: title, size: CGSizeMake(title.bounds.width, title.bounds.height), offset: CGPointMake(0, 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleBackgroud.frame = title.frame
        effect.frame = title.frame
        effect.layer.cornerRadius = 10
        effect.clipsToBounds = true
        titleBackgroud.layer.cornerRadius = 10
        titleBackgroud.clipsToBounds = true
    }
}
