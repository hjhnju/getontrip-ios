
//
//  BaseHomeController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class MainViewController: UIViewController {
    
    // MASK: Properties
    
    //代理左侧菜单的操作
    var slideDelegate: SlideMenuViewControllerDelegate?
    
    //窗口滑动按钮
    lazy var sideButton: UIBarButtonItem = {
        let side = UIBarButtonItem(image: UIImage(named: "menu-hamburger"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleMenu")
        return side
        }()
    
    //搜索框
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "搜索城市、景点、内容等"
        return search
        }()
    
    // MASK: View Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.backBarButtonItem  = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil);
        self.navigationItem.leftBarButtonItem  = sideButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        refreshBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.bounds = CGRectMake(0, 0, view.bounds.width - 70, 0)
    }
    
    func refreshBar() {
        navigationController?.navigationBar.barTintColor = SceneColor.black
        navigationController?.navigationBar.tintColor    = SceneColor.lightYellow
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : SceneColor.lightYellow]
    }
    
    //MARK: 自定义方法
    
    func toggleMenu(){
        slideDelegate?.toggle()
    }
}
