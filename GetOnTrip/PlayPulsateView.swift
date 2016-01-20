//
//  PlayPulsateView.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/14.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class PlayPulsateView: UIView {

    var color: UIColor = UIColor.whiteColor()
    
    func playIconAction() {
        let repl = CAReplicatorLayer()
        repl.frame = bounds
        layer.addSublayer(repl)
        let layer1 = CALayer()
        layer1.anchorPoint = CGPointMake(0.5, 1);
        layer1.position = CGPointMake(15, bounds.height);
        layer1.bounds = CGRectMake(0, 0, 2.15, 20);
        layer1.backgroundColor = color.CGColor
        
        repl.addSublayer(layer1)
        let anim = CABasicAnimation()
        anim.keyPath = "transform.scale.y"
        anim.toValue = 0.1
        anim.duration = 0.4
        anim.repeatCount = MAXFLOAT
        anim.removedOnCompletion = false
        anim.fillMode = kCAFillModeForwards        
        anim.autoreverses = true
        layer1.addAnimation(anim, forKey: nil)
        repl.instanceCount = 4
        repl.instanceTransform = CATransform3DMakeTranslation(8, 0, 0)
        repl.instanceDelay = 0.1
        repl.instanceGreenOffset = 0
    }

}
