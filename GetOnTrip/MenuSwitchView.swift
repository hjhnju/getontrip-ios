//
//  MenuSwitchView.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/5.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class MenuSwitchView: UIView {
    
    // TODO: - 需要要使用该类必须实现selectSwitchAction:方法
    weak var superController: UIViewController?
    
    static let sharedMenuSwitchView = MenuSwitchView()
    
    /// 初始点
    var originPoint: CGPoint = CGPointZero {
        didSet {
            containerView.frame  = CGRectMake(originPoint.x, originPoint.y, 0, 0)
        }
    }
    /// 退出按钮
    lazy var exitButton: UIButton = UIButton()
    /// 容器view
    lazy var containerView: UIView = UIView()
    /// 底部图片
    lazy var bottomImageView: UIImageView = UIImageView(image: UIImage(named: "spring_sight"))
    /// 切换城市
    lazy var switchCityButton: UIButton = UIButton(image: "", title: "", fontSize: 16, titleColor: SceneColor.fontGray, fontName: Font.PingFangSCLight)
    /// 是否收藏
    lazy var collectButton: UIButton = UIButton(image: "", title: "", fontSize: 16, titleColor: SceneColor.fontGray, fontName: Font.PingFangSCLight)
    /// 基线
    lazy var baseLine: UIView = UIView(color: SceneColor.greyThinWhite, alphaF: 0.5)
    /// 数据源
    var dataSource: [MenuSwitchModel] = [MenuSwitchModel]() {
        didSet {
            switchCityButton.setTitle(dataSource[0].title, forState: .Normal)
            switchCityButton.setImage(UIImage(named: dataSource[0].image), forState: .Normal)
            collectButton.setTitle(dataSource[1].title, forState: .Normal)
            collectButton.setImage(UIImage(named: dataSource[1].image), forState: .Normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(exitButton)
        
        exitButton.ff_Fill(self)
        exitButton.addTarget(self, action: "exitAction", forControlEvents: .TouchUpInside)

        addSubview(containerView)
        containerView.addSubview(bottomImageView)
        bottomImageView.ff_Fill(containerView)
        
        containerView.addSubview(switchCityButton)
        containerView.addSubview(collectButton)
        containerView.addSubview(baseLine)
        baseLine.ff_AlignInner(.CenterCenter, referView: containerView, size: CGSizeMake(131, 0.5), offset: CGPointMake(0, 5))
        switchCityButton.tag = 1
        collectButton.tag    = 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 显示选择方法
    func showSwitchAction(superViewController: UIViewController, initPoint: CGPoint) {
        superController = superViewController
        originPoint = initPoint
        let mv = MenuSwitchView.sharedMenuSwitchView
        mv.frame = Frame.screen
        superViewController.view.addSubview(mv)
        mv.containerView.frame = CGRectMake(originPoint.x, originPoint.y, 0, 0)
        mv.containerView.clipsToBounds = true
        UIView.animateWithDuration(0.5, animations: { [weak self] () -> Void in
            mv.containerView.frame = CGRectMake(Frame.screen.width - 149, self?.originPoint.y ?? 0, 140, 104)
            self?.switchCityButton.frame = CGRectMake(0, 10, 140, 46)
            self?.collectButton.frame = CGRectMake(0, 56, 140, 46)
            }) { (_) -> Void in
                 mv.containerView.clipsToBounds = false
        }
    }
    
    /// 退出方法
    func exitAction() {
        MenuSwitchView.sharedMenuSwitchView.containerView.clipsToBounds = false
        MenuSwitchView.sharedMenuSwitchView.containerView.frame = CGRectMake(Frame.screen.width - 80, originPoint.y, 140, 104)
        MenuSwitchView.sharedMenuSwitchView.bottomImageView.frame = CGRectMake(Frame.screen.width - 80, originPoint.y, 140, 104)
        
        UIView.animateWithDuration(0.5, animations: { [weak self] () -> Void in
            MenuSwitchView.sharedMenuSwitchView.containerView.frame = CGRectMake(self?.originPoint.x ?? 0, self?.originPoint.y ?? 0, 0, 0)
            MenuSwitchView.sharedMenuSwitchView.bottomImageView.frame = CGRectMake(self?.originPoint.x ?? 0, self?.originPoint.y ?? 0, 0, 0)
            MenuSwitchView.sharedMenuSwitchView.switchCityButton.frame = CGRectMake(self?.originPoint.x ?? 0, self?.originPoint.y ?? 0, 0, 0)
            MenuSwitchView.sharedMenuSwitchView.collectButton.frame = CGRectMake(self?.originPoint.x ?? 0, self?.originPoint.y ?? 0, 0, 0)
            }) { [weak self] (_) -> Void in
                self?.removeFromSuperview()
        }
    }
    
}

class MenuSwitchModel: NSObject {
    
    var image: String = ""
    
    var title: String = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}