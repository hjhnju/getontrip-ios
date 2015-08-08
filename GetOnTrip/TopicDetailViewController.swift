//
//  TopicDetailViewController.swift
//  GetOnTrip
//  话题详情页
//
//  Created by 何俊华 on 15/7/26.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class TopicDetailViewController: UIViewController {

    // MARK: Outlets and properties
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var topic:Topic?
    
    override func viewDidLoad() {
        if let t = topic {
            self.titleLabel?.text = "话题id=\(t.topicid)"
        }
    }

}
