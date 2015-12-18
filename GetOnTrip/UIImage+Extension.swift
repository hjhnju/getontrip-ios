//
//  UIImage+Extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/21.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 将图像缩放到`指定宽度`
    ///
    /// - parameter width: 图片宽度，如果图像宽度已经小于指定宽度，直接返回
    ///
    /// - returns: UIImage
    func scaleImage(width: CGFloat) -> UIImage {
        
        // 1. 判断图像宽度
        if width > size.width {
            return self
        }
        
        // 2. 根据宽度计算比例
        let height = size.height * width  / size.width
        // 生成图像的大小
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        // 3. 绘制新图像
        // 1> 开启上下文
        UIGraphicsBeginImageContext(rect.size)
        
        // 2> 绘制图像 － 在 rect 中缩放填充绘制图像
        drawInRect(rect)
        
        // 3> 取得结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 4> 关闭上下文
        UIGraphicsEndImageContext()
        
        // 5> 返回结果
        return result
    }
    
    //http://stackoverflow.com/questions/5084845/how-to-set-the-opacity-alpha-of-a-uiimage
    //image with alpha
    func imageByApplyingAlpha(alpha:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
    
        let ctx = UIGraphicsGetCurrentContext();
        let area = CGRectMake(0, 0, self.size.width, self.size.height);
    
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -area.size.height);
        CGContextSetBlendMode(ctx, CGBlendMode.Multiply);
        CGContextSetAlpha(ctx, alpha);
        CGContextDrawImage(ctx, area, self.CGImage);
    
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
    
        UIGraphicsEndImageContext();
    
        return newImage;
    }
    
    /// 获取纯色图片
    static func createImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
