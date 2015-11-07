
//
//  BaseHomeController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class MainViewController: BaseViewController {
    
    // MASK: Properties
    
    //代理左侧菜单的操作
    var slideDelegate: SlideMenuViewControllerDelegate?
    
    lazy var slideButton: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.setBackgroundImage(UIImage(named: "icon_hamburger"), forState: UIControlState.Normal)
        button.addTarget(self, action: "toggleMenu", forControlEvents: UIControlEvents.TouchUpInside)
        return button
        }()
        
    // MASK: View Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始定义bar隐藏
        navigationController?.navigationBar.hidden = true
        
        slideButton.frame  = CGRectMake(0, 0, 21, 14)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: 自定义方法
    
    func toggleMenu(){
        slideDelegate?.toggle()
    }
    
    func toggleMenuAction(sender: UIButton){
        slideDelegate?.toggle()
    }
    
    
    /// 显示搜索页
    func showSearch(){
        //fix 搜索pushviewController问题
        self.definesPresentationContext = true
        presentViewController(SearchViewController(), animated: true, completion: nil)
    }
    

}
