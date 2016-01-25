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
    /// 所在城市
    lazy var cityNameButton: UIButton = UIButton(title: "北京", fontSize: 12, radius: 0, titleColor: SceneColor.lightYellow, fontName: Font.PingFangSCRegular)
    lazy var cityNButton: UIButton = UIButton()
    var titleConBot: NSLayoutConstraint?
    var cityName1: NSLayoutConstraint?
    var cityName2: NSLayoutConstraint?
    /// 城市点击区域
    /// 父控制器
    weak var superViewController: RecommendHotController?
    
    var data: RecommendCellData? {
        didSet {
            if let cellData = data {
                cellImageView.backgroundColor = UIColor.whiteColor()
                cellImageView.imageView.backgroundColor = cellData.bgColor
                //是否加载网络图片
                if UserProfiler.instance.isShowImage() {
                    cellImageView.loadImage(NSURL(string: cellData.image))
                }
                
                titleButton.setTitle(cellData.name, forState: .Normal)
                getCollectStyle(cellData)
                locationButton.setTitle((" " + (data?.dis ?? "")), forState: .Normal)
                
                locationButton.hidden    = data?.dis == "" ? true : false
                locationUnitLabel.hidden = data?.dis == "" ? true : false

                let cons = titleButton.ff_AlignVertical(.TopLeft, referView: locationButton, size: nil, offset: CGPointMake(0, data?.dis == "" ? 31 : 5))
                locationButton.ff_AlignInner(.BottomLeft, referView: contentView, size: nil, offset: CGPointMake(9, -19))
                locationUnitLabel.ff_AlignHorizontal(.CenterRight, referView: locationButton, size: nil, offset: CGPointMake(1.5, 2))
                locationUnitLabel.text = data?.dis_unit
                titleConBot = titleButton.ff_Constraint(cons, attribute: .Bottom)
                let cityName = "  " + cellData.cityname + " "
                cityNameButton.setTitle(cityName, forState: .Normal)
                
                let w: CGFloat = cityName.sizeofStringWithFount1(UIFont(name: Font.PingFangSCRegular, size: 12) ?? UIFont.systemFontOfSize(12),
                    maxSize: CGSizeMake(CGFloat.max, 12)).width
                cityName1?.constant = w
                cityName2?.constant = w + 20
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
        contentView.addSubview(cityNameButton)
        contentView.addSubview(cityNButton)
        
        cellImageView.userInteractionEnabled = false
        shadeView.userInteractionEnabled = false
        titleButton.userInteractionEnabled = false
        cellImageView.clipsToBounds = true
        collectImage.contentMode = .ScaleAspectFill
        cityNameButton.backgroundColor = SceneColor.bgBlack
//        cityNameButton.addTarget(self, action: "cityNameButtonAction", forControlEvents: .TouchUpInside)
        cityNButton.addTarget(self, action: "cityNameButtonAction", forControlEvents: .TouchUpInside)
        
        setupAutoLayout()
    }
    
    
    private func setupAutoLayout() {
        cellImageView.ff_AlignInner(.TopLeft, referView: contentView, size: CGSizeMake(UIScreen.mainScreen().bounds.width, RecommendContant.rowHeight - 2), offset: CGPointMake(0, 2))
        shadeView.frame = CGRectMake(0, 0, Frame.screen.width, RecommendContant.rowHeight)
        contentLabel.ff_AlignInner(.BottomRight, referView: contentView, size: nil, offset: CGPointMake(-9, -19))
        contentImage.ff_AlignHorizontal(.BottomLeft, referView: contentLabel, size: CGSizeMake(10, 12), offset: CGPointMake(-7, 0))
        collectLabel.ff_AlignHorizontal(.BottomLeft, referView: contentImage, size: nil, offset: CGPointMake(-12, 0))
        collectImage.ff_AlignHorizontal(.BottomLeft, referView: collectLabel, size: CGSizeMake(10, 12), offset: CGPointMake(-7, -2))
        let cons1 = cityNameButton.ff_AlignInner(.TopRight, referView: contentView, size: CGSizeMake(43, 21), offset: CGPointMake(0, 19))
        let cons2 = cityNButton.ff_AlignInner(.TopRight, referView: contentView, size: CGSizeMake(43, 60))
        cityName1 = cityNameButton.ff_Constraint(cons1, attribute: .Width)
        cityName2 = cityNButton.ff_Constraint(cons2, attribute: .Width)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 城市名称标签方法
    func cityNameButtonAction() {
        let vc = CityViewController()
        let city = City(id: data?.cityid ?? "0")
        vc.cityDataSource = city
        Statistics.shareStatistics.event(Event.home_click_cityViewController_eid, labelStr: data?.cityid ?? "0")
        superViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
