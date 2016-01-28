//
//  UIImageView+Extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/8.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

extension UIImageView {
    
    class func imageByApplyingImage(image: UIImage, blurRadius: CGFloat) -> UIImage {
        let qrFilter = CIFilter(name: "CIGaussianBlur")!
        qrFilter.setValue(CIImage(CGImage: image.CGImage!), forKey: "inputImage")
        qrFilter.setValue((blurRadius * 5), forKey: kCIInputRadiusKey)
        return UIImage(CIImage: (qrFilter.valueForKey(kCIOutputImageKey) ?? CIImage()) as! CIImage)
    }
}

