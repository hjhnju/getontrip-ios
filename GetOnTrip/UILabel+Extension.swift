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

/// 评论人姓名
class CommentPersonLabel : UILabel {
    
    
}

/// 回复人姓名
class AnswersPersonLabel : UILabel {
    
    
}