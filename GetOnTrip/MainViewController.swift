//
//  MainViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/30.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, UIScrollViewDelegate {
    
    //MASK: Outlets and Properties
    
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
    
    @IBOutlet weak var item1: UIButton!
    
    @IBOutlet weak var item2: UIButton!
    
    @IBOutlet weak var item3: UIButton!
    
    @IBOutlet weak var containView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var view1: UIView = UIView()
    
    var view2: UIView = UIView()
    
    var view3: UIView = UIView()
    
    //MASK: View Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //初始化scrollView, subview's bounds确定后
        let wBounds = containView.bounds.width
        let hBounds = containView.bounds.height

        self.scrollView.contentSize = CGSize(width: wBounds * 3, height: hBounds/2)
        
        view1.backgroundColor = UIColor.blueColor()
        view1.frame = CGRectMake(0, 0, wBounds, hBounds)
        self.scrollView.addSubview(view1)
        self.scrollView.bringSubviewToFront(view1)
        
        view2.backgroundColor = UIColor.orangeColor()
        view2.frame = CGRectMake(wBounds, 0, wBounds, hBounds)
        self.scrollView.addSubview(view2)
        self.scrollView.bringSubviewToFront(view2)
        
        view3.backgroundColor = UIColor.purpleColor()
        view3.frame = CGRectMake(wBounds * 2, 0, wBounds, hBounds)
        self.scrollView.addSubview(view3)
        self.scrollView.bringSubviewToFront(view3)
        
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
        
        scrollView.contentOffset.x = containView.bounds.width * selectedIndex
    }
    
    //MASK: Delegates
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var xOffset: CGFloat = scrollView.contentOffset.x
        println("xOffset=\(xOffset)")
        if (xOffset < 1.0) {
            selectedItem = item1
        } else if (xOffset < containView.bounds.width + 1) {
            selectedItem = item2
        } else {
            selectedItem = item3
        }
        
    }

    
}
