
//
//  TopicViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

struct TopicViewContant {
    static let headerViewHeight:CGFloat = 267
    static let toolBarHeight:CGFloat    = 47
    static let commentViewHeight:CGFloat = 248
}

class TopicViewController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {
    
    // MARK: 相关属性
    
    //导航景点名
    lazy var navTitleLabel: UILabel = UILabel(color: SceneColor.frontBlack, title: "", fontSize: 14, mutiLines: false)
    
    //头部视图
    lazy var headerView: UIView = UIView()
    
    //头部视图高度约束
    var headerHeightConstraint: NSLayoutConstraint?
    
    /// 头部图片url
    var headerImageUrl:String = "" {
        didSet {
            //初始处用placeholder，以免跳转前设置的图片被覆盖
            self.headerImageView.sd_setImageWithURL(NSURL(string: headerImageUrl))
        }
    }
    
    lazy var headerImageView: UIImageView = UIImageView(image: PlaceholderImage.defaultLarge)
    
    /// 文章标题
    lazy var titleLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "", fontSize: 24, mutiLines: false)
    
    /// 标签 - 历史
    lazy var labelBtn: UIButton = UIButton(title: "", fontSize: 9, radius: 3, titleColor: UIColor.whiteColor())
    
    lazy var favNumLabel: UIButton = UIButton(image: "icon_star_light", title: "", fontSize: 12, titleColor: SceneColor.white.colorWithAlphaComponent(0.7))

    lazy var visitNumLabel: UIButton = UIButton(image: "icon_visit_light", title: "", fontSize: 12, titleColor: SceneColor.white.colorWithAlphaComponent(0.7))
    
    //webView
    lazy var webView: UIWebView = UIWebView()
    
    //底部工具栏
    lazy var toolbarView: UIView = UIView()
    
    lazy var commentLab: UILabel = UILabel(color: UIColor(hex: 0x9C9C9C, alpha: 1.0), title: "", fontSize: 11, mutiLines: true)
    
    lazy var commentBtn: UIButton = UIButton(image: "topic_comment", title: "", fontSize: 0)

    lazy var shareBtn: UIButton = UIButton(image: "topic_share", title: "", fontSize: 0)
    
    lazy var collectBtn: UIButton = UIButton(image: "topic_star", title: "", fontSize: 0)
    
    var content: String?
    
    lazy var bottomLine: UIView = UIView(color: SceneColor.lightGray)
    
    lazy var cover: UIButton = UIButton(color: UIColor.blackColor(), alphaF: 0.0)
  
    lazy var shareView: ShareView = ShareView()
    
    lazy var commentVC: CommentTopicController = {
        return CommentTopicController()
    }()
    
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
                collectBtn.selected = topicDetail?.collected == "" ? false : true
                commentVC.topicId  = topic.id
                commentLab.text    = topic.comment
                
                labelBtn.setTitle(topic.label, forState: UIControlState.Normal)
                favNumLabel.setTitle(" " + topic.collect, forState: UIControlState.Normal)
                visitNumLabel.setTitle(" " + topic.visit, forState: UIControlState.Normal)
                labelBtn.hidden      = false
                favNumLabel.hidden   = false
                visitNumLabel.hidden = false
                headerImageUrl = topic.image

                showTopicDetail()
            }
        }
    }
    
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: TopicRequest?
    
    
    //导航背景，用于完成渐变
    weak var navUnderlayView:UIView?
    
    //导航透明度
    var headerAlpha:CGFloat = 1.0
    
    //原导航底图
    var oldBgImage: UIImage?
    
    var oldNavTintColor: UIColor?
    
    // MARK: - 初始化方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        webView.backgroundColor = UIColor.whiteColor()
        collectBtn.setImage(UIImage(named: "topic_star_select"), forState: UIControlState.Selected)
        
        //原则：如果和默认设置不同，controller自己定义新值，退出时自己还原
        oldBgImage = navigationController?.navigationBar.backgroundImageForBarMetrics(UIBarMetrics.Default)
        oldNavTintColor = navigationController?.navigationBar.tintColor
        
        //nav bar
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
        navigationItem.titleView = navTitleLabel
        
        refreshTitle()
        
        navTitleLabel.frame = CGRectMake(0, 0, 100, 21)
        navTitleLabel.textAlignment = NSTextAlignment.Center
        navTitleLabel.hidden = false
        navTitleLabel.alpha  = 1.0
        
        loadSightData()
        setupAddProperty()
        setupDefaultProperty()
        setupAutoLayout()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //在viewDidDisappear中无法生效
        navigationController?.navigationBar.setBackgroundImage(oldBgImage, forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.tintColor = oldNavTintColor
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        //还原
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        super.viewDidDisappear(animated)
    }
    
    func refreshBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.navigationBar.tintColor = SceneColor.frontBlack
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
            lastSuccessAddRequest = TopicRequest()
            lastSuccessAddRequest?.topicId = topicId
        }
        
        lastSuccessAddRequest?.fetchTopicDetailModels {[weak self] (handler: TopicDetail) -> Void in
            self?.topicDetail = handler
        }
    }
    
    private func setupAddProperty() {
        view.addSubview(webView)
        view.addSubview(headerView)
        view.addSubview(toolbarView)
//        view.addSubview(shareView)
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
        
        headerView.userInteractionEnabled = true
        headerImageView.userInteractionEnabled = true
        labelBtn.hidden      = true
        favNumLabel.hidden   = true
        visitNumLabel.hidden = true
        
//        view.addSubview(cover)
        cover.backgroundColor = UIColor.blackColor()
        
        //share view
    }
    
    private func setupDefaultProperty() {
        shareBtn.addTarget(self, action: "doSharing:", forControlEvents: UIControlEvents.TouchUpInside)
        collectBtn.addTarget(self, action: "doFavorite:", forControlEvents: UIControlEvents.TouchUpInside)
        commentBtn.addTarget(self, action: "doComment:", forControlEvents: UIControlEvents.TouchUpInside)
        cover.addTarget(self, action: "coverClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
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
        webView.scrollView.contentInset = UIEdgeInsetsMake(TopicViewContant.headerViewHeight, 0, 0, 0)
        automaticallyAdjustsScrollViewInsets = false
        webView.delegate = self
    }
    
    private func setupAutoLayout() {
        
        let cons = headerView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, TopicViewContant.headerViewHeight), offset: CGPointMake(0, 0))
        webView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - TopicViewContant.toolBarHeight), offset: CGPointMake(0, 0))
        toolbarView.ff_AlignInner(ff_AlignType.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, TopicViewContant.toolBarHeight), offset: CGPointMake(0, 0))
        
        //header views
        headerImageView.ff_Fill(headerView)
        labelBtn.ff_AlignInner(ff_AlignType.BottomRight, referView: headerView, size: CGSizeMake(32, 14), offset: CGPointMake(-17, -CityConstant.headerViewHeight))
        favNumLabel.ff_AlignInner(ff_AlignType.BottomLeft, referView: headerView, size: nil, offset: CGPointMake(8, -7))
        visitNumLabel.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: favNumLabel, size: nil, offset: CGPointMake(11, 0))
        titleLabel.ff_AlignVertical(ff_AlignType.TopLeft, referView: favNumLabel, size: nil, offset: CGPointMake(-2, 1))
        headerHeightConstraint = headerView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
        //toolbar views
        commentLab.ff_AlignInner(ff_AlignType.CenterLeft, referView: toolbarView, size: nil, offset: CGPointMake(14, 0))
        commentBtn.ff_AlignInner(ff_AlignType.CenterRight, referView: toolbarView, size: CGSizeMake(28, 28), offset: CGPointMake(-10, 0))
        shareBtn.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: commentBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        collectBtn.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: shareBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        bottomLine.ff_AlignInner(ff_AlignType.TopCenter, referView: toolbarView, size: CGSizeMake(view.bounds.width, 0.5), offset: CGPointMake(0, 0))
        
