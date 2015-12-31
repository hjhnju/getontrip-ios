//
//  RecommendTopicViewCell.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/13.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit
import FFAutoLayout

class RecommendTopicViewCell: UITableViewCell {
    
    // MARK: - 属性
    //底图
    var cellImageView = ScrolledImageView()
    
    //中部标题
    lazy var titleLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "", fontSize: 24, mutiLines: false, fontName: Font.PingFangTCMedium)

    //标签按钮
    lazy var tagButton: UIButton = UIButton(title: "", fontSize: 10, radius: 3, titleColor: UIColor.whiteColor())
    
    //点赞数
    lazy var favNumLabel: UIButton = UIButton(image: "praise_home", title: "", fontSize: 12, titleColor: SceneColor.white.colorWithAlphaComponent(0.7))

    //浏览数
    lazy var visitNumLabel: UIButton = UIButton(image: "search_visit", title: "", fontSize: 12, titleColor: SceneColor.white.colorWithAlphaComponent(0.7))
    
    /// 遮罩
    lazy var coverView: UIView = UIView(color: UIColor(hex: 0x686868, alpha: 0.5), alphaF: 0.7)
    
    var data: RecommendCellData? {
        didSet {
            if let cellData = data {
                cellImageView.backgroundColor = UIColor.whiteColor()
                cellImageView.imageView.backgroundColor = cellData.bgColor
                
                //是否加载网络图片
                if UserProfiler.instance.isShowImage() {
                    cellImageView.loadImage(NSURL(string: cellData.image))
                }
                
                titleLabel.text = cellData.name
                tagButton.setTitle("  " + cellData.param1 + "  ", forState: .Normal)
                favNumLabel.setTitle(" " + cellData.param2, forState: .Normal)
                visitNumLabel.setTitle(" " + cellData.param3, forState: .Normal)
            }
        }
    }
    
    // MARK: - 初始化相关
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //防止选择时白底
        backgroundColor = .clearColor()
        selectionStyle = .None
        
        tagButton.layer.borderWidth = 0.5
        tagButton.layer.borderColor = UIColor(hex: 0xFFFFFF, alpha: 0.8).CGColor
        tagButton.backgroundColor   = UIColor(hex: 0x696969, alpha: 0.65)
        tagButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        tagButton.layer.cornerRadius = 3
        tagButton.clipsToBounds = true
        
        contentView.addSubview(cellImageView)
        contentView.addSubview(coverView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tagButton)
        contentView.addSubview(favNumLabel)
        contentView.addSubview(visitNumLabel)
        
        cellImageView.userInteractionEnabled = false
        coverView.userInteractionEnabled     = false
        titleLabel.userInteractionEnabled    = false
        tagButton.userInteractionEnabled     = false
        favNumLabel.userInteractionEnabled   = false
        visitNumLabel.userInteractionEnabled = false
        
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .Center
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        cellImageView.ff_AlignInner(.TopLeft, referView: contentView, size: CGSizeMake(Frame.screen.width, RecommendContant.rowHeight - 2), offset: CGPointMake(0, 2))
        coverView.ff_Fill(contentView)
        titleLabel.ff_AlignInner(.CenterCenter, referView: contentView, size: nil, offset: CGPointMake(0, 0))
        tagButton.ff_AlignVertical(.TopCenter, referView: titleLabel, size: nil, offset: CGPointMake(0, -9))
        
        favNumLabel.ff_AlignInner(.BottomCenter, referView: cellImageView, size: nil, offset: CGPointMake(-20, -10))
        visitNumLabel.ff_AlignInner(.BottomCenter, referView: cellImageView, size: nil, offset: CGPointMake(20, -10))
        titleLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - (34 * 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
