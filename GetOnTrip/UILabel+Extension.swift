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