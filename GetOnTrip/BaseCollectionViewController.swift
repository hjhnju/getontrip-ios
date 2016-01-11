//
//  BaseCollectionViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/11.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class BaseCollectionViewController: UICollectionViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        MobClick.beginLogPageView("\(classForCoder)")
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        MobClick.endLogPageView("\(classForCoder)")
    }
    
    
}
