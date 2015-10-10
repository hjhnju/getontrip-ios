
//
//  TopicDetailController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class TopicDetailController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate  {
    
    // MARK: 相关属性
    var topHeightConstraint: NSLayoutConstraint?
//    var iconBack: CGFloat?
    
    lazy var iconBack: UIView = UIView()
    
    lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "bg.jpg"))
    
    lazy var webView: UIWebView = UIWebView()
    
    /// 标题
    lazy var titleLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "长白山天池湖水只出不进，为何终年不减只出不进？", fontSize: 24, mutiLines: false)
    
    /// 标签
    lazy var labelBtn: UIButton = UIButton(title: "历史", fontSize: 9, radius: 3, titleColor: UIColor.whiteColor())
    
    lazy var collect: UIButton = UIButton(image: "eye", title: " 18", fontSize: 12, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.7))
    
    lazy var visit: UIButton = UIButton(image: "eye", title: " 90", fontSize: 12, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.7))
    
    lazy var bottomView: UIView = UIView()
    
    lazy var commentLab: UILabel = UILabel(color: UIColor(hex: 0x9C9C9C, alpha: 1.0), title: "11条评论", fontSize: 11, mutiLines: true)
    
    lazy var commentBtn: UIButton = UIButton(image: "favorite", title: "", fontSize: 0)

    lazy var shareBtn: UIButton = UIButton(image: "favorite", title: "", fontSize: 0)
    
    lazy var collectBtn: UIButton = UIButton(image: "favorite", title: "", fontSize: 0)
    
    var topicDetail: TopicDetail? {
        didSet {
//            NSURLRequest(URL: NSURL(string: topicDetail!.url!)!)
//            webView.loadRequest(NSURLRequest(URL: NSURL(string: topicDetail!.url!)!))
            webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.baidu.com")!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 30))
            iconView.sd_setImageWithURL(NSURL(string: topicDetail!.image!))
        }
    }
    
    /// 详情ID必有
    var topicId: String?
    
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: TopicDetailRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshBar()
        loadSightData()
        setupAddProperty()
        setupAutoLayout()
    }
    
    private func setupAddProperty() {
    
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(webView)
        view.addSubview(iconBack)
        view.addSubview(bottomView)
        iconBack.addSubview(iconView)
        iconBack.addSubview(titleLabel)
        iconBack.addSubview(labelBtn)
        iconBack.addSubview(collect)
        iconBack.addSubview(visit)
        bottomView.addSubview(commentLab)
        bottomView.addSubview(commentBtn)
        bottomView.addSubview(shareBtn)
        bottomView.addSubview(collectBtn)
        
        titleLabel.numberOfLines = 2
        titleLabel.preferredMaxLayoutWidth = view.bounds.width - 20
        iconView.contentMode = UIViewContentMode.ScaleAspectFill
        iconView.clipsToBounds = true

        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .All
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.delegate = self
        webView.scrollView.contentInset = UIEdgeInsetsMake(267, 0, 0, 0)
        automaticallyAdjustsScrollViewInsets = false
        webView.delegate = self
        
    }
    
    private func setupAutoLayout() {
        
        let cons = iconBack.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, 267), offset: CGPointMake(0, 0))
        webView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - 47), offset: CGPointMake(0, 0))
        bottomView.ff_AlignInner(ff_AlignType.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, 47), offset: CGPointMake(0, 0))
        iconView.ff_Fill(bottomView)
        labelBtn.ff_AlignInner(ff_AlignType.TopRight, referView: iconBack, size: CGSizeMake(32, 14), offset: CGPointMake(17, 7))
        collect.ff_AlignInner(ff_AlignType.BottomLeft, referView: iconBack, size: nil, offset: CGPointMake(10, -7))
        visit.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: collect, size: nil, offset: CGPointMake(11, 0))
        titleLabel.ff_AlignVertical(ff_AlignType.TopLeft, referView: collect, size: nil, offset: CGPointMake(0, 1))
        commentLab.ff_AlignInner(ff_AlignType.CenterLeft, referView: bottomView, size: nil, offset: CGPointMake(14, 0))
        commentBtn.ff_AlignInner(ff_AlignType.CenterRight, referView: bottomView, size: CGSizeMake(28, 28), offset: CGPointMake(-10, 0))
        shareBtn.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: commentBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        collectBtn.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: shareBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        
        topHeightConstraint = iconBack.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
