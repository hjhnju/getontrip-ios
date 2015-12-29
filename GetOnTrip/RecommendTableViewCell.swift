//
//  SearchListTableViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class RecommendTableViewCell: UITableViewCell {

    // MARK: - 属性
    //底图
    var cellImageView = ScrolledImageView()
    
    //中部标题
    lazy var titleButton: UIButton = UIButton(title: "北京", fontSize: 16, radius: 5, titleColor: SceneColor.bgBlack)
    
    //底部遮罩
    lazy var shadeView: UIView = UIView(color: UIColor(hex: 0x686868, alpha: 0.5), alphaF: 0.7)
    
    /// 收藏按钮
    lazy var collectButton: UIButton = UIButton()
    
    /// 内容按钮
    lazy var contentButton: UIButton = UIButton()
    
    /// 当前位置 
    lazy var locationButton = UIButton(image: "location_search", title: "0.0km", fontSize: 13, titleColor: .whiteColor(), fontName: Font.PingFangSCLight)
    
    var data: RecommendCellData? {
        didSet {
            if let cellData = data {
                cellImageView.backgroundColor = UIColor.whiteColor()
                cellImageView.imageView.backgroundColor = cellData.bgColor
                //是否加载网络图片
                if UserProfiler.instance.isShowImage() {
                    cellImageView.loadImage(NSURL(string: cellData.image))
                }
                
                titleButton.setTitle("   " + cellData.name + "   ", forState: UIControlState.Normal)
                collectButton.setAttributedTitle(cellData.param3.getAttributedStringHeadCharacterBig(), forState: UIControlState.Normal)
                contentButton.setAttributedTitle(cellData.param1.getAttributedStringHeadCharacterBig(), forState: UIControlState.Normal)

                if cellData.isTypeCity() {
                    collectButton.setImage(UIImage(named: "search_star"), forState: UIControlState.Normal)
                    contentButton.setImage(UIImage(named: "search_sight"), forState: UIControlState.Normal)
                } else {//
                    collectButton.setImage(UIImage(named: "search_star"), forState: UIControlState.Normal)
                    contentButton.setImage(UIImage(named: "search_topic"), forState: UIControlState.Normal)
                }
            }
        }
    }
    
    // MARK: - 初始化相关
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //防止选择时白底
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        let titleFont = UIFont(name: SceneFont.heiti, size: 8)
        collectButton.titleLabel?.font = titleFont
        contentButton.titleLabel?.font = titleFont
        collectButton.titleLabel?.textColor = UIColor.whiteColor()
        contentButton.titleLabel?.textColor = UIColor.whiteColor()
        
        //addSubview(iconView)
        contentView.addSubview(cellImageView)
        contentView.addSubview(shadeView)
        contentView.addSubview(titleButton)
        contentView.addSubview(collectButton)
        contentView.addSubview(contentButton)
        contentView.addSubview(locationButton)
        
        cellImageView.userInteractionEnabled = false
        //iconView.userInteractionEnabled = false
        shadeView.userInteractionEnabled = false
        titleButton.userInteractionEnabled = false
        cellImageView.clipsToBounds = true
        
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        //iconView.ff_AlignInner(.TopLeft, referView: self, size: CGSizeMake(UIScreen.mainScreen().bounds.width, RecommendTableViewCell.RowHeight-2), offset: CGPointMake(0, 2))
        cellImageView.ff_AlignInner(.TopLeft, referView: contentView, size: CGSizeMake(UIScreen.mainScreen().bounds.width, RecommendContant.rowHeight - 2), offset: CGPointMake(0, -2))
        shadeView.frame = CGRectMake(0, 0, Frame.screen.width, RecommendContant.rowHeight)
        locationButton.ff_AlignInner(.BottomLeft, referView: contentView, size: nil, offset: CGPointMake(9, -19))
        contentButton.ff_AlignInner(.BottomRight, referView: contentView, size: nil, offset: CGPointMake(-9, -19))
        collectButton.ff_AlignHorizontal(.CenterLeft, referView: contentButton, size: nil, offset: CGPointMake(-12, 0))
        titleButton.ff_AlignHorizontal(.TopLeft, referView: locationButton, size: nil, offset: CGPointMake(0, 7))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
