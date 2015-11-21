//
//  Comment.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/21.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class Comment: NSObject {
    
    /// 别人回复当前评论使用的id
    var upid: String = ""
    
    var id: String = ""
    
    var content:   String = ""
    
    var to_name:   String = ""
    
    var from_name: String = ""
    
    var create_time: String = ""
    
    var from_user_id: String = ""
    
    var avatar: String = "" {
        didSet {
            avatar = UIKitTools.sliceImageUrl(avatar, width: 44, height: 44)
        }
    }
    
    var sub_Comment: [Comment] = [Comment]()
    
    init(id: String){
        super.init()
        self.id = id
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
    
        setValuesForKeysWithDictionary(dict)
        //默认第一层为自己的id
        upid = id
        
        if let subs = dict["subComment"] as? NSArray {
            for it in subs {
                if let dic = it as? [String : AnyObject] {
                    let sub = Comment(dict: dic)
                    //第二层为上一层的id
                    sub.upid = id
                    sub_Comment.append(sub)
                }
            }
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}