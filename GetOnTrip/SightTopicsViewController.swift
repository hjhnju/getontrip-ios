//
//  SightViewController.swift
//  GetOnTrip
//  景点话题页
//
//  Created by 何俊华 on 15/7/26.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import SSKeychain

class SightTopicsViewController: UIViewController, UIScrollViewDelegate {
    
    var sightId: UIButton?
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    let slideHeight:CGFloat = 2
    
    var slideView = UIView()
    
    var selectedItem:UIButton? {
        didSet {
            if let item = selectedItem {
                let slideX = item.frame.origin.x
                let slideY = toolbar.frame.height - self.slideHeight
                let slideWidth = item.frame.width
                let newFrame   = CGRectMake(slideX, slideY, slideWidth, self.slideHeight)
                if self.slideView.frame.origin.x != 0 {
                    UIView.animateWithDuration(0.5, delay: 0,
                        options: UIViewAnimationOptions.AllowUserInteraction,
                        animations: { self.slideView.frame = newFrame },
                        completion: { (finished: Bool) -> Void in }
                    )
                } else {
                    self.slideView.frame = newFrame
                }
            }
        }
    }
    
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
    
    // MARK: 懒加载
    // 百科控制器
    lazy var cyclopaedicViewController: CyclopaedicViewController = {
        let story1 = UIStoryboard(name: "Nearby", bundle: nil)
        return story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.ScenicCyclopaedicSB) as! CyclopaedicViewController
    }()
    
    // 话题控制器
    var topicDetailListController: TopicDetailListController = {
        let story1 = UIStoryboard(name: "Nearby", bundle: nil)
        return story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.ScenicTopicSB) as! TopicDetailListController
    }()
    
    // 书籍控制器
    var bookController: BookController = {
        let story1 = UIStoryboard(name: "Nearby", bundle: nil)
        return story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.ScenicBookSB) as! BookController
    }()
    
    // 视频控制器
    var videoController: VideoController = {
        let story1 = UIStoryboard(name: "Nearby", bundle: nil)
        return story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.ScenicVideoSB) as! VideoController
    }()
    
    // `searchController` is set when the search button is clicked.
    var searchController: UISearchController!
    
    //MASK: View Life Circle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildControllerProperty()
    }
    
    func setupChildControllerProperty() {
        
        self.navigationItem.title = sightId?.titleLabel?.text
        scrollView.contentOffset.x = UIScreen.mainScreen().bounds.width

        //back button
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil);
        
        //颜色
        toolbar.barTintColor = SceneColor.lightBlack
        toolbar.tintColor = UIColor.whiteColor()
        
        //初始化下划线
        slideView.backgroundColor = SceneColor.lightYellow
        toolbar.addSubview(slideView)
        
        //初始化scrollview
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        
        //初始化views
        cyclopaedicViewController.sightId = sightId!.tag
        addChildViewController(cyclopaedicViewController)
        scrollView.addSubview(cyclopaedicViewController.view)
        scrollView.bringSubviewToFront(cyclopaedicViewController.view)
        
        topicDetailListController.sightId = sightId?.tag
        addChildViewController(topicDetailListController)
        scrollView.addSubview(topicDetailListController.view)
        scrollView.bringSubviewToFront(topicDetailListController.view)
        
        
        bookController.sightId = sightId?.tag
        addChildViewController(bookController)
        scrollView.addSubview(bookController.view)
        scrollView.bringSubviewToFront(bookController.view)
        
        videoController.sightId = sightId?.tag
        addChildViewController(videoController)
        scrollView.addSubview(videoController.view)
        scrollView.bringSubviewToFront(videoController.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //初始化scrollView, subview's bounds确定后
        let wBounds = containView.bounds.width
        let hBounds = containView.bounds.height
        
        scrollView.contentSize = CGSize(width: wBounds * 4, height: hBounds/2)
        
        cyclopaedicViewController.view.frame = CGRectMake(0, 0, wBounds, hBounds)
        
        topicDetailListController.view.frame = CGRectMake(wBounds, 0, wBounds, hBounds)
        scrollView.bringSubviewToFront(topicDetailListController.view)
        
        bookController.view.frame = CGRectMake(wBounds * 2, 0, wBounds, hBounds)
        scrollView.bringSubviewToFront(bookController.view)
        
        videoController.view.frame = CGRectMake(wBounds * 3, 0, wBounds, hBounds)
        scrollView.bringSubviewToFront(videoController.view)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //default select
        if selectedItem == nil{
            selectedItem = item2
        }
    }
    
    //MASK: Actions
    @IBAction func selectItem(sender: UIButton) {
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
    
    // 创建搜索
    @IBAction func searchButtonClicked(button: UIBarButtonItem) {
        
        
        

    }
    
    
    //MASK: Delegates
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //TODO: animation on slideView
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var xOffset: CGFloat = scrollView.contentOffset.x
        if (xOffset < 1.0) {
            selectedItem = item1
        } else if (xOffset < containView.bounds.width + 1) {
            selectedItem = item2
        } else if (xOffset < containView.bounds.width * 2 + 1) {
            selectedItem = item3
        } else {
            selectedItem = item4
        }
        
    }

}
