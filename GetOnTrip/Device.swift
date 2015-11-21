//
//  Device.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/22.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class Device {
    
    class func isWeixinInstalled() -> Bool {
        var isInstalled: Bool = false
        if let nsurl = NSURL(string: "weixin://") {
            isInstalled = UIApplication.sharedApplication().canOpenURL(nsurl)
        }
        return isInstalled
    }
    
    class func isQQInstalled() -> Bool {
        var isInstalled: Bool = false
        if let nsurl = NSURL(string: "mqqapi://") {
            isInstalled = UIApplication.sharedApplication().canOpenURL(nsurl)
        }
        return isInstalled
    }
    
    class func isIPad() -> Bool {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            return true
        }
        return false
    }
}