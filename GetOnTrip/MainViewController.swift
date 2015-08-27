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
    
    weak var view1: UIView!
    
    var view2: UIView = UIView()
    
    var view3: UIView = UIView()
    
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
        let controller1 = story1.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.NearbyControllerID) as! NearbyTableViewController
        addChildViewController(controller1)
        view1 = controller1.view
        scrollView.addSubview(view1)
        scrollView.bringSubviewToFront(view1)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //初始化scrollView, subview's bounds确定后
        let wBounds = containView.bounds.width
        let hBounds = containView.bounds.height

        self.scrollView.contentSize = CGSize(width: wBounds * 3, height: hBounds/2)
        
        view1.frame = CGRectMake(0, 0, wBounds, hBounds)
        
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
    
    // 搜索方法
    @IBAction func searchButtonClicked(button: UIBarButtonItem) {
        
        // Create the search results view controller and use it for the UISearchController.
        let searchResultsController = storyboard!.instantiateViewControllerWithIdentifier(StoryBoardIdentifier.SearchResultsViewControllerID) as! SearchResultsViewController
        
        // Create the search controller and make it perform the results updating.
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        
        //UI setting
        let imgView   = UIImageView(image: UIImage(named: "search-bg")!)
        imgView.frame = searchController.view.bounds
        searchController.view.addSubview(imgView)
        searchController.view.sendSubviewToBack(imgView)
        //searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchController.searchBar.barStyle = UIBarStyle.Black
        //searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "search-field")!, forState: UIControlState.Normal)
        //searchController.searchBar.setImage(UIImage(named: "search-icon")!, forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        searchController.searchBar.tintColor = UIColor.grayColor()
        let textField = searchController.searchBar.valueForKey("searchField") as? UITextField
        textField?.textColor = UIColor.whiteColor()
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.Default
        
        // Present the view controller.
        presentViewController(searchController, animated: true, completion: nil)
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
        } else {
            selectedItem = item3
        }
        
    }

    
}
