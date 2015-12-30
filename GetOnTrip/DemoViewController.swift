//
//  DemoViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/30.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController, UITextFieldDelegate {

    lazy var searchBar: SearchBar = SearchBar(frame: CGRectMake(0, 0, Frame.screen.width, 35))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(searchBar)
        searchBar.frame = CGRectMake(0, 0, Frame.screen.width, 35)
        searchBar.backgroundColor = UIColor.randomColor()
        
        view.backgroundColor = .randomColor()
        
        searchBar.textFile.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    textFieldShouldBeginEditing
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.view.alpha = 1
        }
        return true
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
