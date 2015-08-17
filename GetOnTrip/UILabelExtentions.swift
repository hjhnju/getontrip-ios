//
//  LabelExtentions.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/11.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
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