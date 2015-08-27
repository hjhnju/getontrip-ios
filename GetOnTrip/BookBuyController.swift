//
//  BookBuyController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/26.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class BookBuyController: UIViewController {

    lazy var webView: UIWebView = {
        let webView = UIWebView()
        return webView
        }()
    
    var requestURL: String? {
        didSet {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: requestURL!)!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 30))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.frame = view.frame
    }
}
