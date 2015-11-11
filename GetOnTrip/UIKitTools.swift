//
//  UIKitTools.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/10/15.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

class UIKitTools {
    
    //获取导航有效着色背景
    class func getNavBackView(navBar: UINavigationBar?) -> UIView? {
        var backView:UIView? = nil
        if let superView = navBar {
            for view in superView.subviews {
                if view.isKindOfClass(NSClassFromString("_UINavigationBarBackground")!) {
                    backView = view
                }
                if view.isKindOfClass(NSClassFromString("_UIBackdropView")!) {
                    view.hidden = true
                }
            }
        }
        return backView
    }
    
    //获得颜色图片
    class func imageWithColor(color: UIColor) -> UIImage {
        
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let ref = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(ref, color.CGColor)
        CGContextFillRect(ref, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 获取压缩图片的URL
    class func sliceImageUrl(path:String, width: Int, height: Int) -> String {
        //重要：若已经是压缩图片的格式则什么都不做，直接返回
        if path.containsString("@") {
            return path
        }
        let url = "\(AppIni.BaseUri)\(path)@e\(width)w_e\(height)h"
        return url
    }
    
    /**
    在完整的url后加入模糊参数，由后台提供实时高斯模糊
    
    - parameter url:    <#url description#>
    - parameter radius: <#radius description#>
    - parameter sigma:  <#sigma description#>
    
    - returns: <#return value description#>
    */
    class func blurImageUrl(url:String, radius:Int, sigma:Int) -> String {
        if url.containsString("@") {
            let returl = "\(url)_\(radius)r_\(sigma)s"
            return returl
        }
        return "\(url)@\(radius)r_\(sigma)s"
    }
    
    /**
    图片高斯模糊
    
    - parameter image:       input image
    - parameter inputRadius: 参数
    
    - returns: 处理后图片
    */
    //创建高斯模糊效果的背景
    class func createBlurBackground (image:UIImage, view:UIView, blurRadius:Float) {
        //处理原始NSData数据
        let originImage = CIImage(CGImage:image.CGImage! )
        //创建高斯模糊滤镜
        let filter = CIFilter(name: "CIGaussianBlur")
        filter!.setValue(originImage, forKey: kCIInputImageKey)
        filter!.setValue(NSNumber(float: blurRadius), forKey: "inputRadius")
        //生成模糊图片
        let context = CIContext(options: nil)
        let result:CIImage = filter!.valueForKey(kCIOutputImageKey) as! CIImage
        let blurImage = UIImage(CGImage: context.createCGImage(result, fromRect: result.extent))
        //将模糊图片加入背景
        let blurImageView = UIImageView() //模糊背景是界面的4倍大小
        blurImageView.contentMode = UIViewContentMode.ScaleAspectFill //使图片充满ImageView
        blurImageView.clipsToBounds = true
        blurImageView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight] //保持原图长宽比
        blurImageView.image = blurImage
        view.addSubview(blurImageView) //保证模糊背景在原图片View的下层
        blurImageView.frame = view.bounds
        view.sendSubviewToBack(blurImageView)
    }
}