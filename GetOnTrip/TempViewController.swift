//
//  TempViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/30.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {

    var demoVC = DemoViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        addChildViewController(demoVC)
        view.addSubview(demoVC.view)
        demoVC.view.alpha = 0.0
        
        view.backgroundColor = UIColor.randomColor()
        view.addSubview(demoVC.searchBar)
        demoVC.searchBar.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(Frame.screen.width, 100), offset: CGPointMake(0, 30))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
