
//
//  PhotoView.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/6.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class PhotoView: UIView, UIGestureRecognizerDelegate {

    var imgPhoto: UIImageView = UIImageView() {
        didSet {
            print("方法调用了吗")
            
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imgPhoto)
        
        imgPhoto.userInteractionEnabled = true
        imgPhoto.multipleTouchEnabled   = true
        
        /// 旋转
        let rotation = UIRotationGestureRecognizer(target: self, action: "rotationGesture:")
        rotation.delegate = self
        
        /// 捏合手势, 缩放
        let pinch = UIPinchGestureRecognizer(target: self, action: "pinchGesture:")
        pinch.delegate = self
        imgPhoto.addGestureRecognizer(pinch)
        
        /// 拖拽手势, 平移
        let pan = UIPanGestureRecognizer(target: self, action: "panGesture:")
        imgPhoto.addGestureRecognizer(pan)
        
        /// 长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPressGesture:")
        imgPhoto.addGestureRecognizer(longPress)
    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func longPressGesture(recognizer: UILongPressGestureRecognizer) {
        
        if recognizer.state == UIGestureRecognizerState.Began {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                recognizer.view?.alpha = 0.5
                }, completion: { (_) -> Void in
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        recognizer.view?.alpha = 1
                        
                        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
                        let ctx = UIGraphicsGetCurrentContext()
                        self.layer.renderInContext(ctx!)
                        let photoViewImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        
                        print(self.superview)
                    })
            })
        }
        
        
                // 把截取出来的图像, 通过代理传递给控制器
//                if ([self.delegate respondsToSelector:@selector(photoView:withImage:)]) {
//                               [self.delegate photoView:self withImage:photoViewImage];
    }
    
    
    
    // 捏合手势
    func pinchGesture(recognizer: UIPinchGestureRecognizer) {
        recognizer.view?.transform = CGAffineTransformScale(recognizer.view!.transform, recognizer.scale, recognizer.scale)
        recognizer.scale = 1
    }
    
    // 拖拽
    func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(recognizer.view)
        
        recognizer.view?.transform = CGAffineTransformTranslate(recognizer.view!.transform, translation.x, translation.y)
        recognizer.setTranslation(CGPointZero, inView: recognizer.view)
    }
   
    // 旋转
    func rotationGesture(recognizer: UIRotationGestureRecognizer) {
        recognizer.view?.transform = CGAffineTransformRotate(recognizer.view!.transform, recognizer.rotation)
        recognizer.rotation = 0
    }
        

}
