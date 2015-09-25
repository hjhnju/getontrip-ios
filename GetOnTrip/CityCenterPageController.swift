//
//  CityCenterPageController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class CityCenterPageController: BaseHomeController {

    // MARK: - 属性
    /// 城市背影图片
    lazy var cityBackground: UIImageView = UIImageView()
    
    /// 地标图标
    lazy var pilotingIcon: UIImageView = UIImageView(image: UIImage(named: "current_location"))
    
    /// 城市名
    lazy var cityName: UILabel = UILabel(color: UIColor.whiteColor(), fontSize: 26, mutiLines: true)
    
    /// 收藏按钮
    lazy var collectBtn: UIButton = UIButton(title: "+ 收藏", fontSize: 14, radius: 10)
    
    /// 热门景点
//    lazy var sightBottomView: UIView = UIView(color: SceneColor.sightGrey, alphaF: 1.0)
//    
//    /// 热点景点文字
//    lazy var sightLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "热门景点", fontSize: 14)
//    
//    /// 热门景点图标
//    lazy var sightIcon: UIButton = UIButton(icon: "", masksToBounds: false)
    
    /// 热门景点内容
//    lazy var sightCollectionView: UICollectionView = {
//        let sight = UICollectionView()
//        return sight
//    }()
//    
//    /// 热门内容
//    lazy var contentTableView: UITableView = {
//        let table = UITableView()
//        return table
//    }()
    
    // MARK: - 初始化相关内容
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddProperty()
        setupAutoLayout()
        cityBackground.image = UIImage(named: "2.jpg")
    }
    
    /// 添加控件
    private func setupAddProperty() {
        
        view.addSubview(cityBackground)
        view.addSubview(pilotingIcon)
        view.addSubview(cityName)
        view.addSubview(collectBtn)
//        view.addSubview(sightCollectionView)
//        view.addSubview(contentTableView)
        
        collectBtn.layer.borderWidth = 1.0
        collectBtn.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    /// 设置布局
    private func setupAutoLayout() {
        
        cityBackground.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, 198), offset: CGPointMake(0, 0))
        pilotingIcon.ff_AlignInner(ff_AlignType.BottomLeft, referView: cityBackground, size: nil, offset: CGPointMake(-9, -13))
        cityName.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: pilotingIcon, size: nil, offset: CGPointMake(-8, 0))
        collectBtn.ff_AlignInner(ff_AlignType.BottomRight, referView: cityBackground, size: CGSizeMake(57, 29), offset: CGPointMake(-9, -10))
    }
    
    
}
