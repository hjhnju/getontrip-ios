
//
//  TopicDetailController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class TopicDetailController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {
    
    // MARK: 相关属性
    
    //导航景点名
    lazy var navTitleLabel: UILabel = UILabel(color: SceneColor.lightGray, title: "", fontSize: 14, mutiLines: false)
    
    //头部视图
    lazy var headerView: UIView = UIView()
    
    //头部视图高度约束
    var headerHeightConstraint: NSLayoutConstraint?
    
    lazy var headerImageView: UIImageView = UIImageView()
    
    lazy var titleLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "", fontSize: 24, mutiLines: false)
    
    lazy var labelBtn: UIButton = UIButton(title: "", fontSize: 9, radius: 3, titleColor: UIColor.whiteColor())
    
    lazy var favNumLabel: UIButton = UIButton(image: "icon_star_light", title: "", fontSize: 12, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.7))

    lazy var visitNumLabel: UIButton = UIButton(image: "icon_visit_light", title: "", fontSize: 12, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.7))
    
    //webView
    lazy var webView: UIWebView = UIWebView()
    
    //底部工具栏
    lazy var toolbarView: UIView = UIView()
    
    lazy var commentLab: UILabel = UILabel(color: UIColor(hex: 0x9C9C9C, alpha: 1.0), title: "", fontSize: 11, mutiLines: true)
    
    lazy var commentBtn: UIButton = UIButton(image: "topic_comment", title: "", fontSize: 0)

    lazy var shareBtn: UIButton = UIButton(image: "topic_share", title: "", fontSize: 0)
    
    lazy var collectBtn: UIButton = UIButton(image: "topic_star", title: "", fontSize: 0)
    
    var content: String?
    
    lazy var bottomLine: UIView = UIView(color: UIColor(hex: 0x9C9C9C, alpha: 1.0))
    
    lazy var cover: UIButton = UIButton(color: UIColor.blackColor(), alphaF: 0.0)
  
    lazy var shareView: UIView = UIView(color: UIColor.whiteColor(), alphaF: 1.0)
    
    lazy var shareBtn1: shareButton = shareButton(image: "round", title: "微信好友", fontSize: 12, titleColor: UIColor(hex: 0x696969, alpha: 1.0))
    
    lazy var shareBtn2: shareButton = shareButton(image: "round", title: "朋友圈", fontSize: 12, titleColor: UIColor(hex: 0x696969, alpha: 1.0))
    
    lazy var shareBtn3: shareButton = shareButton(image: "round", title: "新浪微博", fontSize: 12, titleColor: UIColor(hex: 0x696969, alpha: 1.0))
    
    lazy var shareBtn4: shareButton = shareButton(image: "round", title: "QQ空间", fontSize: 12, titleColor: UIColor(hex: 0x696969, alpha: 1.0))
    
    lazy var shareBtn5: shareButton = shareButton(image: "round", title: "复制链接", fontSize: 12, titleColor: UIColor(hex: 0x696969, alpha: 1.0))
    
    lazy var shareCancle: UIButton = UIButton(title: "取消", fontSize: 13, radius: 15)
    
    lazy var shareLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "分享至", fontSize: 13, mutiLines: true)
    
    var shareViewCY : NSLayoutConstraint?
    
    var shareBtnY1: NSLayoutConstraint?
    
    var shareBtnY2: NSLayoutConstraint?
    
    var shareBtnY3: NSLayoutConstraint?
    
    var shareBtnY4: NSLayoutConstraint?
    
    var shareBtnY5: NSLayoutConstraint?
    
    let shareParames = NSMutableDictionary()
    
    var commentVC: CommentTopicController = CommentTopicController()
    
    //话题ID
    var topicId: String = ""
    
    //话题标题
    var topicTitle: String = "" {
        didSet {
            titleLabel.text = topicTitle
        }
    }
    
    //景点名
    var sightName: String = "" {
        didSet {
            navTitleLabel.text = sightName
        }
    }
    
    var topicDetail: TopicDetail? {
        didSet {
            if let topic = topicDetail {
                content    = topic.content
                sightName  = topic.sight_name
                topicTitle = topic.title
                
                commentVC.topicId  = topic.id
                commentLab.text    = topic.comment
                
                labelBtn.setTitle(topic.label, forState: UIControlState.Normal)
                favNumLabel.setTitle(" " + topic.collect, forState: UIControlState.Normal)
                visitNumLabel.setTitle(" " + topic.visit, forState: UIControlState.Normal)
                headerImageView.sd_setImageWithURL(NSURL(string: topic.image))
                
                showTopicDetail()
                
                shareParames.SSDKSetupShareParamsByText(topic.sight_name,
                    images : UIImage(named: "shareImg.png"),
                    url : NSURL(string: AppIni.BaseUri + "/topic/detail?" + "id=\(topic.id)"),
                    title : topic.title,
                    type : SSDKContentType.Auto)
            }
        }
    }
    
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: TopicDetailRequest?
    
    
    //导航背景，用于完成渐变
    weak var navUnderlayView:UIView?
    
    //导航透明度
    var headerAlpha:CGFloat = 1.0
    
    // MARK: - 初始化方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //nav bar
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        navigationItem.titleView = navTitleLabel
        navigationController?.navigationBar.tintColor = SceneColor.lightGray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButtonClicked:")
        
        let bgImage = UIKitTools.imageWithColor(UIColor.whiteColor().colorWithAlphaComponent(0.5))
        navigationController?.navigationBar.setBackgroundImage(bgImage, forBarMetrics: UIBarMetrics.Default)
        
        refreshTitle()
        
        navTitleLabel.frame = CGRectMake(0, 0, 100, 21)
        navTitleLabel.textAlignment = NSTextAlignment.Center
        
        loadSightData()
        setupAddProperty()
        setupDefaultProperty()
        setupAutoLayout()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //还原
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.yellowColor()
    }
    
    func refreshTitle(){
        titleLabel.alpha = headerAlpha
        favNumLabel.alpha = headerAlpha
        visitNumLabel.alpha = headerAlpha
        labelBtn.alpha = headerAlpha
    }
    
    /// 发送反馈消息
    private func loadSightData() {
        
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = TopicDetailRequest()
            lastSuccessAddRequest?.topicId = topicId
        }
        
        lastSuccessAddRequest?.fetchTopicDetailModels {[weak self] (handler: TopicDetail) -> Void in
            self?.topicDetail = handler
        }
    }
    
    private func setupAddProperty() {

        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(webView)
        view.addSubview(headerView)
        view.addSubview(toolbarView)
        headerView.addSubview(headerImageView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(labelBtn)
        headerView.addSubview(favNumLabel)
        headerView.addSubview(visitNumLabel)
        toolbarView.addSubview(commentLab)
        toolbarView.addSubview(commentBtn)
        toolbarView.addSubview(shareBtn)
        toolbarView.addSubview(collectBtn)
        toolbarView.addSubview(bottomLine)
        
        view.addSubview(shareView)
        shareView.addSubview(shareLabel)
        shareView.addSubview(shareBtn1)
        shareView.addSubview(shareBtn2)
        shareView.addSubview(shareBtn3)
        shareView.addSubview(shareBtn4)
        shareView.addSubview(shareBtn5)
        shareView.addSubview(shareCancle)
        shareBtn1.tag = 1
        shareBtn2.tag = 2
        shareBtn3.tag = 3
        shareBtn4.tag = 4
        shareBtn5.tag = 5
        
        shareCancle.backgroundColor = SceneColor.lightYellow
        shareCancle.setTitleColor(SceneColor.bgBlack, forState: UIControlState.Normal)
    }
    
    private func setupDefaultProperty() {
        shareBtn.addTarget(self, action: "doSharing:", forControlEvents: UIControlEvents.TouchUpInside)
        collectBtn.addTarget(self, action: "doFavorite:", forControlEvents: UIControlEvents.TouchUpInside)
        commentBtn.addTarget(self, action: "doComment:", forControlEvents: UIControlEvents.TouchUpInside)
        cover.addTarget(self, action: "coverClick:", forControlEvents: UIControlEvents.TouchUpInside)
        shareCancle.addTarget(self, action: "shareCancleClick:", forControlEvents: UIControlEvents.TouchUpInside)
        shareBtn1.addTarget(self, action: "shareClick:", forControlEvents: UIControlEvents.TouchUpInside)
        shareBtn2.addTarget(self, action: "shareClick:", forControlEvents: UIControlEvents.TouchUpInside)
        shareBtn3.addTarget(self, action: "shareClick:", forControlEvents: UIControlEvents.TouchUpInside)
        shareBtn4.addTarget(self, action: "shareClick:", forControlEvents: UIControlEvents.TouchUpInside)
        shareBtn5.addTarget(self, action: "shareClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        titleLabel.numberOfLines = 2
        titleLabel.preferredMaxLayoutWidth = view.bounds.width - 20
        headerImageView.contentMode = UIViewContentMode.ScaleAspectFill
        headerImageView.clipsToBounds = true
        labelBtn.layer.borderWidth = 0.5
        labelBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .All
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.delegate = self
        webView.scrollView.contentInset = UIEdgeInsetsMake(267, 0, 0, 0)
        automaticallyAdjustsScrollViewInsets = false
        webView.delegate = self
    }
    
    private func setupAutoLayout() {
        
        let cons = headerView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, 267), offset: CGPointMake(0, 0))
        webView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - 47), offset: CGPointMake(0, 0))
        toolbarView.ff_AlignInner(ff_AlignType.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, 47), offset: CGPointMake(0, 0))
        headerImageView.ff_Fill(toolbarView)
        labelBtn.ff_AlignInner(ff_AlignType.TopRight, referView: headerView, size: CGSizeMake(32, 14), offset: CGPointMake(-17, 7 + 44))
        favNumLabel.ff_AlignInner(ff_AlignType.BottomLeft, referView: headerView, size: nil, offset: CGPointMake(10, -7))
        visitNumLabel.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: favNumLabel, size: nil, offset: CGPointMake(11, 0))
        titleLabel.ff_AlignVertical(ff_AlignType.TopLeft, referView: favNumLabel, size: nil, offset: CGPointMake(0, 1))
        commentLab.ff_AlignInner(ff_AlignType.CenterLeft, referView: toolbarView, size: nil, offset: CGPointMake(14, 0))
        commentBtn.ff_AlignInner(ff_AlignType.CenterRight, referView: toolbarView, size: CGSizeMake(28, 28), offset: CGPointMake(-10, 0))
        shareBtn.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: commentBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        collectBtn.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: shareBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        bottomLine.ff_AlignInner(ff_AlignType.TopCenter, referView: toolbarView, size: CGSizeMake(view.bounds.width, 0.5), offset: CGPointMake(0, 0))
        headerHeightConstraint = headerView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        //shareView.frame = CGRectMake(0, view.bounds.height, view.bounds.width, 197)
        let shareVCons = shareView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: view, size: CGSize(width: view.bounds.width, height: 197), offset: CGPoint(x: 0, y: 197))
        shareLabel.ff_AlignInner(ff_AlignType.TopCenter, referView: shareView, size: nil, offset: CGPointMake(0, 18))
        shareViewCY = shareView.ff_Constraint(shareVCons, attribute: NSLayoutAttribute.Top)
        let sbx: CGFloat = CGFloat((view.bounds.width - (50 * 5)) / 6)
        let size = CGSizeMake(50, 73)
        let s1 = shareBtn1.ff_AlignInner(ff_AlignType.CenterLeft, referView: shareView, size: size, offset: CGPoint(x: sbx, y: 150))
        let s2 = shareBtn2.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: shareBtn1, size: size, offset: CGPoint(x: sbx, y: 200))
        let s3 = shareBtn3.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: shareBtn2, size: size, offset: CGPoint(x: sbx, y: 250))
        let s4 = shareBtn4.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: shareBtn3, size: size, offset: CGPoint(x: sbx, y: 300))
        let s5 = shareBtn5.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: shareBtn4, size: size, offset: CGPoint(x: sbx, y: 350))
        shareCancle.ff_AlignInner(ff_AlignType.BottomCenter, referView: shareView, size: CGSizeMake(93, 34), offset: CGPointMake(0, -17))
        shareBtnY1 = shareBtn1.ff_Constraint(s1, attribute: NSLayoutAttribute.CenterY)
        shareBtnY2 = shareBtn2.ff_Constraint(s2, attribute: NSLayoutAttribute.CenterY)
        shareBtnY3 = shareBtn3.ff_Constraint(s3, attribute: NSLayoutAttribute.CenterY)
        shareBtnY4 = shareBtn4.ff_Constraint(s4, attribute: NSLayoutAttribute.CenterY)
        shareBtnY5 = shareBtn5.ff_Constraint(s5, attribute: NSLayoutAttribute.CenterY)
    }

    // MARK: UIWebView and UIScrollView Delegate 代理方法
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        let localizedErrorMessage = NSLocalizedString("An error occured:", comment: "")
        
        let errorHTML = "<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">\(localizedErrorMessage) \(error!.localizedDescription)</div></body></html>"
        
        webView.loadHTMLString(errorHTML, baseURL: nil)
    }
    
    func showTopicDetail1() {
        
        let html = NSMutableString()
        html.appendString("<html><head>")
        html.appendFormat("<link rel=\"stylesheet\" href=\"%@\">", NSBundle.mainBundle().URLForResource("TopicDetail.css", withExtension: nil)!)
        let body = setupBody()
        html.appendString("</head><body>\(body)</body></html>")
        print("======");print(html);print("======")
        webView.loadHTMLString(html as String, baseURL: nil)
        
    }
    
    func showTopicDetail() {
        let url =  AppIni.BaseUri + "/topic/detail?isapp=1&id=\(self.topicId)"
        if let requestURL = NSURL(string: url) {
            let request = NSURLRequest(URL: requestURL)
            webView.loadRequest(request)
        }
    }
    
    func setupBody() -> String {
        let onload = "img onload=\"this.onclick = function() {window.location.href = 'bn:src='};\" src=\"\(AppIni.BaseUri)"
        return content!.stringByReplacingOccurrencesOfString("img src=\"", withString: onload, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    //  TODO: 还需跳转打开单张图片
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let url = request.URL?.absoluteString
        let range = url?.rangeOfString("bn:src=")
        if range != nil {
            print("跳转页面")
            return false
        }
        return true
    }
    
    ///  改变背景及图片下拉变大
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //headerView高度动态变化
        let navigationBarHeight: CGFloat = 0
        var height = -(scrollView.contentOffset.y + navigationBarHeight)
        if height < 44 {
            height = 44
        }
        headerHeightConstraint?.constant = height
        
        //header文字渐变
        let threshold:CGFloat = 100
        headerAlpha = (height - 44) / threshold
        if headerAlpha > 1 {
            headerAlpha = 1
        } else if headerAlpha < 0.1 {
            headerAlpha = 0
        }
        refreshTitle()
    }
    
    // MARK: - 评论、分享、收藏
    func doFavorite(sender: UIButton) {
        print("收藏")
    }
    
    
    func doSharing(sender: UIButton) {
        print("分享")
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.shareViewCY?.constant = -197
            self.shareView.layoutIfNeeded()
            
            }) { (_) -> Void in
                
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    self.shareBtnY1?.constant = 0
                    self.shareBtnY2?.constant = 0
                    self.shareBtnY3?.constant = 0
                    self.shareBtnY4?.constant = 0
                    self.shareBtnY5?.constant = 0
                    self.shareBtn1.layoutSubviews()
                    self.shareBtn2.layoutSubviews()
                    self.shareBtn3.layoutSubviews()
                    self.shareBtn4.layoutSubviews()
                    self.shareBtn5.layoutSubviews()
                    
                    }, completion: nil)
        }
    }
    
    // MARK: - 分享 微信好友
    func shareClick(sender: UIButton) {
        
        switch sender.tag {
        case 1: shareFriendCircle(SSDKPlatformType.SubTypeWechatSession)
        case 2: shareFriendCircle(SSDKPlatformType.SubTypeWechatTimeline)
        case 3: shareFriendCircle(SSDKPlatformType.TypeSinaWeibo)
        case 4: shareFriendCircle(SSDKPlatformType.SubTypeQZone)
        case 5: shareFriendCircle(SSDKPlatformType.TypeCopy)
        default:
            break
        }
        
    }
    
    ///  朋友圈
    func shareFriendCircle(type: SSDKPlatformType) {
        
        ShareSDK.share(type, parameters: self.shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
            
            switch state{
            case SSDKResponseState.Success:
                print("分享成功")
                let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "取消")
                alert.show()
            case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  print("分享取消")
                
            default:
                break
            }
        }
    }
    
    // MARK: - 搜索(下一个控制器)
    var searchController: UISearchController!
    func searchButtonClicked(button: UIBarButtonItem) {
        // 获得父控制器
        let searchResultsController = SearchResultsViewController()
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        let imgView   = UIImageView(image: UIImage(named: "search-bg0")!)
        imgView.frame = searchController.view.bounds
        searchController.view.addSubview(imgView)
        searchController.view.sendSubviewToBack(imgView)
        searchController.searchBar.barStyle = UIBarStyle.Black
        searchController.searchBar.tintColor = UIColor.grayColor()
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.Default
        presentViewController(searchController, animated: true, completion: nil)
    }
    
    
    // MARK: - 评论
    func doComment(sender: UIButton) {
        
        let vc = commentVC

        // 1. 设置`转场 transitioning`代理
        //vc.transitioningDelegate = sendPopoverAnimator
        // 2. 设置视图的展现大小
        vc.view.clipsToBounds = true
        // 3. 设置专场的模式 - 自定义转场动画
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc, animated: true, completion: nil)
    }
    

    // MARK: - 遮罩方法
    func coverClick(serder: UIButton) {
        
        UIView.animateWithDuration(0.5, animations: { [unowned self] () -> Void in
            self.cover.alpha = 0.0
            self.commentVC.view.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 22, UIScreen.mainScreen().bounds.height - 34, 0, 0)
            }) { [unowned self]  (_) -> Void in
                
                self.cover.removeFromSuperview()
                self.commentVC.view.removeFromSuperview()
        }
    }
    
    func shareCancleClick(serder: UIButton) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.shareBtnY1?.constant = 150
            self.shareBtnY2?.constant = 200
            self.shareBtnY3?.constant = 250
            self.shareBtnY4?.constant = 300
            self.shareBtnY5?.constant = 350
            self.shareBtn1.layoutSubviews()
            self.shareBtn2.layoutSubviews()
            self.shareBtn3.layoutSubviews()
            self.shareBtn4.layoutSubviews()
            self.shareBtn5.layoutSubviews()
            }) { (_) -> Void in
                
                UIView.animateWithDuration(0.5) { [unowned self] () -> Void in
                    self.shareViewCY?.constant = self.view.bounds.height
                    self.shareView.layoutIfNeeded()
                }
        }
    }
}



