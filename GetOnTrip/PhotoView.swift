
//
//  PhotoView.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/6.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class PhotoView: UIView, UIGestureRecognizerDelegate {

    var imgPhoto: UIImageView = UIImageView()
    
    var img : UIImage = UIImage() {
        didSet{
            imgPhoto.image = img
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imgPhoto)
        imgPhoto.contentMode = UIViewContentMode.ScaleAspectFill
        imgPhoto.userInteractionEnabled = true
        imgPhoto.multipleTouchEnabled   = true
        imgPhoto.backgroundColor = UIColor.randomColor()
        imgPhoto.ff_AlignInner(ff_AlignType.TopLeft, referView: self, size: UIScreen.mainScreen().bounds.size, offset: CGPointMake(0, 0))
        /// 旋转
        let rotation = UIRotationGestureRecognizer(target: self, action: "rotationGesture:")
        rotation.delegate = self
        imgPhoto.addGestureRecognizer(rotation)
        
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
    
    ///  得到一个view的父控制器
    ///
    ///  - returns: 它自己的父控制器 有它可以省很多麻烦
    func viewcontroller() -> UIViewController? {
        for var next = self.superview; (next != nil); next = next?.superview {
            let nextResponder = next?.nextResponder()
            if ((nextResponder?.isKindOfClass(NSClassFromString("GetOnTrip.SwitchPhotoViewController")!)) != nil) {
                return nextResponder as? UIViewController
            }
        }
        return nil
    }
    
    func longPressGesture(recognizer: UILongPressGestureRecognizer) {
        
        if recognizer.state == UIGestureRecognizerState.Began {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                recognizer.view?.alpha = 0.5
                }, completion: { (_) -> Void in
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        recognizer.view?.alpha = 1
                        
                        let vc = self.viewcontroller() as? SwitchPhotoViewController
                        vc?.saveImage = self.avatarSubtract(PhotoView.captureShotWithView(self))
                        vc?.dismissViewControllerAnimated(true, completion: nil)
                    })
            })
        }
    }
    
    ///  截图
    class func captureShotWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        view.layer.renderInContext(ctx!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func savePhotoAction() {
        let vc = self.viewcontroller() as? SwitchPhotoViewController
        vc?.saveImage = self.avatarSubtract(PhotoView.captureShotWithView(self))
    }
    
    func avatarSubtract(image: UIImage) -> UIImage {
        let w = UIScreen.mainScreen().bounds
        let tempImage = image.scaleImage(w.width)
        
        let image1 = CGImageCreateWithImageInRect(tempImage.CGImage, CGRectMake(0, (tempImage.size.height * 0.5 - tempImage.size.width * 0.5), tempImage.size.width, tempImage.size.width))

        return UIImage(CGImage: image1!)
    }
    
    // 捏合手势
    func pinchGesture(recognizer: UIPinchGestureRecognizer) {
        
        
        recognizer.view?.transform = CGAffineTransformScale(recognizer.view!.transform, recognizer.scale, recognizer.scale)
        recognizer.scale = 1
        
//        let maxBig = max(imgPhoto.bounds.width, imgPhoto.bounds.height)
//        print(imgPhoto.bounds.width)
        
//        head.transform = CGAffineTransformScale(head.transform, 1.5, 1.5);
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
