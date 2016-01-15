//
//  PlayFrequencyRequest.swift
//  GetOnTrip
//
//  Created by 王振坤 on 16/1/15.
//  Copyright © 2016年 Joshua. All rights reserved.
//

import UIKit

class PlayFrequencyRequest: NSObject {
    
    class func fetchModels(url: String, handler:(data: NSData?, status: Int) -> ()) {
        
        HttpRequest.ajax3(url, path: AppIni.BaseUri) { (result, status) -> () in
            handler(data: result, status: status)
        }
    }
    
}
