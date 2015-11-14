//
//  NSArray+Print.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/9/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

// MARK: - 专门调适用的分类(数组)
extension NSMutableArray {
    
    ///  输出信息
    ///
    ///  - parameter locale: 接收到的数组
    ///
    ///  - returns: 返回中文信息
    public override func descriptionWithLocale(locale: AnyObject?, indent level: Int) -> String {
        var strM = "(\n"
        enumerateObjectsUsingBlock { (obj, idx, stop) -> Void in
            strM += "\t\(obj),\n"
        }
        strM + ")"
        return strM.copy() as! String
    }
    
    
}

// MARK: - 专门用来调适用的分类(字典)
extension NSMutableDictionary {
    
    ///  输出信息
    ///
    ///  - parameter locale: 接收到的字典
    ///
    ///  - returns: 返回中文信息
    public override func descriptionWithLocale(locale: AnyObject?, indent level: Int) -> String {
        var strM = "{\n"
        enumerateKeysAndObjectsUsingBlock { (key, obj, stop) -> Void in
            strM += "\t\(key) = \(obj)\n"
        }
        strM += "}"
        return strM
    }
    
    
    
//    数组越界例:
//    @implementation NSArray(Extension)
//    + (void)load
//    {
//    [self swizzleInstanceMethod:NSClassFromString(@"__NSArrayI") originSelector:@selector(objectAtIndex:) otherSelector:@selector(hm_objectAtIndex:)];
//    }
//    
//    - (id)hm_objectAtIndex:(NSUInteger)index
//    {
//    if (index < self.count) {
//    return [self hm_objectAtIndex:index];
//    } else {
//    return nil;
//    }
//    }
}
