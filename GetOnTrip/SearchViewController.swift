//
//  SearchViewController.swift
//  GetOnTrip
//
//  Created by guojinli on 15/7/28.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {


    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
}
