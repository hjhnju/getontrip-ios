//
//  UIChannelLabel.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/31.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

protocol UIChannelLabelDelegate: NSObjectProtocol {
    func labelDidSelected(label: UIChannelLabel)
}

class UIChannelLabel: UILabel {
    
    ///  代理方法
    weak var delegate: UIChannelLabelDelegate?
    
    ///  景点标签
    ///
    ///  - parameter title:    标签内容
    ///  - parameter width:    宽度
    ///  - parameter height:   高度
    ///  - parameter fontSize: 字体大小
    ///
    ///  - returns: UILabel
    class func channelLabelWithTitle(title: String, width: CGFloat, height: CGFloat, fontSize: CGFloat) -> UIChannelLabel {
        
        let l: UIChannelLabel = UIChannelLabel()
        l.text = title
        //l.font = UIFont.systemFontOfSize(fontSize)
        l.bounds = CGRectMake(0, 0, width, height)
        l.textAlignment = NSTextAlignment.Center
        //l.sizeToFit()
        l.font = UIFont.systemFontOfSize(fontSize)
        l.userInteractionEnabled = true
        return l
    }
    
    ///  频道标签代理方法
    ///
    ///  - parameter touches: 点击的点
    ///  - parameter event:   单击事件
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (delegate?.respondsToSelector("labelDidSelected:") != nil) {
            delegate?.labelDidSelected(self)
        }
    }
}

