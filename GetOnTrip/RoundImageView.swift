//
//  RoundImageView.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/28.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {

    var arrayImage: [UIImage] = [UIImage]() {
        didSet {
            orderImageViews()
            arrayM.enumerateObjectsUsingBlock {[weak self] (obj, index, stop) -> Void in
                let i = ((self?.arrayImage.count ?? 0) + index - 1) % (self?.arrayImage.count ?? 0)
                (obj as! UIImageView).image = self?.arrayImage[i]
            }
        }
    }
    
    lazy var index: Int = 0
    
    lazy var arrayM: NSMutableArray = { [weak self] in
        var array = NSMutableArray()
        for _ in 0...3 {
            let iv = UIImageView()
            self?.addSubview(iv)
            array.addObject(iv)
        }
        return array
    }()
    
    lazy var moving: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "leftRoundAction")
        swipeLeft.direction = .Left
        addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "rightRoundAction")
        swipeRight.direction = .Right
        addGestureRecognizer(swipeRight)
        
        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func orderImageViews() {
        let w: CGFloat = bounds.size.width
        let h: CGFloat = bounds.size.height
        
        let i1 = arrayM[0] as! UIImageView
        let i2 = arrayM[1] as! UIImageView
        let i3 = arrayM[3] as! UIImageView
        
        i1.frame = CGRectMake(-w, 0, w, h)
        i2.frame = CGRectMake(0, 0, w, h)
        i3.frame = CGRectMake(2, 0, w, h)
        
        bringSubviewToFront(i1)
    }
    
    /// 左滑
    func leftRoundAction() {
        if moving { return }
        moving = true
        index--
        arrayM.exchangeObjectAtIndex(0, withObjectAtIndex: 1)
        arrayM.exchangeObjectAtIndex(1, withObjectAtIndex: 2)
        index = (index + arrayImage.count) % arrayImage.count
        let image1 = arrayM[1] as! UIImageView
        
        image1.image = arrayImage[index]
        UIView.animateWithDuration(0.5, animations: { [weak self] () -> Void in
            self?.orderImageViews()
            }) { [weak self] (_) -> Void in
                self?.moving = false
        }
    }
    
    /// 右滑
    func rightRoundAction() {
        if moving { return }
        moving = true
        index--
        arrayM.exchangeObjectAtIndex(1, withObjectAtIndex: 2)
        arrayM.exchangeObjectAtIndex(0, withObjectAtIndex: 1)
        index = (index + arrayImage.count) % arrayImage.count
        let i1 = arrayM[1] as! UIImageView
        i1.image = arrayImage[index]
        UIView.animateWithDuration(0.5, animations: { [weak self] () -> Void in
            self?.orderImageViews()
            }) { [weak self] (_) -> Void in
                self?.moving = false
        }
    }

}
