//
//  TopicDetailListController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/19.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import SDWebImage

class TopicDetailListController: UITableViewController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    // 网络请求，加载数据
    var lastSuccessRequest: TopicRequest?
    
    var sightId: Int?
    
    var nearTopics = [TopicDetails]()

    
    // MARK: 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil);

        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        navigationController?.delegate = self
//        navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        
        
        refresh()
    }
    
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        // 获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = TopicRequest(sightId: sightId!, order: nil, tags: nil)
        }
        
        lastSuccessRequest!.fetchTopicPageModels { (handler: [TopicDetails]) -> Void in
            if handler.count > 0 {
                self.nearTopics = handler
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        super.navigationController?.navigationController?.navigationBar.barTintColor = SceneColor.crystalWhite
        super.navigationController?.navigationController?.navigationBar.tintColor = SceneColor.lightGray
        super.navigationController?.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName : SceneColor.lightGray, NSFontAttributeName: UIFont.systemFontOfSize(12)]
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    // TODO: 为了使下个界面颜色变白，采取反复设置颜色的办法，不过这个办法并不好，如有更好的办法，请立即更换
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        super.navigationController?.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : SceneColor.lightYellow]
        super.navigationController?.navigationController?.navigationBar.barTintColor = SceneColor.black
        super.navigationController?.navigationController?.navigationBar.tintColor    = SceneColor.lightYellow
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    // MARK: 话题列表页数据源方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearTopics.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("topicDetailListCell", forIndexPath: indexPath) as! TopicDetailsCell
        cell.topicModel = nearTopics[indexPath.row]

        return cell
    }
    
    var lastSuccessRequest1: TopicDetailRequest?
    
    // MARK: 代理方法，加载详情页面
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        loadData(nearTopics[indexPath.row].id)
    }
    
    private func loadData(id: Int) {
        NSLog("notice:refreshing nearby data.")
        
        TopicDetailRequest(topicId: id).fetchModels { (handler: Topic) -> Void in
            
            let topicDetailViewController = UIStoryboard(name: "TopicDetail", bundle: nil).instantiateViewControllerWithIdentifier(StoryBoardIdentifier.TopicDetailViewControllerID) as? TopicDetailViewController
            var topic = handler as Topic
            topic.sight = self.navigationController?.navigationItem.title
            topicDetailViewController!.topic = topic
            topicDetailViewController?.refreshBar()
            self.navigationController?.pushViewController(topicDetailViewController!, animated: true)
        }
        
    }
    
    // MARK: 转场动画
    let customNavigationAnimationController = CustomNavigationAnimationController()
    let customInteractionController = CustomInteractionController()
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .Push {
            customInteractionController.attachToViewController(toVC)
        }
        customNavigationAnimationController.reverse = operation == .Pop
        return customNavigationAnimationController
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return customInteractionController.transitionInProgress ? customInteractionController : nil
    }
}
