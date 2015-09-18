//
//  CompositorController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/24.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class CompositorController: UIViewController {

    // 排序选择按钮记录状态
    var compositorSelectorButton: UIButton?
    
    @IBOutlet weak var defaultButton: UIButton!
    // 默认按钮方法
    @IBAction func compositorButtonClick(sender: UIButton) {
        compositorSelectorButton?.selected = false
        sender.selected = true
        compositorSelectorButton = sender
    }
    
    
    lazy var baselineTop: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(white: 0x979797, alpha: 0.3)
        baselineView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 0.5)
        return baselineView
    }()
    
    lazy var baselineCenter1: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(white: 0x979797, alpha: 0.3)
        return baselineView
    }()
    
    lazy var baselineCenter2: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor(white: 0x979797, alpha: 0.3)
        return baselineView
    }()
    
    lazy var baselineBottom: UIView! = {
        var baselineView = UIView()
        baselineView.backgroundColor = UIColor.yellowColor()
        baselineView.sendSubviewToBack(self.view)
        return baselineView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        compositorButtonClick(defaultButton)
        view.addSubview(baselineTop)
        view.addSubview(baselineCenter1)
        view.addSubview(baselineCenter2)
        view.addSubview(baselineBottom)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let lineHeight: CGFloat = 0.5
        let screen = UIScreen.mainScreen().bounds
        let buttonHeight: CGFloat = 50
        let x: CGFloat = 9
        baselineCenter1.frame = CGRectMake(x, buttonHeight, screen.width - x * 2, lineHeight)
        baselineCenter2.frame = CGRectMake(x, 100, screen.width - x * 2, lineHeight)
        baselineBottom.frame = CGRectMake(0, 150, screen.width, lineHeight)
    }
}
