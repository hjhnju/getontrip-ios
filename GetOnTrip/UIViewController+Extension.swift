//
//  UIViewController+Extension.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/2.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation


extension UIViewController {
    
    // MARK: 自定义方法
    
    func popViewAction(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
        //TODO: 不管push还是present都调用了，没出错
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchAction(button: UIButton) {
        //fix 搜索pushviewController问题
        self.definesPresentationContext = true
        let svc = SearchViewController()
        presentViewController(svc, animated: true, completion: nil)
    }
}