//        for constraint in bottomView.constraints {
//            if constraint.firstAttribute == NSLayoutAttribute.Height {
//                topHeightConstraint = constraint
//            }
//        }
        
    }
    
    
    /// 发送反馈消息
    private func loadSightData() {
        
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = TopicDetailRequest()
            lastSuccessAddRequest?.topicId = topicId
        }
        
        lastSuccessAddRequest?.fetchTopicDetailModels {[unowned self] (handler: TopicDetail) -> Void in
            self.topicDetail = handler
        }
    }
    
    func refreshBar(){
        //设置statusbar
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        //设置navigationbar
//        navigationController?.navigationBar.barTintColor = SceneColor.crystalWhite
//        navigationController?.navigationBar.tintColor = SceneColor.lightGray
//        navigationController?.navigationBar.titleTextAttributes =
//        [NSForegroundColorAttributeName : SceneColor.lightGray, NSFontAttributeName: UIFont.systemFontOfSize(12)]
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        //还原navigationbar
//        if let masterView = self.navigationController as? MasterViewController {
//            masterView.refreshBar()
//        }
//        //还原statusbar
//        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    
    
    
//    func loadWebURL() {
//        if let url = self.topicURL {
//            if let requestURL = NSURL(string: url + "&isapp=1") {
//                let request = NSURLRequest(URL: requestURL)
//                
//                webView.loadRequest(request)
//            }
//        }
//    }
    
    
    // MARK: UIWebView and UIScrollView Delegate 代理方法
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        let localizedErrorMessage = NSLocalizedString("An error occured:", comment: "")
        
        let errorHTML = "<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">\(localizedErrorMessage) \(error!.localizedDescription)</div></body></html>"
        
        webView.loadHTMLString(errorHTML, baseURL: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let navigationBarHeight: CGFloat = 0
        var height = -(scrollView.contentOffset.y + navigationBarHeight)
        if height < 44 {
            height = 44
        }
        topHeightConstraint?.constant = height
    }
    
    // TODO: 以截取Range方式进行应用间跳转，如果不是我方协议就跳转，但以后需改
//    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    
        
//        var url = request.URL?.absoluteString
//        let index = advance(url!.startIndex, 20)
//        var range = Range<String.Index>(start: url!.startIndex, end: index)
//        if url?.substringWithRange(range) == "http://123.57.46.229" {
//            return true
//        }
//        
//        UIApplication.sharedApplication().openURL(NSURL(string: url!)!)
//        return false
//    }
    
    
    // MARK: Actions
    
    func doFavorite(sender: UIBarButtonItem) {
//        println("doFavorite")
    }
    func doSharing(sender: UIBarButtonItem) {
        
//        
//        //1.创建分享参数
//        var shareParames = NSMutableDictionary()
//        shareParames.SSDKSetupShareParamsByText("分享内容",
//            images : UIImage(named: "shareImg.png"),
//            url : NSURL(string:"http://mob.com"),
//            title : "分享标题",
//            type : SSDKContentType.Auto)
//        //2.进行分享
//        ShareSDK.showShareActionSheet(self.view, items: nil, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userdata : [NSObject : AnyObject]!, contentEnity : SSDKContentEntity!, error : NSError!, Bool end) -> Void in
//            
//            switch state{
//                
//            case SSDKResponseState.Success: println("分享成功")
//            case SSDKResponseState.Fail:    println("分享失败,错误描述:\(error)")
//            case SSDKResponseState.Cancel:  println("分享取消")
//                
//            default:
//                break
//            }
//        }
        
        
        
    }
   func doComment(sender: UIBarButtonItem) {
        
//        let sendPopoverAnimator = SendPopoverAnimator()
//        let story1 = UIStoryboard(name: "TopicDetail", bundle: nil)
//        let vc = story1.instantiateViewControllerWithIdentifier("sendComment") as! SendCommentController
//        //        let vc = SendCommentController()
//        
//        // 1. 设置`转场 transitioning`代理
//        vc.transitioningDelegate = sendPopoverAnimator
//        // 2. 设置视图的展现大小
//        let h: CGFloat = 444
//        let w: CGFloat = UIScreen.mainScreen().bounds.width
//        let y: CGFloat = UIScreen.mainScreen().bounds.height - 44 - h
//        sendPopoverAnimator.presentFrame = CGRectMake(0, y, w, h)
//        //        sendPopoverAnimator.presentFrame = CGRectMake(100, 100, 100, 100)
//        vc.view.clipsToBounds = true
//        // 3. 设置专场的模式 - 自定义转场动画
//        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
//        
//        presentViewController(vc, animated: true, completion: nil)
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



