//
//  UIViewController+Extension.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/2.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation


extension UIViewController {
    
    func popViewAction(button: UIButton) {
        if let nav = navigationController {
            nav.popViewControllerAnimated(true)
        }
        //TODO: 不管push还是present都调用了，没出错
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchAction(button: UIBarButtonItem) {
        presentViewController(SearchViewController(), animated: true, completion: nil)
    }
}
