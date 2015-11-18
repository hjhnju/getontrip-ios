//
//  MessageList.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/17.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class MessageList: NSObject {
    
    /// 内容
    var content: String = ""
    
    /// 头像
    var avatar: String = "" {
        didSet {
            avatar = UIKitTools.sliceImageUrl(avatar, width: 35, height: 35)
        }
    }
    
    /// 系统消息是否有图片
    var systemMesIsIcon: Bool = false
    
    /// 标题
    var title: String = ""
    
    /// 图片
    var image: String = "" {
        didSet {
            if image == "" {
                systemMesIsIcon = true
            }
            image = UIKitTools.sliceImageUrl(image, width: 77, height: 58)
        }
    }
    
    /// 创建时间
    var create_time: String = ""
    
    /// 回复/提问
    var type: String = ""
    
    ///  话题id
    var topicId: String = ""
    
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}