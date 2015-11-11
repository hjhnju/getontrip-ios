
//
//  SwitchPhotoViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/11/7.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

/// 选取照片控制器
class SwitchPhotoViewController: MenuViewController {
    
    /// 照片view
    var photoView: PhotoView = PhotoView()
    
    lazy var bottomView = UIView(color: UIColor.blackColor(), alphaF: 0.7)
    
    var cancelBtn = UIButton(title: "取消", fontSize: 20, radius: 0)
    
    var trueBtn = UIButton(title: "确定", fontSize: 20, radius: 0)
    
    lazy var shade: PhotoShadeView = PhotoShadeView(color: UIColor.clearColor(), alphaF: 1.0)
    
    var saveImage: UIImage? {
        didSet{

            for item in super.parentViewController!.childViewControllers {
                if item.isKindOfClass(NSClassFromString("GetOnTrip.SettingViewController")!) {
                    let it = item as? SettingViewController
                    it?.iconPhoto = saveImage
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SceneColor.bgBlack
        shade.userInteractionEnabled = true
        shade.multipleTouchEnabled = true
        view.clipsToBounds = true
        view.addSubview(photoView)
        view.addSubview(shade)
        view.addSubview(bottomView)
        bottomView.addSubview(cancelBtn)
        bottomView.addSubview(trueBtn)
        navBar.hidden = true
        photoView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: UIScreen.mainScreen().bounds.size, offset: CGPointMake(0, 0))
        shade.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: UIScreen.mainScreen().bounds.size, offset: CGPointMake(0, 0))
        bottomView.ff_AlignInner(ff_AlignType.BottomLeft, referView: view, size: CGSize(width: view.bounds.width, height: 44), offset: CGPointMake(0, 0))
        cancelBtn.ff_AlignInner(ff_AlignType.CenterLeft, referView: bottomView, size: CGSizeMake(50, 44), offset: CGPointMake(0, 0))
        trueBtn.ff_AlignInner(ff_AlignType.CenterRight, referView: bottomView, size: CGSizeMake(50, 44), offset: CGPointMake(0, 0))
        
        cancelBtn.addTarget(self, action: "cancelAction:", forControlEvents: UIControlEvents.TouchUpInside)
        trueBtn.addTarget(self, action: "trueAction:", forControlEvents: UIControlEvents.TouchUpInside)        
    }
    
    ///  取消按钮方法
    func cancelAction(btn: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    ///  确定按钮方法
    func trueAction(btn: UIButton) {
        photoView.savePhotoAction()
        navigationController?.popViewControllerAnimated(true)
    }
    
    
}

/// 照片遮罩
class PhotoShadeView: UIView {
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        for item in super.superview!.subviews {
            if item.isKindOfClass(NSClassFromString("GetOnTrip.PhotoView")!) {
                let it = item as? PhotoView
                return it?.imgPhoto
            }
            
        }
        return super.hitTest(point, withEvent: event)
    }
    
    override func drawRect(rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextAddRect(ctx, rect)
        
        UIColor(hex: 0xFFFFFF, alpha: 0.3).setFill()
        CGContextFillPath(ctx)
        
        let ctx1 = UIGraphicsGetCurrentContext()
//        CGContextAddArc(ctx1, 100, 100, 50, 0, CGFloat(M_PI * 2), 1)
        let w: CGRect = UIScreen.mainScreen().bounds
        CGContextAddEllipseInRect(ctx1, CGRectMake(0, w.height * 0.5 - w.width * 0.5, w.width, w.width))
        CGContextSetLineCap(ctx1, CGLineCap.Round)
        CGContextSetLineJoin(ctx1, CGLineJoin.Round)
        CGContextSetBlendMode(ctx1, CGBlendMode.Copy)
        UIColor.clearColor().setFill()
        
        CGContextFillPath(ctx1)
        
    }
    
}
