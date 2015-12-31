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
    
    // 获取带行间距的字符格式
    func getAttributedString(lineHeightMultiple:CGFloat = 0, lineSpacing: CGFloat = 0, breakMode:NSLineBreakMode = NSLineBreakMode.ByTruncatingTail, fontName: String? = Font.ios8Font, fontSize: CGFloat? = 12) -> NSAttributedString {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.lineHeightMultiple = lineHeightMultiple
        style.lineBreakMode = breakMode
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, attributedString.length))
        
        if fontName != nil && fontName != Font.ios8Font{
            let font1: UIFont?
            if #available(iOS 9.0, *) {
                font1 = UIFont(name: fontName!, size: fontSize!)
            } else {
                font1 = UIFont(name: Font.ios8Font, size: fontSize!)
            }
            attributedString.addAttribute(NSFontAttributeName, value: font1!, range: NSMakeRange(0, attributedString.length))
        }
        
        return attributedString
    }
    
    /// 改变某一段字的颜色
    func getAttributedStringColor(changeStr: String, normalColor: UIColor, differentColor: UIColor) -> NSAttributedString{
        let attr = NSMutableAttributedString(string: self)
        
        let changeS = NSString(string: self).rangeOfString(changeStr)
        attr.addAttribute(NSForegroundColorAttributeName, value: normalColor, range: NSMakeRange(0, attr.length))
        attr.addAttribute(NSForegroundColorAttributeName, value: differentColor, range: changeS)
    
        return attr
    }
    
    func getAttributedStringHeadCharacterBig() -> NSAttributedString{
        
        let attr = NSMutableAttributedString(string: self)
        if self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 3 {
            attr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(10), range: NSMakeRange(0, attr.length - 3))
        }
        
        return attr
    }
    
    //trim
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    ///  计算文字大小
    ///
    ///  - parameter font:    文字大小
    ///  - parameter maxSize: 文字最大的大小，建议宽度有值，高度为CGFLOAT_MAX
    ///
    ///  - returns: 文字size
    func sizeofStringWithFount(font: UIFont, maxSize: CGSize, lineSpacing: CGFloat=8) -> CGSize {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = CGFloat(lineSpacing)
        let affe = [NSFontAttributeName : font, NSParagraphStyleAttributeName : style]
        return self.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: affe, context: nil).size
    }
    
    ///  计算文字大小
    ///
    ///  - parameter font:    文字大小
    ///  - parameter maxSize: 文字最大的大小，建议宽度有值，高度为CGFLOAT_MAX
    ///
    ///  - returns: 文字size
    func sizeofStringWithFount1(font: UIFont, maxSize: CGSize) -> CGSize {
        
        let affe = [NSFontAttributeName : font]
        return self.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: affe, context: nil).size
    }
}

