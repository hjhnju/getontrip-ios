//
//  SightDetailController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/14.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class SightDetailController: UIViewController {

    lazy var webView: UIWebView = UIWebView()
    
    var url: String? {
        didSet {
            
            let urlStr = url?.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            webView.loadRequest(NSURLRequest(URL: NSURL(string: urlStr!)!))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        webView.frame = view.bounds
    }

}
