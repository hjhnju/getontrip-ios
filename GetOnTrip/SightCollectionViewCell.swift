//
//  SightCollectionViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SightCollectionViewCell: UICollectionViewCell {
    
    /// 数据
    var labelData: Tag? {
        didSet {
            if let label = labelData {
                //设置景点id
                landscapeVC.sightId = label.sightId
                bookVC.sightId      = label.sightId
                videoVC.sightId     = label.sightId
                
                //设置cell的数据类型
                self.type = Int(label.type)
            }
            
            //设置tag id
            topicVC.labelData = labelData
        }
    }
    
    /// 子控制器
    var landscapeVC: SightLandscapeController = SightLandscapeController()
    
    var bookVC: SightBookViewController       = SightBookViewController()
    
    var videoVC: SightVideoViewController     = SightVideoViewController()
    
    var topicVC: SightTopicViewController     = SightTopicViewController()
    
    var cache = [String : NSArray]()
    
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
                default:
                    addSubview(topicVC.view)
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
        default:
            topicVC.view.frame = bounds
            break
        }
    }

}
