//
//  TopicDetailInnerViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/12.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class TopicDetailViewController: UIViewController {
    
    // MARK: Outlets and Properties

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var showCommentCountButton: UIBarButtonItem!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var topic:Topic?
    
    var topicURL:String?
    
    // MARK: View Life Circle
    
    override func viewDidLoad() {
        //load data
        let newTitle = topic?.sight
        
        showCommentCountButton.title = "\(topic?.commentCount ?? 0)条评论"
        showCommentCountButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(11)], forState: UIControlState.Normal)
        if let topicid = topic?.topicid {
            self.topicURL = AppIni.BaseUri + "/topic/detail/preview?id=\(topicid)"
        }
        
        //init webview
        webView.backgroundColor = UIColor.whiteColor()
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .All
        webView.scrollView.showsHorizontalScrollIndicator = false
        
        //load html
        loadWebURL()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //修改navigationbar
        refreshBar()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //还原navigationbar
        if let masterView = self.parentViewController?.navigationController as? MasterViewController {
            masterView.refreshBar()
        }
        //还原statusbar
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    func refreshBar(){
        //设置statusbar
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        //设置navigationbar
        self.parentViewController?.navigationController?.navigationBar.barTintColor = SceneColor.crystalWhite
        self.parentViewController?.navigationController?.navigationBar.tintColor = SceneColor.lightGray
        self.parentViewController?.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : SceneColor.lightGray, NSFontAttributeName: UIFont.systemFontOfSize(12)]
    }
    
    func loadWebURL() {
        if let url = self.topicURL {
//            println("loadURL=\(url)")
            if let requestURL = NSURL(string: url) {
                let request = NSURLRequest(URL: requestURL)
                webView.loadRequest(request)
            }
        }
    }
    
    
    // MARK: UIWebViewDelegate
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
        let localizedErrorMessage = NSLocalizedString("An error occured:", comment: "")
        
        let errorHTML = "<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">\(localizedErrorMessage) \(error.localizedDescription)</div></body></html>"
        
        webView.loadHTMLString(errorHTML, baseURL: nil)
    }
    
    // MARK: Actions
    
    @IBAction func doFavorite(sender: UIBarButtonItem) {
        println("doFavorite")
    }
    @IBAction func doSharing(sender: UIBarButtonItem) {
        println("doSharing")
    }
    @IBAction func doComment(sender: UIBarButtonItem) {
        println("doComment")
    }
}
