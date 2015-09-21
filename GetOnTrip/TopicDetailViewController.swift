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
    
    // MARK: 相关属性
    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var showCommentCountButton: UIBarButtonItem!
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    /// 收藏
    @IBOutlet weak var visits: UILabel!
    /// 喜欢
    @IBOutlet weak var favorites: UILabel!
    /// 标签
    @IBOutlet weak var label1: UILabel!
    var topic:Topic? {
        didSet {
//            http://123.57.46.229:8301/api/find?pageSize=8&page=1
            loadTopic()
        }
    }
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    
    var topicURL:String?
    
    // MARK: 初始化相关
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
    
    // 即将显示的时候各个控制加载完毕，开始加载控制内容
    func loadTopic(){
        if let topic = topic {
            //navbar
            self.navigationItem.title = topic.sight
            
            //toolbar
            showCommentCountButton?.title = "topic.comment" ?? "0" + "条评论"
            showCommentCountButton?.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(11)], forState: UIControlState.Normal)
            topicURL = AppIni.BaseUri + "/topic/detail?id=\(topic.id)"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //修改navigationbar
        refreshBar()
        
        iconView.sd_setImageWithURL(NSURL(string: topic!.image!))
//        visits.text = "\(topic!.visits!)"
        favorites.text = "\(topic!.collect!)"
        titleLabel.text = topic?.title
        
        for (var i: Int = 0; i < topic?.tags?.count; i++ ) {
            let tagsLabel: String = " " + (topic!.tags![i] as! String) as String + " "
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
            if let requestURL = NSURL(string: url + "&isapp=1") {
                let request = NSURLRequest(URL: requestURL)
                
                webView.loadRequest(request)
            }
        }
    }
    
    
    // MARK: UIWebView and UIScrollView Delegate 代理方法
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        let localizedErrorMessage = NSLocalizedString("An error occured:", comment: "")
        
        let errorHTML = "<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">\(localizedErrorMessage) \(error!.localizedDescription)</div></body></html>"
        
        webView.loadHTMLString(errorHTML, baseURL: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let navigationBarHeight: CGFloat = 44
        var height = -(scrollView.contentOffset.y + navigationBarHeight)
        if height < navigationBarHeight {
            height = 0
        }
        
        topHeightConstraint.constant = height
    }
    
    // TODO: 以截取Range方式进行应用间跳转，如果不是我方协议就跳转，但以后需改
//    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        
//        
//        let url = request.URL?.absoluteString
//        let index = advance(url!.startIndex, 20)
//        let range = Range<String.Index>(start: url!.startIndex, end: index)
//        if url?.substringWithRange(range) == "http://123.57.46.229" {
//            return true
//        }
//        
//        UIApplication.sharedApplication().openURL(NSURL(string: url!)!)
//        return false
//    }
    
    
    // MARK: Actions
    
    @IBAction func doFavorite(sender: UIBarButtonItem) {
        print("doFavorite")
    }
    @IBAction func doSharing(sender: UIBarButtonItem) {
        
        
        //1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.SSDKSetupShareParamsByText("分享内容",
            images : UIImage(named: "shareImg.png"),
            url : NSURL(string:"http://mob.com"),
            title : "分享标题",
            type : SSDKContentType.Auto)
        //2.进行分享
        ShareSDK.showShareActionSheet(self.view, items: nil, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userdata : [NSObject : AnyObject]!, contentEnity : SSDKContentEntity!, error : NSError!, Bool end) -> Void in
            
            switch state{
                
            case SSDKResponseState.Success: print("分享成功")
            case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  print("分享取消")
                
            default:
                break
            }
        }
        
        
        
    }
    @IBAction func doComment(sender: UIBarButtonItem) {
        
        let sendPopoverAnimator = SendPopoverAnimator()
        let story1 = UIStoryboard(name: "TopicDetail", bundle: nil)
        let vc = story1.instantiateViewControllerWithIdentifier("sendComment") as! SendCommentController
//        let vc = SendCommentController()
        
        // 1. 设置`转场 transitioning`代理
        vc.transitioningDelegate = sendPopoverAnimator
        // 2. 设置视图的展现大小
        let h: CGFloat = 444
        let w: CGFloat = UIScreen.mainScreen().bounds.width
        let y: CGFloat = UIScreen.mainScreen().bounds.height - 44 - h
        sendPopoverAnimator.presentFrame = CGRectMake(0, y, w, h)
//        sendPopoverAnimator.presentFrame = CGRectMake(100, 100, 100, 100)
        vc.view.clipsToBounds = true
        // 3. 设置专场的模式 - 自定义转场动画
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    
    // TODO:测试webview
    
//    func showTopicDetail() {
//        var html = NSMutableString()
//        html.appendString("<html><head>")
//        html.appendFormat("<link rel=\"stylesheet\" href=\"%@\">", NSBundle.mainBundle().URLForResource("TopicDetail.css", withExtension: nil)!)
//        html.appendString("</head><body>")
//        html.appendString("")
//        html.appendString("</body></html>")
//        webView.loadHTMLString(html as String, baseURL: nil)
//    }
   /*
    /**
    *  初始化body内容
    */
    func setupBody() -> String{
        var body = NSMutableString()
        body.appendFormat("<div class=\"title\">%@</div>", "标题")
        body.appendFormat("<div class=\"time\">%@</div>", "时间")
        body.appendString("数据体")
        for img in detail.img {
            var imgHtml = NSMutableString()
            imgHtml.appendString("<div class=\"img-parent\">")
            
            let pixel = "".componentsSeparatedByString("*")
            let width: Int = Int(pixel.first)
            let height: Int = Int(pixel.last)
            var
        }
        
        
        
        return body as String
    }
    
       // 拼接图片
    [body appendString:self.detail.body];
    for (HMNewsDetailImg *img in self.detail.img) {
    // 图片的html字符串
    NSMutableString *imgHtml = [NSMutableString string];
    [imgHtml appendString:@"<div class=\"img-parent\">"];
    
    // img.pixel = 500*332
    NSArray *pixel = [img.pixel componentsSeparatedByString:@"*"];
    int width = [[pixel firstObject] intValue];
    int height = [[pixel lastObject] intValue];
    int maxWidth = [UIScreen mainScreen].bounds.size.width * 0.8;
    if (width > maxWidth) { // 限制尺寸
    height = height * maxWidth / width;
    width = maxWidth;
    }
    
    NSString *onload = @"this.onclick = function() {"
    "   window.location.href = 'hm:src=' + this.src;"
    "};";
    
    [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%d\" height=\"%d\" src=\"%@\">", onload, width, height, img.src];
    [imgHtml appendString:@"</div>"];
    
    // 将img.ref替换为img标签的内容
    [body replaceOccurrencesOfString:img.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
    }
    */

    
    
    
    
    
    
}
