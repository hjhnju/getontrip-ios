//
//  StringExtentions.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/14.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    //获取带行间距的字符格式
    func getAttributedString(lineHeightMultiple:CGFloat = 0, lineSpacing: CGFloat = 0, breakMode:NSLineBreakMode = NSLineBreakMode.ByTruncatingTail) -> NSAttributedString {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.lineHeightMultiple = lineHeightMultiple
        style.lineBreakMode = breakMode
        
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    //trim
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}