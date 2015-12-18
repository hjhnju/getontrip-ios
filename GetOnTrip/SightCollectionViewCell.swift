//
//  SightCollectionViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SightCollectionViewCell: UICollectionViewCell {
    
    var tagObject : Tag? {
        didSet {
            if let obj = tagObject {
                switch obj.type {
                case SightLabelType.Topic:
                    let v = SightTopicViewController()
                    v.cellId = obj.id
                    v.tagData = obj
                    vc = v
                case SightLabelType.Landscape:
                    let v = SightLandscapeController()
                    v.sightId = obj.sightId
                    vc = v
                case SightLabelType.Book:
                    let v = SightBookViewController()
                    v.sightId = obj.sightId
                    vc = v
                case SightLabelType.Video:
                    let v = SightVideoViewController()
                    v.sightId = obj.sightId
                    vc = v
                default:
                    break
                }
            }
        }
    }
    
    var vc: UITableViewController? {
        didSet {
            if let v = vc {
                addSubview(v.tableView)
                v.tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 90)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
