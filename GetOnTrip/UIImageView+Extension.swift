//
//  UIImageView+Extension.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/8.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

extension UIImageView {
    
    class func imageByApplyingImage(image: UIImage) -> UIImage {
        
        let qrFilter = CIFilter(name: "CIGaussianBlur")!
    
        qrFilter.setValue(CIImage(CGImage: image.CGImage!), forKey: "inputImage")
        qrFilter.setValue((0.014577 * 50), forKey: kCIInputRadiusKey)
        let ciImage = qrFilter.outputImage
        return UIImage(CIImage: ciImage ?? image.CIImage!)
    }
}

