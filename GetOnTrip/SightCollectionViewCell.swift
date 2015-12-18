//
//  SightCollectionViewCell.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/29.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SightCollectionViewCell: UICollectionViewCell {
    
//    var data: AnyObject?
//    
//    var cellId: Int = 0
    
//    var tagObject : Tag? {
//        didSet {
//            if let obj = tagObject {
//                autoreleasepool({ () -> () in                    
//                    switch obj.type {
//                    case SightLabelType.Topic:
//                        let v = SightTopicViewController()
//                        v.tagData = obj
//                        v.data = data
//                        addSubview(v.tableView)
//                        vc = v
//                    case SightLabelType.Landscape:
//                        let v = SightLandscapeController()
//                        v.sightId = obj.sightId
//                        v.data = data
//                        addSubview(v.tableView)
//                        vc = v
//                    case SightLabelType.Book:
//                        let v = SightBookViewController()
//                        v.sightId = obj.sightId
//                        v.data = data
//                        addSubview(v.tableView)
//                        vc = v
//                    case SightLabelType.Video:
//                        let v = SightVideoViewController()
//                        v.sightId = obj.sightId
//                        v.data = data
//                        addSubview(v.tableView)
//                        vc = v
//                    default:
//                        break
//                    }
//                })
//            }
//        }
//    }
    
//    var vc: BaseTableViewController? {
//        didSet {
//            if let v = vc {
//                v.tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 90)
//                v.cellId = cellId
//            }
//        }
//    }
    
//    lazy var view: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addSubview(view)
//        view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 90)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        print("释放了没")
    }
}
