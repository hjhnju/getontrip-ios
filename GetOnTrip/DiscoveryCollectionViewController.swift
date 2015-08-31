//
//  DiscoveryCollectionViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/21.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import MJRefresh

class DiscoveryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //var topics: [Topic] = [Topic(topicid: 1, title: "topic1", subtitle: "desc1"), Topic(topicid: 2, title: "topic2", subtitle: "desc2"), Topic(topicid: 3, title: "topic3", subtitle: "desc3"), Topic(topicid: 4, title: "topic4", subtitle: "desc4"), Topic(topicid: 5, title: "topic5", subtitle: "desc5"), Topic(topicid: 6, title: "topic6", subtitle: "desc6"), Topic(topicid: 7, title: "topic7", subtitle: "desc7")]
    
    var topics = [Topic]()

    var lastRequest: DiscoveryRequest?
    
    var isLoadingMore:Bool = false
    
    // MARK: View Life Circle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.backgroundColor = SceneColor.gray
        
        //下拉刷新
        let headerView = MJRefreshNormalHeader(refreshingBlock: refresh)
        headerView.stateLabel.font                = UIFont(name: SceneFont.heiti, size: 12)
        headerView.lastUpdatedTimeLabel.font      = UIFont(name: SceneFont.heiti, size: 11)
        headerView.stateLabel.textColor           = SceneColor.lightGray
        headerView.lastUpdatedTimeLabel.textColor = SceneColor.lightGray
        headerView.activityIndicatorViewStyle     = UIActivityIndicatorViewStyle.White
        
        self.collectionView?.header          = headerView
        
        //上拉刷新
        let footerView = MJRefreshAutoNormalFooter(refreshingBlock: loadMore)
        footerView.automaticallyRefresh                = true
        footerView.appearencePercentTriggerAutoRefresh = -3
        footerView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        footerView.stateLabel.font            = UIFont(name: SceneFont.heiti, size: 12)
        footerView.stateLabel.textColor       = SceneColor.lightGray
        
        self.collectionView?.footer = footerView
        
        refresh()
        
        //NSLog("DiscoveryCollectionViewController.viewDidLoad")
    }

    override func viewWillAppear(animated: Bool) {
        //NSLog("DiscoveryCollectionViewController.viewWillAppear:frame=\(self.collectionView?.frame)")
    }
    
    override func viewDidAppear(animated: Bool) {
        //NSLog("DiscoveryCollectionViewController.viewDidAppear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Custom functions

    func refresh() {
        //下拉刷新 self.collectionView!.header.isRefreshing()的状态不变化，没什么卵用
        self.collectionView?.header.beginRefreshing()

        if self.lastRequest == nil {
            self.lastRequest = DiscoveryRequest()
        }
        lastRequest?.fetchFirstPageModels {
            (topics:[Topic]) -> Void in
            if topics.count > 0 {
                self.topics = topics
                self.collectionView!.reloadData()
            }
            self.collectionView?.header.endRefreshing()
            self.collectionView?.footer.resetNoMoreData()
        }
    }
    
    func loadMore(){
        if self.isLoadingMore {
            return
        }
        self.isLoadingMore = true
        //请求下一页
        self.lastRequest?.fetchNextPageModels { (topics:[Topic]) -> Void in
            if topics.count > 0 {
                self.topics = self.topics + topics
                self.collectionView?.reloadData()
                self.collectionView?.footer.endRefreshing()
            } else {
                self.collectionView?.footer.noticeNoMoreData()
            }
            self.isLoadingMore = false
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //NSLog("DiscoveryCollectionViewController.numberOfSectionsInCollectionView:\(1)")
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //NSLog("DiscoveryCollectionViewController.numberOfItemsInSection:\(topics.count)")
        return topics.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StoryBoardIdentifier.DiscoveryViewCellID, forIndexPath: indexPath) as! DiscoveryCollectionViewCell
    
        // Configure the cell
        cell.setDisplayFields(topics[indexPath.row])
        //NSLog("DiscoveryCollectionViewController.cellForItemAtIndexPath:\(indexPath.section)-\(indexPath.row)")
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let topic = topics[indexPath.row]
        if let topicDetailViewController = UIStoryboard(name: "TopicDetail", bundle: nil).instantiateViewControllerWithIdentifier(StoryBoardIdentifier.TopicDetailViewControllerID) as? TopicDetailViewController {
            topicDetailViewController.topic = topic
            self.navigationController?.pushViewController(topicDetailViewController, animated: true)
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        var itemHeight:CGFloat = 217
        let mod = indexPath.item % 6
        if  mod == 2 || mod == 4 {
            itemHeight = 257
        }
        //NSLog("DiscoveryCollectionViewController.sizeForItemAtIndexPath:\(indexPath.section)-\(indexPath.row), item.size=\(FlowLayoutContants.itemWidth):\(itemHeight)")
        return CGSize(width: FlowLayoutContants.itemWidth, height: itemHeight)
    }

    // MARK: UIScrollViewDelegate
    
    var yOffsetHis:CGFloat = 0
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        yOffsetHis = scrollView.contentOffset.y
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let gap = scrollView.contentOffset.y - yOffsetHis
        let factor = fmin(1.0, fmax(gap / UIScreen.mainScreen().bounds.height, -1.0))
        
        for cell in self.collectionView!.visibleCells() {
            if let collectionViewCell = cell as? DiscoveryCollectionViewCell {
                //println("collectionViewCell.frame = \(collectionViewCell.frame)")
                //println("scrolledViewCell.frame = \(collectionViewCell.scrolledImageUIView.frame)")
                collectionViewCell.scrolledImageUIView.factor = factor
            }
        }
    }
}
