//
//  ReplayCommentButton.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/21.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

/// 回复的评论按钮
class ReplayButton: UIButton {
    
    var to_name: String = ""
    
    var upId: String = ""
    
    var frameUserId: String = ""
    
    var from_name: String = ""
    
    var indexPath: NSIndexPath?
    
    var index: Int?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame = CGRectMake(0, 0, bounds.width, bounds.height)
    }
}
