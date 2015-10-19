
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
    
    lazy var slideButton: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.setBackgroundImage(UIImage(named: "icon_hamburger"), forState: UIControlState.Normal)
        button.addTarget(self, action: "toggleMenu", forControlEvents: UIControlEvents.TouchUpInside)
        return button
        }()
    
    // MASK: View Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slideButton.frame  = CGRectMake(0, 0, 21, 14)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: 自定义方法
    
    func toggleMenu(){
        slideDelegate?.toggle()
    }
    
    
    var searchController: UISearchController!
    func showSearch(){
        // 获得父控制器
        let searchResultsController = SearchResultsViewController()
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        
        
        let imgView   = UIImageView(image: UIImage(named: "search-bg0")!)
        imgView.frame = searchController.view.bounds
        searchController.view.addSubview(imgView)
        searchController.view.sendSubviewToBack(imgView)
        
        searchController.searchBar.barStyle = UIBarStyle.Black
        searchController.searchBar.tintColor = UIColor.grayColor()
        
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.Default
        
        presentViewController(searchController, animated: true, completion: nil)

    }
    

}
