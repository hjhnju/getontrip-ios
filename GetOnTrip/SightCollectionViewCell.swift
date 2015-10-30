//
//  SightCollectionViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SightCollectionViewCell: UICollectionViewCell {
    
    /// 子控制器
    var landscapeVC: SightLandscapeController = SightLandscapeController()
    
    var bookVC: SightBookViewController = SightBookViewController()
    
    var videoVC: SightVideoViewController = SightVideoViewController()
    
    var topicVC: SightTopicViewController = SightTopicViewController()
    
    var cache = [String : NSArray]()
    
    var tagId: String = "" {
        didSet {
            topicVC.tagId = tagId
        }
    }
    
    /// 景点id
    var sightId: String = "" {
        didSet {
            landscapeVC.sightId = sightId
            bookVC.sightId      = sightId
            videoVC.sightId     = sightId
            topicVC.sightId     = sightId
        }
    }
    
    var type: Int? {
        didSet {
            if let type = type {
                switch type {
                case CategoryLabel.sightLabel:
                    addSubview(landscapeVC.view)
                case CategoryLabel.bookLabel:
                    addSubview(bookVC.view)
                case CategoryLabel.videoLabel:
                    addSubview(videoVC.view)
                case CategoryLabel.topicLabel:
                    addSubview(topicVC.view)
                default:
                    break
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch type! {
        case CategoryLabel.sightLabel:
            landscapeVC.view.frame = bounds
        case CategoryLabel.bookLabel:
            bookVC.view.frame = bounds
        case CategoryLabel.videoLabel:
            videoVC.view.frame = bounds
        case CategoryLabel.topicLabel:
            topicVC.view.frame = bounds
        default:
            break
        }
    }

}
