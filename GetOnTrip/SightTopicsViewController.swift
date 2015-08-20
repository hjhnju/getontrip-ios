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
    
    var sightId: Int?
    
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
    
    var view1: UIView = UIView()
    
    var view2: UIView = UIView()
    
    var view3: UIView = UIView()
    
    var view4: UIView = UIView()
    
    // `searchController` is set when the search button is clicked.
    var searchController: UISearchController!
    
    //MASK: View Life Circle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil);
        
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
        let story1 = UIStoryboard(name: "Nearby", bundle: nil)
        let controller1 = story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.ScenicCyclopaedicSB) as! CyclopaedicViewController
        controller1.sightId = sightId
        addChildViewController(controller1)
        view1 = controller1.view
        scrollView.addSubview(view1)
        scrollView.bringSubviewToFront(view1)
        
        
        let controller2 = story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.ScenicTopicSB) as! TopicDetailListController
        controller2.sightId = sightId
        addChildViewController(controller2)
        view2 = controller2.view
        scrollView.addSubview(view2)
        scrollView.bringSubviewToFront(view2)
        
        
        let controller3 = story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.ScenicBookSB) as! BookController
        controller3.sightId = sightId
        addChildViewController(controller3)
        view3 = controller3.view
        scrollView.addSubview(view3)
        scrollView.bringSubviewToFront(view3)
        
        let controller4 = story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.ScenicVideoSB) as! VideoController
        controller4.sightId = sightId
        addChildViewController(controller4)
        view4 = controller4.view
        scrollView.addSubview(view4)
        scrollView.bringSubviewToFront(view4)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //初始化scrollView, subview's bounds确定后
        let wBounds = containView.bounds.width
        let hBounds = containView.bounds.height
        
        self.scrollView.contentSize = CGSize(width: wBounds * 4, height: hBounds/2)
        
        view1.frame = CGRectMake(0, 0, wBounds, hBounds)
        
        view2.frame = CGRectMake(wBounds, 0, wBounds, hBounds)
        self.scrollView.addSubview(view2)
        self.scrollView.bringSubviewToFront(view2)
        
        view3.frame = CGRectMake(wBounds * 2, 0, wBounds, hBounds)
        self.scrollView.addSubview(view3)
        self.scrollView.bringSubviewToFront(view3)
        
        view4.frame = CGRectMake(wBounds * 3, 0, wBounds, hBounds)
        self.scrollView.addSubview(view4)
        self.scrollView.bringSubviewToFront(view4)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //default select
        if selectedItem == nil{
            selectedItem = item1
        }
    }
    
    //MASK: Actions
    
    @IBAction func showMenu(sender: UIBarButtonItem) {
        if let masterNavCon = self.parentViewController as? MasterViewController {
            masterNavCon.slideDelegate?.displayMenu()
        }
    }
    
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
