//
//  ScrolledImageUIView.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/28.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import SDWebImage

class ScrolledImageUIView: UIView {
    
    // MARK: Properties
    
    //ImageView比View上下分别增高量
    let extra:CGFloat = 60
    
    //图片View
    var imageView:UIImageView = UIImageView()
    
    //ImageView的y轴偏移因子 [-1.0, 1.0]， 注意y以UIView为基准
    //默认yOffset=0, 上拉最大幅度时yOffset=extra, 下拉最大幅度yOffset=-extra
    //对应factor=0.0, 1.0, -1.0
    var factor:CGFloat? {
        didSet {
            if let factor = factor {
                let yOffset = extra * factor
                let y       = -extra + yOffset
                let height  = self.frame.size.height + 2 * extra
                let width   = self.frame.size.width
                imageView.frame = CGRectMake(0, y, width, height)
            }
        }
    }
    
    // MARK: View Life Circle
    
    //Storyboard中通过这个初始化
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    func updateUI(){
        self.clipsToBounds   = true
        self.backgroundColor = UIColor.orangeColor()
        self.layer.cornerRadius = 3
        
        imageView.contentMode   = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.blueColor()
        
        self.addSubview(imageView)
        self.bringSubviewToFront(imageView)
    }
    
    func loadImage(url:NSURL){
        self.imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default-sight"))
        self.factor = 0.0
    }
}