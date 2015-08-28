//
//  TopicDetailInnerViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/12.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import SDWebImage

class TopicDetailViewController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {
    
    // MARK: Outlets and Properties

    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var showCommentCountButton: UIBarButtonItem!
    
    // 收藏
    @IBOutlet weak var visits: UILabel!
    // 喜欢
    @IBOutlet weak var favorites: UILabel!
    // 标签
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    
    var topic:Topic? {
        didSet {
            loadTopic()
        }
    }
    
    var topicURL:String?
    
    // MARK: View Life Circle
    
    override func viewDidLoad() {
        //load data
        loadTopic()
        
        //init webview
        webView.backgroundColor = UIColor.whiteColor()
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .All
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.delegate = self
        webView.scrollView.contentInset = UIEdgeInsetsMake(355, 0, 0, 0)
        automaticallyAdjustsScrollViewInsets = false
        webView.delegate = self
        //load html
        loadWebURL()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var height = -(scrollView.contentOffset.y + 44)
        if height < 44 {
            height = 0
        }
        
        topHeightConstraint.constant = height
        
        var alpha = abs(64/scrollView.contentOffset.y)
        if scrollView.contentOffset.y > 44 {
            alpha = 1.0
        }
        
    }
    
    func loadTopic(){
        if let topic = topic {
            //navbar
            self.navigationItem.title = topic.sight
            
            //toolbar
            showCommentCountButton?.title = "\(topic.commentCount ?? 0)条评论"
            showCommentCountButton?.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(11)], forState: UIControlState.Normal)
            topicURL = AppIniOnline.BaseUri + "/topic/detail?id=\(topic.topicid)"
        }
    }
    
    // 即将显示的时候各个控制加载完毕，开始加载控制内容
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //修改navigationbar
        refreshBar()
        
        iconView.sd_setImageWithURL(NSURL(string: topic!.imageUrl!))
        
        
        for (var i: Int = 0; i < topic?.tags?.count; i++ ) {
            
            var tagsLabel: String = " " + (topic!.tags![i] as! String) as String + " "

            if (i == 0){
                label1.hidden = false
                label1.text = tagsLabel
                label1.sizeToFit()
            } else if(i == 1){
                label2.hidden = false
                label2.text = tagsLabel
                label2.sizeToFit()
            } else if (i == 2){
                label3.hidden = false
                label3.text = tagsLabel
                label3.sizeToFit()
            } else if(i == 3){
                label4.hidden = false
                label4.text = tagsLabel
                label4.sizeToFit()
            }
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //还原navigationbar
        if let masterView = self.navigationController as? MasterViewController {
            masterView.refreshBar()
        }
        //还原statusbar
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    func refreshBar(){
        //设置statusbar
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        //设置navigationbar
        self.navigationController?.navigationBar.barTintColor = SceneColor.crystalWhite
        self.navigationController?.navigationBar.tintColor = SceneColor.lightGray
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName : SceneColor.lightGray, NSFontAttributeName: UIFont.systemFontOfSize(12)]
    }
    
    func loadWebURL() {
        if let url = self.topicURL {
//            println("loadURL=\(url)")
            if let requestURL = NSURL(string: url + "&isapp=1") {
                let request = NSURLRequest(URL: requestURL)
                //URL: http://123.57.46.229:8301/topic/detail/preview?id=23&isapp=1
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
    
    // TODO: 以截取Range方式进行应用间跳转，如果不是我方协议就跳转，但以后需改
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        println(request)
        
        var url = request.URL?.absoluteString
        let index = advance(url!.startIndex, 20)
        var range = Range<String.Index>(start: url!.startIndex, end: index)
                                             // 01
        println(url?.substringWithRange(range))
        if url?.substringWithRange(range) == "http://123.57.67.165" {
            return true
        }
        
        UIApplication.sharedApplication().openURL(NSURL(string: url!)!)
        return false
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
