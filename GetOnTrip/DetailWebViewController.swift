//
//  SightDetailController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/14.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class DetailWebViewController: UIViewController {

    lazy var webView: UIWebView = UIWebView()
    
    var url: String? {
        didSet {
            if let urlStr = url?.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
                webView.loadRequest(NSURLRequest(URL: NSURL(string: urlStr)!))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SceneColor.frontBlack
        webView.backgroundColor = UIColor.clearColor()
        
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true
        navigationItem.backBarButtonItem  = UIBarButtonItem(title: "途知", style: .Plain, target: nil, action: nil)

        view.addSubview(webView)
        webView.frame = view.bounds
    }
    
    ///  搜索跳入之后消失控制器
    func dismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
