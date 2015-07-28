//
//  navigationItemView.swift
//  GetOnTrip
//
//  Created by guojinli on 15/7/27.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class NavigationItemView: UIView {
    class func CreateLeftItem(controller: MenuViewController) ->UIBarButtonItem {
        var image  = UIImage(named:"hamburger.png")
        var button  =  UIButton.buttonWithType(UIButtonType.System) as? UIButton
        button!.frame =  CGRectMake(0, 0, 44.0, 44.0)
        button!.addTarget(controller,action:"tappedButton:",forControlEvents:UIControlEvents.TouchUpInside)
        button!.setImage(image,forState:UIControlState.Normal)
        var barButton =  UIBarButtonItem(customView: button!)
        
        return barButton
    }
}
