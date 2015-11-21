//
//  Comment.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/21.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class Comment: NSObject {
    
    var id:        Int = 0
    
    var content:   String = ""
    
    var to_name:   String = ""
    
    var from_name: String = ""
    
    var create_time: String = ""
    
    var from_user_id: String = ""
    
    var avatar: String = "" {
        didSet {
            avatar = AppIni.BaseUri + avatar
        }
    }
    
    var sub_Comment: [Replay] = [Replay]()
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        id          = ((dict["id"])?.integerValue)!
        avatar      = AppIni.BaseUri + String(dict["avatar"]!)
        content     = String(dict["content"]!)
        to_name     = String(dict["to_name"]!)
        create_time = String(dict["create_time"]!)
        from_name   = String(dict["from_name"]!)
        from_user_id = String(dict["from_user_id"]!)
        
        for it in dict["subComment"] as! NSArray {
            sub_Comment.append(Replay(dict: it as! [String : AnyObject]))
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}