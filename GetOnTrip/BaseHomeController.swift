
//
//  BaseHomeController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/23.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class BaseHomeController: UIViewController {
    
    /// 搜索方法
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "寻找你需要探索的城市、景点、话题等内容"
        return search
    }()
    
    //用户拖动视图
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    var panGestureRecognizer: UIPanGestureRecognizer?
    
    /// 遮罩层
    var maskView: UIView = UIView(color: UIColor.blackColor(), alphaF: 0.0)

    
    /// 窗口滑动按钮
    lazy var sideButton: UIBarButtonItem = {
        let side = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.Plain, target: self, action: "openAndCloseView")
        return side
    }()
    
    var viewOpenAndClose: Bool = false
    func openAndCloseView() {
        
        let parent = self.parentViewController as! UINavigationController
        
        if viewOpenAndClose { // 关闭
            maskView.alpha = 0.3
            parent.view.frame = CGRectMake(sideViewFrame.sideOffsetX, 0, view.bounds.width, view.bounds.height)
            UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { [unowned self] in
                    parent.view.frame.origin = CGPointMake(0, 0)
                    self.maskView.alpha = 0.000001
                }, completion: { [unowned self] (_) -> Void in
                    self.maskView.hidden = true
                    let vc = parent.parentViewController as! SideBottomController
                    vc.tableView.hidden = true
            })
        } else { // 打开
            
            parent.view.frame = view.bounds
            self.maskView.hidden = false
            UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { [unowned self] in
                let parent = self.parentViewController as! UINavigationController
                parent.view.frame = self.view.bounds
                    parent.view.frame =  CGRectMake(sideViewFrame.sideOffsetX, 0, self.view.bounds.width, self.view.bounds.height)
                    self.maskView.alpha = 0.3
                }, completion: { (_) -> Void in
                    let vc = parent.parentViewController as! SideBottomController
                    vc.tableView.hidden = false
                    vc.cellx = 0
                    vc.tableView.reloadData()
            })
        }
        viewOpenAndClose = !viewOpenAndClose
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil);
        setupNavigationBar()
        view.backgroundColor = UIColor.whiteColor()
        

        
        navigationItem.leftBarButtonItem = sideButton
        let searchButton = UIBarButtonItem(customView: searchBar)
        navigationItem.rightBarButtonItem = searchButton
        
        //初始化蒙板
        let parent = self.parentViewController as! UINavigationController
        parent.view.addSubview(maskView)
        maskView.frame = view.bounds
        
        //初始化手势
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "openAndCloseView")
        self.maskView.addGestureRecognizer(tapGestureRecognizer)

        if let pan = panGestureRecognizer {
            self.maskView.addGestureRecognizer(pan)
        }
    }
//    http://123.57.46.229:8301/api/home?deviceId=583C5CED-BDC2-4B7A-896F-64C2CAB8DBD2&city=北京
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.bounds = CGRectMake(0, 0, view.bounds.width - 70, 0)
        
    }
    
    func setupNavigationBar() {
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        searchBar.backgroundImage = imageWithColor(UIColor.orangeColor())
//        navigationController?.navigationBar.backgroundImage = imageWithColor(UIColor.clearColor())
        
        navigationController?.navigationBar.barTintColor = SceneColor.black
        navigationController?.navigationBar.tintColor    = SceneColor.lightYellow
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : SceneColor.lightYellow]
        //TODO:remove 1px border
    }
    

    


}
