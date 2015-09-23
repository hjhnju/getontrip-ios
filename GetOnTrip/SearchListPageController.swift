//
//  SearchListPageController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class SearchListPageController: UIViewController {
    
//    var slideDelegate: //SlideMenuViewControllerDelegate?
    
//    var maskView: UIView!
    
    //用户拖动视图
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    var panGestureRecognizer: UIPanGestureRecognizer?
    
    
    var navigationBar = UINavigationBar()
    
    //MASK: View Life Cycle
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    /// 搜索方法
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "寻找你需要探索的城市、景点、话题等内容"
        return search
    }()
    
    /// 窗口滑动按钮
    lazy var sideButton: UIBarButtonItem = {
        let side = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        return side
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.frame = CGRectMake(0, 0, 100, 100)
//        view.backgroundColor = UIColor
        setupNavigationBar()
        view.backgroundColor = UIColor.whiteColor()
//        navigationController?.navigationItem.leftBarButtonItem
//        UIBarButtonItem(customView: <#T##UIView#>)
        
        
        let searchButton = UIBarButtonItem(customView: searchBar)
        searchBar.frame = CGRectMake(0, 0, 100, 100)
        navigationItem.leftBarButtonItem = sideButton
        navigationItem.rightBarButtonItem = searchButton
        navigationBar.items = [navigationItem]
        
        //统一navbar颜色样式
//        refreshBar()
        
        //初始化蒙板
//        maskView = UIView(frame: view.bounds)
//        maskView.alpha = 0.3
//        maskView.backgroundColor = UIColor.blackColor()
//        self.view.addSubview(maskView)
        
        //初始化手势
//        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapGestureHandler:")
//        self.maskView.addGestureRecognizer(tapGestureRecognizer)
        
//        if let pan = panGestureRecognizer {
//            self.maskView.addGestureRecognizer(pan)
//        }
        
//        refreshMask()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationBar.frame = CGRectMake(0, 0, view.bounds.width, 64)
        navigationBar.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, 64), offset: CGPointMake(0, 0))
        searchBar.bounds = CGRectMake(0, 0, view.bounds.width - 70, 0)
    }
    
    func setupNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.barTintColor = SceneColor.black
        navigationBar.tintColor    = SceneColor.lightYellow
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : SceneColor.lightYellow]
        //TODO:remove 1px border
    }
    
    //更新蒙板状态
//    func refreshMask() {
//        let masked = slideDelegate?.isOpening() ?? false
//        self.maskView.hidden = !masked
//    }
    
    //MASK: Gestures
    
//    func tapGestureHandler(sender: UITapGestureRecognizer){
//        if sender.state == .Ended {
//            slideDelegate?.dismissMenu()
//        }
//    }
    
        
}
