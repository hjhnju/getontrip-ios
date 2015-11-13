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
    lazy var titleLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "", fontSize: 24, mutiLines: false)

    //标签按钮
    lazy var tagButton: UIButton = UIButton(title: "", fontSize: 10, radius: 3, titleColor: UIColor.whiteColor())
    
    //收藏数
    lazy var favNumLabel: UIButton = UIButton(image: "search_fav", title: "", fontSize: 12, titleColor: SceneColor.white.colorWithAlphaComponent(0.7))

    //浏览数
    lazy var visitNumLabel: UIButton = UIButton(image: "search_visit", title: "", fontSize: 12, titleColor: SceneColor.white.colorWithAlphaComponent(0.7))
    
    var data: RecommendCellData? {
        didSet {
            if let cellData = data {
                cellImageView.loadImage(NSURL(string: cellData.image))
                titleLabel.text = cellData.name
                tagButton.setTitle("  " + cellData.param1 + "  ", forState: UIControlState.Normal)
                favNumLabel.setTitle(" " + cellData.param2, forState: UIControlState.Normal)
                visitNumLabel.setTitle(" " + cellData.param3, forState: UIControlState.Normal)
            }
        }
    }
    
    // MARK: - 初始化相关
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //防止选择时白底
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        tagButton.layer.borderWidth = 0.5
        tagButton.layer.borderColor = UIColor(hex: 0xFFFFFF, alpha: 0.8).CGColor
        tagButton.backgroundColor   = SceneColor.fontGray
        tagButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        tagButton.layer.cornerRadius = 3
        tagButton.clipsToBounds = true
        
        addSubview(cellImageView)
        addSubview(titleLabel)
        addSubview(tagButton)
        addSubview(favNumLabel)
        addSubview(visitNumLabel)
        
        
        
        titleLabel.numberOfLines = 2
        titleLabel.userInteractionEnabled = false
        titleLabel.textAlignment = NSTextAlignment.Center
        cellImageView.userInteractionEnabled = false
        
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        cellImageView.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width, RecommendContant.rowHeight-2), offset: CGPointMake(0, 2))
        titleLabel.ff_AlignInner(ff_AlignType.CenterCenter, referView: self, size: nil, offset: CGPointMake(0, 0))
        tagButton.ff_AlignVertical(ff_AlignType.TopCenter, referView: titleLabel, size: nil, offset: CGPointMake(0, -9))
        
        favNumLabel.ff_AlignInner(ff_AlignType.BottomCenter, referView: cellImageView, size: nil, offset: CGPointMake(-20, -10))
        visitNumLabel.ff_AlignInner(ff_AlignType.BottomCenter, referView: cellImageView, size: nil, offset: CGPointMake(20, -10))
        
        titleLabel.preferredMaxLayoutWidth = self.bounds.width - 20
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}