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
    
    /// 初始点
    var initPoint: CGPoint = CGPointZero {
        didSet {
            containerView.frame  = CGRectMake(initPoint.x, initPoint.y, 0, 0)
        }
    }
    /// 退出按钮
    lazy var exitButton: UIButton = UIButton()
    /// 容器view
    lazy var containerView: UIView = UIView()
    /// 底部图片
    lazy var bottomImageView: UIImageView = UIImageView(image: UIImage(named: "spring_sight"))
    
    /// 数据源
    var dataSource: [MenuSwitchModel] = [MenuSwitchModel]() {
        didSet {
            var y: CGFloat = 15
            var tag: Int = 1
            for item in dataSource {
                let btn = UIButton(image: item.image, title: item.title, fontSize: 16)
                btn.addTarget(superController, action: "selectSwitchAction:", forControlEvents: .TouchUpInside)
                btn.tag = tag
                containerView.addSubview(btn)
                btn.frame = CGRectMake(23, y, 140, 46)
                y += 27
                tag++
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(exitButton)
        
        exitButton.hidden = true
        exitButton.ff_Fill(self)
        exitButton.addTarget(self, action: "exitAction", forControlEvents: .TouchUpInside)
        
        containerView.hidden = true
        containerView.addSubview(bottomImageView)
        bottomImageView.ff_Fill(containerView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 显示选择方法
    func showSwitchAction() {
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        self.frame = UIScreen.mainScreen().bounds
        containerView.backgroundColor = UIColor.randomColor()
        containerView.hidden = false
        exitButton.hidden    = false
        UIView.animateWithDuration(0.5) { [weak self] () -> Void in
            let w: CGFloat = 140
            self?.containerView.frame = CGRectMake(Frame.screen.width - w - 9, self?.initPoint.y ?? 0, w, CGFloat(46 * (self?.dataSource.count ?? 0)))
        }
    }
    
    /// 退出方法
    func exitAction() {
        
        UIView.animateWithDuration(0.5, animations: { [weak self] () -> Void in
            self?.containerView.frame = CGRectMake(self?.initPoint.x ?? 0, self?.initPoint.y ?? 0, 0, 0)
            }) { [weak self] (_) -> Void in
                self?.exitButton.hidden    = true
                self?.containerView.hidden = true
                self?.removeFromSuperview()
        }
    }
    
}

class MenuSwitchModel {
    
    var image: String = ""
    
    var title: String = ""
}