//        cover.ff_Fill(view)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().removeObserver(self)

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
        print("[WebView]Loading: \(url)")
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
            return false
        }
        return true
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        shareView.shareCancleClick()
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
        
        if sharedUserAccount == nil {
            LoginView.sharedLoginView.addLoginFloating({ (result, error) -> () in
                let resultB = result as! Bool
                if resultB == true {
                    CollectAddAndCancel.sharedCollectAddCancel.fetchCollectionModels(4, objid: self.topicId, isAdd: !sender.selected, handler: { (result, status) -> Void in
                        if status == RetCode.SUCCESS {
                            if result == "1" {
                                sender.selected = !sender.selected
                                SVProgressHUD.showInfoWithStatus(sender.selected ? "已收藏" : "已取消")
                            } else {
                                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                            }
                        }
                    })                }
            })
        } else {
            
            CollectAddAndCancel.sharedCollectAddCancel.fetchCollectionModels(4, objid: topicId, isAdd: !sender.selected, handler: { (result, status) -> Void in
                if status == RetCode.SUCCESS {
                    if result == "1" {
                        sender.selected = !sender.selected
                        SVProgressHUD.showInfoWithStatus(sender.selected ? "已收藏" : "已取消")
                    } else {
                        SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                    }
                }
            })
        }
    }
    
    
    func doSharing(sender: UIButton) {
        print("分享")
        shareView.getShowShareAction(view, topic: topicDetail!, images: headerImageView.image!, isTopicBook: true)
    }
    

    
    // MARK: - 搜索(下一个控制器)
    func searchButtonClicked(button: UIBarButtonItem) {
        // 获得父控制器
       
        presentViewController(SearchViewController(), animated: true, completion: nil)
    }
    
    
    // MARK: - 评论
    func doComment(sender: UIButton) {
        let w = view.bounds.width
        let h = view.bounds.height
        
//        view.addSubview(commentVC.view)
        UIApplication.sharedApplication().keyWindow?.addSubview(cover)
        UIApplication.sharedApplication().keyWindow?.addSubview(commentVC.view)
        commentVC.topicId = topicId
        commentVC.view.clipsToBounds = true
        commentVC.view.frame = CGRectMake(w - 28, h - 44, 0, 0)
        cover.frame = UIScreen.mainScreen().bounds
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.commentVC.view.frame = CGRectMake(0, TopicViewContant.commentViewHeight, w, h - TopicViewContant.commentViewHeight - 44)
            self.cover.alpha = 0.7
            }) { (_) -> Void in
                self.commentVC.view.clipsToBounds = false
        }
    }
    

    /// 评论时遮罩层的点击方法
    func coverClick(serder: UIButton) {
        self.commentVC.view.clipsToBounds = true
        self.commentVC.issueTextfield.resignFirstResponder()
        UIView.animateWithDuration(0.3, animations: { [weak self] () -> Void in
            self?.cover.alpha = 0.0
            self?.commentVC.view.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 22, UIScreen.mainScreen().bounds.height - 34, 0, 0)
            }) { [weak self]  (_) -> Void in
                self?.commentVC.view.removeFromSuperview()
                self?.cover.removeFromSuperview()
        }
    }
    
    ///  搜索跳入之后消失控制器
    func dismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /// 当键盘弹出的时候，执行相关操作
    func keyboardChanged(not: NSNotification) {

        let keyBoardFrame = not.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        let keyBoardY = keyBoardFrame?.origin.y
        var transFromValue = keyBoardY! - view.bounds.height
        
        if transFromValue == 0{
            transFromValue = 0
        } else {
            transFromValue = transFromValue + 44
        }
        
//        NSIndexPath *idxPat = [NSIndexPath indexPathForRow:self.messagesFrame.count - 1 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:idxPat atScrollPosition:UITableViewScrollPositionTop animated:YES];
        self.commentVC.view.transform = CGAffineTransformMakeTranslation(0, transFromValue)
    }


}