//
//  MenuViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/2.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class MenuViewController: MainViewController {
    
    /// 自定义导航
    var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: UIColor.whiteColor(), titleSize: 18)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(navBar)
        
        navBar.setBackBarButton(UIImage(named: "icon_hamburger"), title: nil, target: self, action: "toggleMenuAction:")
        navBar.setRightBarButton(UIImage(named: "search"), title: nil, target: self, action: "searchAction:")
        navBar.setBlurViewEffect(false)
        navBar.setButtonTintColor(UIColor.whiteColor())
        navBar.backgroundColor = SceneColor.frontBlack
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubviewToFront(navBar)
    }
}
