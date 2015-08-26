//
//  CyclopaedicDetailController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/26.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class CyclopaedicDetailController: UIViewController {

    lazy var webView: UIWebView = {
        let webView = UIWebView()
        return webView
    }()
    
    var requestURL: String? {
        didSet {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: requestURL!)!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 30))
//                NSURLRequest(URL: NSURL(string: requestURL!)!))
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
