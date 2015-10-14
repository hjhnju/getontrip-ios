//
//  extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(color: UIColor, fontSize: CGFloat, mutiLines: Bool = false) {
        self.init()
        
        font = UIFont.systemFontOfSize(fontSize)
        textColor = color
        
        if mutiLines {
            numberOfLines = 0
        }
    }
    
    ///  快速创建标签
    ///
    ///  - parameter color:     字体颜色
    ///  - parameter title:     文字内容
    ///  - parameter fontSize:  文字大小
    ///  - parameter mutiLines: true 行数为0，false没设
    ///
    ///  - returns: label
    convenience init(color: UIColor, title: String, fontSize: CGFloat, mutiLines: Bool = false) {
        self.init()
        
        text = title
        font = UIFont.systemFontOfSize(fontSize)
        textColor = color
        
        if mutiLines {
            numberOfLines = 0
        }
    }
    
    //根据文字设置标签显示宽度
    func resizeWidthToFit(widthConstraint: NSLayoutConstraint) {
        let attributes = [NSFontAttributeName : font]
        numberOfLines = 0
        lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        if let text = self.text {
            let rect = text.boundingRectWithSize(CGSizeMake(frame.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
            widthConstraint.constant = rect.width
            setNeedsLayout()
        }
    }
    
}

protocol SightLabelDelegate: NSObjectProtocol {
    func sightLabelDidSelected(label: SightLabel)
}

class SightLabel: UILabel {
    
    ///  代理方法
    weak var delegate: SightLabelDelegate?
    
    ///  景点标签
    ///
    ///  - parameter title:    标签内容
    ///  - parameter width:    宽度
    ///  - parameter height:   高度
    ///  - parameter fontSize: 字体大小
    ///
    ///  - returns: UILabel
    class func channelLabelWithTitle(title: String, width: CGFloat, height: CGFloat, fontSize: CGFloat) -> SightLabel {
        
        let l: SightLabel = SightLabel()
        l.text = title
        //        l.font = UIFont.systemFontOfSize(fontSize)
        l.bounds = CGRectMake(0, 0, width, height)
        l.textAlignment = NSTextAlignment.Center
        //        l.sizeToFit()
        l.font = UIFont.systemFontOfSize(fontSize)
        l.userInteractionEnabled = true
        return l
    }
    
    ///  景点标签代理方法
    ///
    ///  - parameter touches: 点击的点
    ///  - parameter event:   单击事件
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if (delegate?.respondsToSelector("sightLabelDidSelected:") != nil) {
            delegate?.sightLabelDidSelected(self)
        }
        
    }
    
}