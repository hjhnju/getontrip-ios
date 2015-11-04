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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 自定义方法
    
    func popViewAction(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
        //TODO: 不管push还是present都调用了，没出错
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func searchAction(button: UIBarButtonItem) {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }

    
}
