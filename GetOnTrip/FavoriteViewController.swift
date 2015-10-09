//
//  FavoriteViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/1.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class FavoriteViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - 属性
    lazy var titleBackground: UIView = UIView(color: SceneColor.lightBlack, alphaF: 1.0)
    
    /// 内容底部scrollview
    lazy var contentScrollView: UIScrollView = UIScrollView()
    
    /// 景点按钮
    lazy var sightBtn: UIButton = UIButton(title: "景点", fontSize: 14, radius: 0, titleColor: UIColor.whiteColor())
    
    /// 话题按钮
    lazy var contentBtn: UIButton = UIButton(title: "内容", fontSize: 14, radius: 0, titleColor: UIColor.whiteColor())
    
    /// 城市按钮
    lazy var cityBtn: UIButton = UIButton(title: "城市", fontSize: 14, radius: 0, titleColor: UIColor.whiteColor())
    
    lazy var selectView: UIView = UIView(color: UIColor.yellowColor(), alphaF: 1.0)
    
    // 景点控制器
    lazy var sightViewController: CollectSightViewController = CollectSightViewController()
    
    // 内容控制器
    lazy var contentController: CollectContentViewController = CollectContentViewController()
    
    // 城市控制器
    lazy var cityController: CollectCityViewController = CollectCityViewController()

    
    // MARK: - 初始化相关设置
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProperty()
        setupAddSubViewAndAction()
        setupAutoLayout()
        setupChildControllerProperty()
    }
    
    private func setupProperty() {
        
        title = "我的收藏"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButtonClicked:")
    }
    
    private func setupAddSubViewAndAction() {
        
        view.addSubview(titleBackground)
        view.addSubview(contentScrollView)
        contentScrollView.backgroundColor = UIColor.whiteColor()
        titleBackground.addSubview(cityBtn)
        titleBackground.addSubview(sightBtn)
        titleBackground.addSubview(contentBtn)
        contentScrollView.addSubview(cityController.view)
        contentScrollView.addSubview(contentController.view)
        contentScrollView.addSubview(sightViewController.view)
        titleBackground.addSubview(selectView)
        
        addChildViewController(cityController)
        addChildViewController(contentController)
        addChildViewController(sightViewController)
        
        cityBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        sightBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        contentBtn.addTarget(self, action: "switchCollectButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    // MARK: - 初始化自动布局
    private func setupAutoLayout() {
        
        automaticallyAdjustsScrollViewInsets = false
        titleBackground.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, 36), offset: CGPointMake(0, 64))
        contentScrollView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: titleBackground, size: CGSizeMake(view.bounds.width, view.bounds.height), offset: CGPointMake(0, 0))
        contentBtn.ff_AlignInner(ff_AlignType.CenterCenter, referView: titleBackground, size: CGSizeMake(100, 36), offset: CGPointMake(0, 0))
        sightBtn.ff_AlignInner(ff_AlignType.CenterLeft, referView: titleBackground, size: CGSizeMake(100, 36), offset: CGPointMake(0, 0))
        cityBtn.ff_AlignInner(ff_AlignType.CenterRight, referView: titleBackground, size: CGSizeMake(100, 36), offset: CGPointMake(0, 0))
        selectView.frame = CGRectMake(27 * 0.5, 34, 73, 1.5)
    }
    
    
    /// MARK: - 切换收藏视图方法
    var selectedIndex: Int?
    func switchCollectButtonClick(sender: UIButton) {
        
        UIView.animateWithDuration(0.5) { [unowned self] () -> Void in
            self.selectView.center.x = sender.center.x
        }

        if sender == sightBtn { selectedIndex = 0 }
        else if sender == contentBtn { selectedIndex = 1 }
        else if sender == cityBtn { selectedIndex = 2 }
        UIView.animateWithDuration(0.5) { [unowned self] () -> Void in
            self.contentScrollView.contentOffset.x = self.contentScrollView.bounds.width * CGFloat(self.selectedIndex!)
        }
    }
    
    
    func setupChildControllerProperty() {
        
        contentScrollView.contentOffset.x = 0
        contentScrollView.pagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        contentScrollView.bounces = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //初始化scrollView, subview's bounds确定后
        let wBounds = contentScrollView.bounds.width
        let hBounds = contentScrollView.bounds.height
        
        contentScrollView.contentSize = CGSize(width: wBounds * 3, height: hBounds * 0.5)
        sightViewController.view.frame = CGRectMake(0, 0, wBounds, hBounds)
        contentController.view.frame = CGRectMake(wBounds, 0, wBounds, hBounds)
        cityController.view.frame = CGRectMake(wBounds * 2, 0, wBounds, hBounds)
    }
    
    
    //MASK: Actions
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

        let xOffset: CGFloat = scrollView.contentOffset.x
        if (xOffset < 1.0) {
            switchCollectButtonClick(sightBtn)
        } else if (xOffset < titleBackground.bounds.width + 1) {
            switchCollectButtonClick(contentBtn)
        } else {
            switchCollectButtonClick(cityBtn)
        }
    }
    
    // MARK: - 搜索(下一个控制器)
    var searchController: UISearchController!
    func searchButtonClicked(button: UIBarButtonItem) {
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
        
//        let textField = searchController.searchBar.valueForKey("searchField") as? UITextField
//        textField?.textColor = UIColor.whiteColor()
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.Default
        
        
        presentViewController(searchController, animated: true, completion: nil)
        
    }

    
}

