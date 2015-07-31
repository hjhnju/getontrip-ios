//
//  MainViewController2.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/30.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    //MASK: Actions
    
    @IBAction func showMenu(sender: UIBarButtonItem) {
        if let masterNavCon = self.parentViewController as? MasterViewController {
            masterNavCon.slideDelegate?.displayMenu()
        }
    }

}
