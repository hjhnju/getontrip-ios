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
    lazy var titleButton: UIButton = UIButton(title: "北京", fontSize: 20, radius: 0, titleColor: .whiteColor(), fontName: Font.PingFangTCMedium)
    
    //底部遮罩
    lazy var shadeView: UIView = UIView(color: UIColor(hex: 0x686868, alpha: 0.3), alphaF: 0.6)
    
    /// 收藏按钮
    lazy var collectLabel: UILabel = UILabel()
    lazy var collectImage: UIImageView = UIImageView(image: UIImage(named: "collect_hotSight"))
    
    /// 内容按钮
    lazy var contentLabel: UILabel = UILabel()
    lazy var contentImage: UIImageView = UIImageView(image: UIImage(named: "content_hotSight"))
    
    /// 当前位置 
    lazy var locationButton = UIButton(image: "location_search", title: "  0.0", fontSize: 13, titleColor: .whiteColor(), fontName: Font.PingFangSCLight)
    
    /// 位置单位
    lazy var locationUnitLabel = UILabel(color: .whiteColor(), title: "", fontSize: 10, mutiLines: true, fontName: Font.PingFangSCLight)
    
    var titleConBot: NSLayoutConstraint?
    
    var data: RecommendCellData? {
        didSet {
            if let cellData = data {
                cellImageView.backgroundColor = UIColor.whiteColor()
                cellImageView.imageView.backgroundColor = cellData.bgColor
                //是否加载网络图片
                if UserProfiler.instance.isShowImage() {
                    cellImageView.loadImage(NSURL(string: cellData.image))
                }
                
                titleButton.setTitle(cellData.name, forState: UIControlState.Normal)
                getCollectStyle(cellData)
                locationButton.setTitle((" " + (data?.dis ?? "")), forState: UIControlState.Normal)
                
                locationButton.hidden    = data?.dis == "" ? true : false
                locationUnitLabel.hidden = data?.dis == "" ? true : false

                let cons = titleButton.ff_AlignVertical(.TopLeft, referView: locationButton, size: nil, offset: CGPointMake(0, data?.dis == "" ? 31 : 5))
                locationButton.ff_AlignInner(.BottomLeft, referView: contentView, size: nil, offset: CGPointMake(9, -19))
                locationUnitLabel.ff_AlignHorizontal(.CenterRight, referView: locationButton, size: nil, offset: CGPointMake(1.5, 2))
                locationUnitLabel.text = data?.dis_unit
                titleConBot = titleButton.ff_Constraint(cons, attribute: .Bottom)
            }
        }
    }
    
    private func getCollectStyle(cellData: RecommendCellData) {
        let attr = NSMutableAttributedString(attributedString: cellData.param3.getAttributedStringHeadCharacterBig())
        attr.appendAttributedString(NSAttributedString(string: "    |"))
        collectLabel.attributedText = attr
        contentLabel.attributedText = cellData.param1.getAttributedStringHeadCharacterBig()
    }
    
    // MARK: - 初始化相关
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //防止选择时白底
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        let titleFont = UIFont(name: SceneFont.heiti, size: 8)
        collectLabel.font = titleFont
        contentLabel.font = titleFont
        collectLabel.textColor = .whiteColor()
        contentLabel.textColor = .whiteColor()
        
        //addSubview(iconView)
        contentView.addSubview(cellImageView)
        contentView.addSubview(shadeView)
        contentView.addSubview(titleButton)
        contentView.addSubview(collectLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(locationButton)
        contentView.addSubview(collectImage)
        contentView.addSubview(contentImage)
        contentView.addSubview(locationUnitLabel)
        
        cellImageView.userInteractionEnabled = false
        shadeView.userInteractionEnabled = false
        titleButton.userInteractionEnabled = false
        cellImageView.clipsToBounds = true
        collectImage.contentMode = .ScaleAspectFill
        
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        cellImageView.ff_AlignInner(.TopLeft, referView: contentView, size: CGSizeMake(UIScreen.mainScreen().bounds.width, RecommendContant.rowHeight - 2), offset: CGPointMake(0, 2))
        shadeView.frame = CGRectMake(0, 0, Frame.screen.width, RecommendContant.rowHeight)
        contentLabel.ff_AlignInner(.BottomRight, referView: contentView, size: nil, offset: CGPointMake(-9, -19))
        contentImage.ff_AlignHorizontal(.BottomLeft, referView: contentLabel, size: CGSizeMake(10, 12), offset: CGPointMake(-7, 0))
        collectLabel.ff_AlignHorizontal(.BottomLeft, referView: contentImage, size: nil, offset: CGPointMake(-12, 0))
        collectImage.ff_AlignHorizontal(.BottomLeft, referView: collectLabel, size: CGSizeMake(10, 12), offset: CGPointMake(-7, -2))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
