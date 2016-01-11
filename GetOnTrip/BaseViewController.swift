//
//  BaseViewController.swift
//  TestTransitioning
//
//  Created by 何俊华 on 15/11/3.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        MobClick.beginLogPageView("\(classForCoder)")
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        MobClick.endLogPageView("\(classForCoder)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
