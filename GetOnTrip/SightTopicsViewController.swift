//
//  SightViewController.swift
//  GetOnTrip
//  景点话题页
//
//  Created by 何俊华 on 15/7/26.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SightTopicsViewController: UIViewController, UIScrollViewDelegate {
    
    var sightId: UIButton?
    
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    var selectedItem:UIButton?
    
    // 百科
    @IBOutlet weak var item1: UIButton!
    // 话题
    @IBOutlet weak var item2: UIButton!
    // 书籍
    @IBOutlet weak var item3: UIButton!
    // 视频
    @IBOutlet weak var item4: UIButton!
    
    @IBOutlet weak var containView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // 百科底图
    lazy var view1: UIView = {
        var view1 = UIView(frame: UIScreen.mainScreen().bounds)
        view1.backgroundColor = UIColor(patternImage: UIImage(named: "cyclopaedicBottom")!)
        return view1
    }()
    // 话题列表底图
    lazy var view2: UIView = {
        var view1 = UIView(frame: UIScreen.mainScreen().bounds)
        view1.backgroundColor = UIColor(patternImage: UIImage(named: "topicBottom")!)
        return view1
    }()
    // 书籍底图
    lazy var view3: UIView = {
        var view1 = UIView(frame: UIScreen.mainScreen().bounds)
        view1.backgroundColor = UIColor(patternImage: UIImage(named: "bookBottom")!)
        return view1
    }()
    // 视频底图
    lazy var view4: UIView = {
        var view1 = UIView(frame: UIScreen.mainScreen().bounds)
        view1.backgroundColor = UIColor(patternImage: UIImage(named: "videoBottom")!)
        return view1
    }()
    
    // 排序按钮
    lazy var searchItem: UIBarButtonItem = {
        var item = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButtonClicked:")
        return item
    }()
    
    // 搜索按钮
    lazy var compositorItem: UIBarButtonItem = {
        let btn = UIButton(frame: CGRectMake(0, 0, 30, 30))
        btn.setImage(UIImage(named: "compositorButton"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "compositorButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        var item = UIBarButtonItem(customView: btn)
        return item
    }()
    
    //MASK: View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil);
        
        
        
        self.navigationController?.navigationBar.barTintColor = SceneColor.crystalWhite
        self.navigationController?.navigationBar.tintColor = SceneColor.lightGray
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "navigationChangeTitle", name: "navigationChangeTitle", object: nil)
        setupSearchAndCompositorItem()
        setupDefaultSightTopic()
        setupChildControllerProperty()
    }
    
    deinit {
        // 注销通知
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "navigationChangeTitle", object: nil)
    }
    
    // 导航栏设置
    func setupSearchAndCompositorItem() {
        navigationController?.navigationItem.rightBarButtonItems = [searchItem, compositorItem]
    }
    
    // 排序
    let popoverAnimator = PopoverAnimator()
    func compositorButtonClicked() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "排序"
        let story1 = UIStoryboard(name: "Nearby", bundle: nil)
        let vc = story1.instantiateViewControllerWithIdentifier("compositorContoller") as! CompositorController
        
        // 1. 设置`转场 transitioning`代理
        vc.transitioningDelegate = popoverAnimator
        // 2. 设置视图的展现大小
        popoverAnimator.presentFrame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, 150)
        // 3. 设置专场的模式 - 自定义转场动画
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func navigationChangeTitle() {
        navigationItem.hidesBackButton = false
        navigationItem.title = sightId?.titleLabel?.text
    }
    
    // 搜索
    func searchButtonClicked(button: UIBarButtonItem) {
        // 获得父控制器
        var pare = self.parentViewController?.parentViewController as! MasterViewController
        // 找到MainViewController并调用搜索方法
        for vc in pare.viewControllers {
            if vc.isKindOfClass(MainViewController) {
                vc.searchButtonClicked(button)
            }
        }
    }
    
    // 加载默认的选中状态为话题按钮
    func setupDefaultSightTopic() {
        item2.backgroundColor = UIColor(white: 1, alpha: 0.5)
        item2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        item2.layer.masksToBounds = true
        item2.layer.cornerRadius = 15
        recordButtonStatus = item2
    }
    
    func setupChildControllerProperty() {
        
        self.navigationItem.title = sightId?.titleLabel?.text
        scrollView.contentOffset.x = UIScreen.mainScreen().bounds.width
    
        //颜色
        toolbar.barTintColor = SceneColor.lightBlack
        toolbar.tintColor = UIColor.whiteColor()
        
        
        //初始化scrollview
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        
        //初始化views
        cyclopaedicViewController.sightId = sightId!.tag
        addChildViewController(cyclopaedicViewController)
        view1.addSubview(cyclopaedicViewController.view)
        scrollView.addSubview(view1)
        
        
        topicDetailListController.sightId = sightId?.tag
        addChildViewController(topicDetailListController)
        view2.addSubview(topicDetailListController.view)
        scrollView.addSubview(view2)
        
        bookController.sightId = sightId?.tag
        addChildViewController(bookController)
        view3.addSubview(bookController.view)
        scrollView.addSubview(view3)
        
        videoController.sightId = sightId?.tag
        addChildViewController(videoController)
        view4.addSubview(videoController.view)
        scrollView.addSubview(view4)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //初始化scrollView, subview's bounds确定后
        let wBounds = containView.bounds.width
        let hBounds = containView.bounds.height
        
        scrollView.contentSize = CGSize(width: wBounds * 4, height: hBounds/2)
        
        view1.frame = CGRectMake(0, 0, wBounds, hBounds)
        
        view2.frame = CGRectMake(wBounds, 0, wBounds, hBounds)
        scrollView.bringSubviewToFront(topicDetailListController.view)
        
        view3.frame = CGRectMake(wBounds * 2, 0, wBounds, hBounds)
        scrollView.bringSubviewToFront(bookController.view)
        
        view4.frame = CGRectMake(wBounds * 3, 0, wBounds, hBounds)
        scrollView.bringSubviewToFront(videoController.view)
    }
    

    //MASK: Actions
    var recordButtonStatus: UIButton?

    
    @IBAction func selectItem(sender: UIButton) {
        
        recordButtonStatus?.backgroundColor = UIColor.clearColor()
        recordButtonStatus?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        recordButtonStatus?.selected = false
        
        if !sender.selected {
            sender.selected = true
            sender.backgroundColor = UIColor(white: 1, alpha: 0.5)
            sender.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            sender.layer.masksToBounds = true
            sender.layer.cornerRadius = 15
            recordButtonStatus = sender
        }
        
        //set select
        selectedItem = sender
        //move
        var selectedIndex: CGFloat = 0
        if selectedItem == item1 { selectedIndex = 0 }
        else if selectedItem == item2 { selectedIndex = 1 }
        else if selectedItem == item3 { selectedIndex = 2 }
        else if selectedItem == item4 { selectedIndex = 3 }
        scrollView.contentOffset.x = containView.bounds.width * selectedIndex
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var xOffset: CGFloat = scrollView.contentOffset.x
        if (xOffset < 1.0) {
            selectedItem = item1
            compositorItem.customView?.hidden = true
//                self.navigationItem.xxxItem.customView.hidden
            selectItem(item1)
        } else if (xOffset < containView.bounds.width + 1) {
            selectedItem = item2
            compositorItem.customView?.hidden = false
            selectItem(item2)
        } else if (xOffset < containView.bounds.width * 2 + 1) {
            selectedItem = item3
            compositorItem.customView?.hidden = true
            selectItem(item3)
        } else {
            selectedItem = item4
            compositorItem.customView?.hidden = true
            selectItem(item4)
        }
    }
    
    // MARK: 懒加载
    // 百科控制器
    lazy var cyclopaedicViewController: CyclopaedicViewController = {
        let story1 = UIStoryboard(name: "Nearby", bundle: nil)
        return story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.ScenicCyclopaedicSB) as! CyclopaedicViewController
        }()
    
    // 话题控制器
    lazy var topicDetailListController: TopicDetailListController = {
        let story1 = UIStoryboard(name: "Nearby", bundle: nil)
        return story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.ScenicTopicSB) as! TopicDetailListController
        }()
    
    // 书籍控制器
    lazy var bookController: BookController = {
        let story1 = UIStoryboard(name: "Nearby", bundle: nil)
        return story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.ScenicBookSB) as! BookController
        }()
    
    // 视频控制器
    lazy var videoController: VideoController = {
        let story1 = UIStoryboard(name: "Nearby", bundle: nil)
        return story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.ScenicVideoSB) as! VideoController
        }()

}
