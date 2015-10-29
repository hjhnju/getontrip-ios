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
    
    var otherVC: SightOtherViewController = SightOtherViewController()
    
    var cache = [String : NSArray]()
    
    var tagId: String? {
        didSet {
            otherVC.tagId = tagId!
        }
    }
    
    /// 景点id
    var sightId: String = "" {
        didSet {
            landscapeVC.sightId = sightId
            bookVC.sightId      = sightId
            videoVC.sightId     = sightId
            otherVC.sightId     = sightId
        }
    }
    
    var type: Int? {
        didSet {
//            vc.type = type!
            
            switch type! {
            case categoryLabel.sightLabel:
                addSubview(landscapeVC.view)
                landscapeVC.refresh()
            case categoryLabel.bookLabel:
                addSubview(bookVC.view)
                bookVC.refresh()
            case categoryLabel.videoLabel:
                addSubview(videoVC.view)
                videoVC.refresh()
            case categoryLabel.otherLabel:
                addSubview(otherVC.view)
                otherVC.refresh()
            default:
                break
            }
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch type! {
        case categoryLabel.sightLabel:
            landscapeVC.view.frame = bounds
        case categoryLabel.bookLabel:
            bookVC.view.frame = bounds
        case categoryLabel.videoLabel:
            videoVC.view.frame = bounds
        case categoryLabel.otherLabel:
            otherVC.view.frame = bounds
        default:
            break
        }
    }

}
