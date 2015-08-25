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
    
    // `searchController` is set when the search button is clicked.
    var searchController: UISearchController!
    
    lazy var view1: UIView = {
        var view1 = UIView(frame: UIScreen.mainScreen().bounds)
        view1.backgroundColor = UIColor(patternImage: UIImage(named: "cyclopaedicBottom")!)
        return view1
    }()
    
    lazy var view2: UIView = {
        var view1 = UIView(frame: UIScreen.mainScreen().bounds)
        view1.backgroundColor = UIColor(patternImage: UIImage(named: "topicBottom")!)
        return view1
    }()
    
    lazy var view3: UIView = {
        var view1 = UIView(frame: UIScreen.mainScreen().bounds)
        view1.backgroundColor = UIColor(patternImage: UIImage(named: "bookBottom")!)
        return view1
    }()
    
    lazy var view4: UIView = {
        var view1 = UIView(frame: UIScreen.mainScreen().bounds)
        view1.backgroundColor = UIColor(patternImage: UIImage(named: "videoBottom")!)
        return view1
    }()
    
    
    //MASK: View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupSearchAndCompositorItem()
        setupDefaultSightTopic()
        setupChildControllerProperty()
    }
    
    //
    func setupSearchAndCompositorItem() {
        let item1 = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButtonClicked")
        let item2 = UIBarButtonItem(image: UIImage(named: "compositorButton"), style: UIBarButtonItemStyle.Plain, target: self, action: "compositorButtonClicked")
        navigationController?.navigationItem.rightBarButtonItems = [item1, item2]
    }
    
    // 排序
    func compositorButtonClicked() {
//        var compositorVC = CompositorController()
//        compositorVC.view.frame = UIScreen.mainScreen().bounds
//        view.addSubview(compositorVC.view)
//        self.addChildViewController(compositorVC)
        
        topicDetailListController.addCompositorController()
        // Create the search results view controller and use it for the UISearchController.
//           let v = CompositorController()
//        v.view.alpha = 0.5
//        v.view.frame = CGRectMake(0, 0, 300, 500);
        
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
//        view2.addSubview(v.view)
//        navigationController?.pushViewController(v, animated: true)
        
//        self.performSegueWithIdentifier("xxx", sender: nil)
//        performSegueWithIdentifier:@"login2list" sender:nil];

    }
     deinit {
    
        print("88")
    }
    
    // 搜索
    func searchButtonClicked() {
        
//        searchController = UISearchController(searchResultsController: searchResultsController)
//        searchController.searchResultsUpdater = searchResultsController
//        searchController.hidesNavigationBarDuringPresentation = false
        
        
        /**
        * 接口1：/api/topic/detail
        * 话题详情页接口
        * @param integer topicId，话题ID
        * @param string  deviceId，用户的设备ID（因为要统计UV）
        * @return json
        */
        
        
        //   话题详情页
        var uuid = SSKeychain.passwordForService(NSBundle.mainBundle().bundleIdentifier, account: "uuid")
        
        if (uuid == nil) {
            uuid = NSUUID().UUIDString
            SSKeychain.setPassword(uuid, forService: NSBundle.mainBundle().bundleIdentifier, account: "uuid")
        }
        // http://123.57.46.229:8301/api/topic/detail?topicId=1&deviceId=3245759B-4905-4C9A-B326-74E8D0BB455E
        var post     = [String:String]()
        post["topicId"] = String(5)
        post["deviceId"] = String(NSUUID().UUIDString)
        HttpRequest.ajax(AppIni.BaseUri, path: "/api/topic/detail",
            post: post,
            handler: {(respData: JSON) -> Void in
                print("=================\n")
                print("\(respData)")
                print("=================\n")
        })
        
        
        
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

        //back button
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil);
        
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
    

    
    
    //MASK: Delegates
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //TODO: animation on slideView
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var xOffset: CGFloat = scrollView.contentOffset.x
        if (xOffset < 1.0) {
            selectedItem = item1
            selectItem(item1)
        } else if (xOffset < containView.bounds.width + 1) {
            selectedItem = item2
            selectItem(item2)
        } else if (xOffset < containView.bounds.width * 2 + 1) {
            selectedItem = item3
            selectItem(item3)
        } else {
            selectedItem = item4
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
