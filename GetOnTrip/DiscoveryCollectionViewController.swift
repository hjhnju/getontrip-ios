//
//  DiscoveryCollectionViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/21.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class DiscoveryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //var topics: [Topic] = [Topic(topicid: 1, title: "topic1", subtitle: "desc1"), Topic(topicid: 2, title: "topic2", subtitle: "desc2"), Topic(topicid: 3, title: "topic3", subtitle: "desc3"), Topic(topicid: 4, title: "topic4", subtitle: "desc4"), Topic(topicid: 5, title: "topic5", subtitle: "desc5"), Topic(topicid: 6, title: "topic6", subtitle: "desc6"), Topic(topicid: 7, title: "topic7", subtitle: "desc7")]
    
    var topics = [Topic]()

    var lastRequest: DiscoveryRequest?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Storyboard已完成，不能再Register cell classes here
        //self.collectionView!.registerClass(DiscoveryCollectionViewCell.self, forCellWithReuseIdentifier: StoryBoardIdentifier.DiscoveryViewCellID)
        
        self.collectionView!.backgroundColor = SceneColor.gray
        
        refresh()
        
        //NSLog("DiscoveryCollectionViewController.viewDidLoad")
    }
    
    func refresh() {
        //下拉刷新
        if self.lastRequest == nil {
            self.lastRequest = DiscoveryRequest()
        }
        lastRequest?.fetchFirstPageModels {
            (topics:[Topic]) -> Void in
            if topics.count > 0 {
                self.topics = topics
                self.collectionView!.reloadData()
            }
            return
        }
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
        if let topicDetailViewController = UIStoryboard(name: "Nearby", bundle: nil).instantiateViewControllerWithIdentifier(StoryBoardIdentifier.TopicDetailViewControllerID) as? TopicDetailViewController {
            topicDetailViewController.topic = topic
            self.navigationController?.pushViewController(topicDetailViewController, animated: true)
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var itemHeight = 166
        if indexPath.item % 3 == 0 {
            itemHeight = 220
        }
        //NSLog("DiscoveryCollectionViewController.sizeForItemAtIndexPath:\(indexPath.section)-\(indexPath.row), item.size=\(FlowLayoutContants.itemWidth):\(itemHeight)")
        return CGSize(width: FlowLayoutContants.itemWidth, height: CGFloat(itemHeight))
    }
}
