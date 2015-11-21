//
//  Replay.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/21.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

class Replay: NSObject {
    
    var id: String = ""
    
    var content: String = ""
    
    var from_name: String = ""
    
    var to_name: String = ""
    
    var from_user_id: String = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
