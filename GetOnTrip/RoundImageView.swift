//
//  RoundImageView.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/28.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import SDWebImage

class RoundImageView: UIView {

    lazy var moving: Bool = false
    
    var index: Int = 0
        
    var arrayImage: [String] = [String]() {
        didSet {
            orderImageViews()
            arrayM.enumerateObjectsUsingBlock { (obj, idx, stop) -> Void in
                let i = (self.arrayImage.count + idx - 1) % self.arrayImage.count
                (obj as! UIImageView).sd_setImageWithURL(NSURL(string: self.arrayImage[i]), placeholderImage: PlaceholderImage.defaultSmall)
            }
        }
    }
    
    lazy var arrayM: NSMutableArray = NSMutableArray()
    
    private func orderImageViews() {
        let w: CGFloat = bounds.size.width
        let h: CGFloat = bounds.size.height
        
        let i0 = arrayM[0] as! UIImageView
        let i1 = arrayM[1] as! UIImageView
        let i2 = arrayM[2] as! UIImageView
        
        i0.frame = CGRectMake(-w, 0, w, h)
        i1.frame = CGRectMake(0, 0, w, h)
        i2.frame = CGRectMake(w, 0, w, h)
        
        bringSubviewToFront(i1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        initGesture()
    }
    
    private func initView() {
        for _ in 0...2 {
            let imageView = UIImageView()
            addSubview(imageView)
            arrayM.addObject(imageView)
        }
        
        clipsToBounds = true
    }
    
    private func initGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipeLeftAction")
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "swipeRightActiona")
        swipeLeft.direction = .Left
        swipeRight.direction = .Right
        addGestureRecognizer(swipeLeft)
        addGestureRecognizer(swipeRight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func swipeLeftAction() {
        if moving { return }
        index++
        arrayM.exchangeObjectAtIndex(0, withObjectAtIndex: 1)
        arrayM.exchangeObjectAtIndex(1, withObjectAtIndex: 2)
        index = (index + arrayImage.count) % arrayImage.count
        let i1 = arrayM[1] as! UIImageView
        i1.sd_setImageWithURL(NSURL(string: arrayImage[index]), placeholderImage: PlaceholderImage.defaultSmall)

        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.orderImageViews()
            }) { (_) -> Void in
                self.moving = false
        }
    }
    
    func swipeRightActiona() {
        if moving { return }
        moving = true
        index--
        arrayM.exchangeObjectAtIndex(1, withObjectAtIndex: 2)
        arrayM.exchangeObjectAtIndex(0, withObjectAtIndex: 1)
        index = (index + arrayImage.count) % arrayImage.count
        let i1 = arrayM[1] as! UIImageView

        i1.sd_setImageWithURL(NSURL(string: arrayImage[index]), placeholderImage: PlaceholderImage.defaultSmall)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.orderImageViews()
            }) { (_) -> Void in
                self.moving = false
        }
    }
}
