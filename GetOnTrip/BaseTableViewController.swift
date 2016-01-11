//
//  BaseTableViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/18.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        MobClick.beginLogPageView("\(classForCoder)")
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        MobClick.endLogPageView("\(classForCoder)")
    }

}
