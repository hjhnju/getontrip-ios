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
//            webView.loadRequest(NSURLRequest(URL: NSURL(string: url!)!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 30))
            print(url!)
//            webView.loadRequest(NSURLRequest(URL: NSURL(string: url!)!))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
//        view.ff_Fill(webView)
        webView.frame = view.bounds
    }

}
