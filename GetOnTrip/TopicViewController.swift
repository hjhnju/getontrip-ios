//
//  TopicViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import WebKit

struct TopicViewContant {
    static let headerViewHeight:CGFloat = 267
    static let toolBarHeight:CGFloat    = 47
    static let commentViewHeight:CGFloat = UIScreen.mainScreen().bounds.height - UIScreen.mainScreen().bounds.height * 0.72 - 44
}

class TopicViewController: BaseViewController, UIScrollViewDelegate, WKNavigationDelegate {
    
    // MARK: 相关属性
    
    /// 自定义导航
    var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: SceneColor.frontBlack, titleSize: 14, hasStatusBar: false)
    
    /// 头部视图
    lazy var headerView       = UIView()
    
    /// 头部视图高度约束
    var headerHeightConstraint: NSLayoutConstraint?
    
    lazy var headerImageView  = UIImageView(image: PlaceholderImage.defaultLarge)
    
    /// 文章标题
    lazy var headerTitleLabel = UILabel(color: UIColor.whiteColor(), title: "", fontSize: 24, mutiLines: false)
    
    /// 标签 - 历史
    lazy var labelButton      = UIButton(title: "", fontSize: 9, radius: 3, titleColor: UIColor.whiteColor())
    
    /// 收藏数量标签
    lazy var favNumLabel      = UIButton(image: "icon_star_light", title: "", fontSize: 12, titleColor: SceneColor.white.colorWithAlphaComponent(0.7))

    /// 浏览标签
    lazy var visitNumLabel    = UIButton(image: "icon_visit_light", title: "", fontSize: 12, titleColor: SceneColor.white.colorWithAlphaComponent(0.7))
    
    //webView
    var webView               = WKWebView(color: UIColor.grayColor())
    
    //底部工具栏
    lazy var toolbarView      = UIView()
    
    /// 评论显示多少条
    lazy var commentNumLabel  = UILabel(color: UIColor(hex: 0x9C9C9C, alpha: 1.0), title: "", fontSize: 11, mutiLines: true)
    
    /// 底部评论按钮
    lazy var commentBotton: CommentButton = CommentButton(image: "topic_comment", title: "123", fontSize: 12, titleColor: SceneColor.lightYellow)

    /// 底部分享按钮
    lazy var shareBotton      = UIButton(image: "topic_share", title: "", fontSize: 0)
    
    /// 底部收藏按钮
    lazy var collectBotton    = UIButton(image: "topic_star", title: "", fontSize: 0, titleColor: SceneColor.lightYellow)
    
    /// 底部线
    lazy var bottomLineView   = UIView(color: SceneColor.lightGray)
    
    /// 遮罩按钮
    lazy var coverButton: UIButton = UIButton(color: UIColor.blackColor(), alphaF: 0.0)
  
    lazy var shareView: ShareView = ShareView()
    
    /// 网络请求加载数据(添加)
    var lastRequest: TopicRequest?
    
    //导航背景，用于完成渐变
    weak var navUnderlayView:UIView?
    
    //导航透明度
    var headerAlpha:CGFloat = 1.0
    
    //原导航底图
    var oldBgImage: UIImage?
    
    var oldNavTintColor: UIColor?
    
    /// 评论控制器
    lazy var commentVC: CommentViewController = CommentViewController()
    
    // MARK: DataSource of Controller

    var topicId: String? {
        return self.topicDataSource?.id ?? ""
    }
    
    var topicDataSource: Topic? {
        didSet {
            if let topic = topicDataSource {
                //初始处用placeholder，以免跳转前设置的图片被覆盖
                //print("[TopicView]headerimage=\(topic.image)")
                headerImageView.sd_setImageWithURL(NSURL(string: topic.image), placeholderImage:headerImageView.image)
                headerTitleLabel.text = topic.title
                
                navBar.setTitle(topic.sight)
                labelButton.setTitle("  " + topic.tagname + "  ", forState: .Normal)
                favNumLabel.setTitle(" " + topic.collect, forState: .Normal)
                visitNumLabel.setTitle(" " + topic.visit, forState: .Normal)
                commentBotton.setTitle(topic.commentNum, forState: .Normal)
                
                collectBotton.selected = topic.collected == "" ? false : true
                commentVC.topicId      = topic.id
                commentNumLabel.text   = topic.comment
                labelButton.hidden     = false
                favNumLabel.hidden     = false
                visitNumLabel.hidden   = false
                
                if !topic.isInSomeSight() {
                    navBar.rightButton.hidden = true
                }

                showTopicDetail()
            }
        }
    }
    
    // MARK: - 初始化方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initNavBar()
        initWebView()
        refreshHeader()
        loadSightData()
        setupAutoLayout()
    }
    
   
    func initView() {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
        
        view.addSubview(webView)
        view.addSubview(headerView)
        view.addSubview(toolbarView)
        view.backgroundColor = UIColor.whiteColor()
        headerView.addSubview(headerImageView)
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(labelButton)
        headerView.addSubview(favNumLabel)
        headerView.addSubview(visitNumLabel)
        toolbarView.addSubview(commentNumLabel)
        toolbarView.addSubview(commentBotton)
        toolbarView.addSubview(shareBotton)
        toolbarView.addSubview(collectBotton)
        toolbarView.addSubview(bottomLineView)
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        view.addSubview(coverButton)
        view.addSubview(commentVC.view)
        commentVC.view.hidden = true
        addChildViewController(commentVC)
        
        headerView.userInteractionEnabled = true
        headerImageView.userInteractionEnabled = true
        labelButton.hidden          = true
        favNumLabel.hidden          = true
        visitNumLabel.hidden        = true
        coverButton.backgroundColor = UIColor.blackColor()
        
        collectBotton.setImage(UIImage(named: "topic_star_select"), forState: .Selected)
        shareBotton  .addTarget(self, action: "doSharing:", forControlEvents: .TouchUpInside)
        collectBotton.addTarget(self, action: "doFavorite:", forControlEvents: .TouchUpInside)
        commentBotton.addTarget(self, action: "doComment:", forControlEvents: .TouchUpInside)
        coverButton  .addTarget(self, action: "coverClick:", forControlEvents: .TouchUpInside)
        
        headerTitleLabel.numberOfLines = 2
        headerTitleLabel.preferredMaxLayoutWidth = view.bounds.width - 20
        headerImageView.contentMode   = UIViewContentMode.ScaleAspectFill
        headerImageView.clipsToBounds = true
        labelButton.layer.borderWidth = 0.5
        labelButton.layer.borderColor = UIColor(hex: 0xFFFFFF, alpha: 0.8).CGColor
        labelButton.backgroundColor   = SceneColor.fontGray
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    private func initNavBar() {
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")
        navBar.setRightBarButton(UIImage(named: "bar_sight"), title: nil, target: self, action: "sightAction:")
        navBar.setButtonTintColor(SceneColor.frontBlack)
        navBar.setStatusBarHidden(true)
    }
    

    func initWebView() {
        automaticallyAdjustsScrollViewInsets = false
        webView.addSubview(loadingView)
        webView.scrollView.delegate = self
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator   = true
        webView.navigationDelegate  = self
        webView.backgroundColor = UIColor.whiteColor()
        webView.opaque = false
        webView.scrollView.contentInset = UIEdgeInsetsMake(TopicViewContant.headerViewHeight, 0, 0, 0)
    }
    
    func refreshHeader(){
        headerTitleLabel.alpha = headerAlpha
        favNumLabel.alpha   = headerAlpha
        visitNumLabel.alpha = headerAlpha
        labelButton.alpha   = headerAlpha
    }
    
    private func setupAutoLayout() {
        let th: CGFloat = TopicViewContant.headerViewHeight
        let tt: CGFloat = TopicViewContant.toolBarHeight
        let cons = headerView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, th), offset: CGPointMake(0, 0))
        webView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - tt), offset: CGPointMake(0, 0))
        toolbarView.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, tt), offset: CGPointMake(0, 0))
        
        //header views
        headerImageView.ff_Fill(headerView)
        labelButton   .contentEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        labelButton   .ff_AlignVertical(.TopLeft, referView: headerTitleLabel, size: nil, offset: CGPointMake(0, -5))
        favNumLabel   .ff_AlignInner(.BottomLeft, referView: headerView, size: nil, offset: CGPointMake(20, -7))
        visitNumLabel .ff_AlignHorizontal(.CenterRight, referView: favNumLabel, size: nil, offset: CGPointMake(11, 0))
        headerTitleLabel.ff_AlignVertical(.TopLeft, referView: favNumLabel, size: nil, offset: CGPointMake(0, 1))
        headerHeightConstraint = headerView.ff_Constraint(cons, attribute: .Height)
        
        //toolbar views
        commentNumLabel.ff_AlignInner(.CenterLeft, referView: toolbarView, size: nil, offset: CGPointMake(14, 0))
        commentBotton .ff_AlignInner(.CenterRight, referView: toolbarView, size: CGSizeMake(28, 28), offset: CGPointMake(-10, 0))
        shareBotton   .ff_AlignHorizontal(.CenterLeft, referView: commentBotton, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        collectBotton .ff_AlignHorizontal(.CenterLeft, referView: shareBotton, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        bottomLineView.ff_AlignInner(.TopCenter, referView: toolbarView, size: CGSizeMake(view.bounds.width, 0.5), offset: CGPointMake(0, 0))
        loadingView   .ff_AlignInner(.TopCenter, referView: webView, size: loadingView.getSize(), offset: CGPointMake(0, (view.bounds.height + th)/2 - 2*tt))
    }

    // MARK: - 系统方法
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.webView.scrollView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        //还原
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        super.viewDidDisappear(animated)
        //避免webkit iOS回退bug https://bugs.webkit.org/show_bug.cgi?id=139662
        self.webView.scrollView.delegate = nil
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: UIWebView
    
    var loadingView: LoadingView = LoadingView()
    
    /// 页面加载失败时调用
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print("[DetailWebViewController]webView error \(error.localizedDescription)")
        let errorHTML = "<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">网络内容加载失败</div></body></html>"
        webView.loadHTMLString(errorHTML, baseURL: nil)
    }
    
    /// 页面开始加载时调用
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingView.start()
    }
    
    /// 页面加载完成之后调用
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        loadingView.stop()
    }
    
    /// 显示详情
    private func showTopicDetail() {
        if let topic =  topicDataSource {
            print("[WebView]Loading: \(topic.contenturl)")
            if let requestURL = NSURL(string: topic.contenturl) {
                let request = NSURLRequest(URL: requestURL)
                webView.loadRequest(request)
            }
        }
    }
    
    // MARK: ScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        shareView.shareCancleAction()
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
        refreshHeader()
    }
    
    // MARK: - 自定义方法
    /// 加载景点数据
    private func loadSightData() {
        
        if lastRequest == nil {
            lastRequest = TopicRequest()
            lastRequest?.topicId = topicDataSource?.id ?? ""
            lastRequest?.sightId = topicDataSource?.sightid ?? ""
        }
        
        lastRequest?.fetchModels({[weak self] (result, status) -> Void in
            if status == RetCode.SUCCESS {
                if let topic = result {
                    self?.topicDataSource = topic
                }
            } else {
                ProgressHUD.showErrorHUD(self?.view, text: "网络无法连接")
            }
            })
        loadingView.start()
    }

    
    func doFavorite(sender: UIButton) {
        sender.selected = !sender.selected
        if let topic = topicDataSource {
            let type  = FavoriteContant.TypeTopic
            let objid = topic.id
            Favorite.doFavorite(type, objid: objid, isFavorite: sender.selected) {
                (result, status) -> Void in
                if status == RetCode.SUCCESS {
                    if result == nil {
                        sender.selected = !sender.selected
                    } else {
                        ProgressHUD.showSuccessHUD(self.view, text: sender.selected ? "已收藏" : "已取消")
                    }
                } else {
                    ProgressHUD.showErrorHUD(self.view, text: "操作未成功，请稍候再试!")
                    sender.selected = !sender.selected
                }
            }
        }
    }
    
    func doSharing(sender: UIButton) {
        if let topicDetail = topicDataSource {
            let url = topicDetail.shareurl
            shareView.showShareAction(view, url: url, images: headerImageView.image, title: topicDetail.title, subtitle: topicDetail.subtitle)
        }
    }
    
    /// 评论
    func doComment(sender: UIButton) {
        let w = view.bounds.width
        let h = view.bounds.height
        commentVC.view.hidden = false
        commentVC.topicId = topicDataSource?.id ?? ""
        commentVC.view.frame = CGRectMake(w - 28, h - 44, 0, 0)
        coverButton.frame = UIScreen.mainScreen().bounds
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.commentVC.view.frame = CGRectMake(0, TopicViewContant.commentViewHeight, w, UIScreen.mainScreen().bounds.height * 0.72)
            self.coverButton.alpha = 0.7
            }) { (_) -> Void in
        }
    }
    

    /// 评论时遮罩层的点击方法
    func coverClick(serder: UIButton) {
        self.commentVC.issueTextfield.resignFirstResponder()
        UIView.animateWithDuration(0.3, animations: { [weak self] () -> Void in
            self?.coverButton.alpha = 0.0
            self?.commentVC.view.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 22, UIScreen.mainScreen().bounds.height - 34, 0, 0)
            }) { [weak self]  (_) -> Void in
                self?.commentVC.issueTextfield.placeholder = ""
                self?.commentVC.toUser = ""
                self?.commentVC.upId   = ""
                self?.commentVC.view.hidden = true
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
        let transFromValue = keyBoardY! - view.bounds.height

        let bound = UIScreen.mainScreen().bounds
        if transFromValue == 0{
            self.commentVC.view.frame = CGRectMake(0, bound.height - (bound.height * 0.72) - 44, view.bounds.width, bound.height * 0.72)
            self.commentVC.tableViewConH?.constant = bound.height * 0.72 - 88
            self.commentVC.tableView.layoutIfNeeded()
        } else {
            self.commentVC.view.frame = CGRectMake(0, 44, view.bounds.width, bound.height - keyBoardFrame!.height - 44)
            self.commentVC.tableViewConH?.constant = bound.height - keyBoardFrame!.height - 44 - 88
            if self.commentVC.reloadIndexPath.row != 0 {
                self.commentVC.tableView.scrollToRowAtIndexPath(self.commentVC.reloadIndexPath, atScrollPosition: .Middle, animated: true)
            }
            self.commentVC.tableView.layoutIfNeeded()
        }
        
    }
    
    /// 跳至景点页
    func sightAction(sender: UIButton) {
        
        let sendPopoverAnimator = SendPopoverAnimator()
        let vc = TopicEnterSightController()
        vc.nav = navigationController
        vc.dataSource = topicDataSource?.arrsight
        // 1. 设置`转场 transitioning`代理
        vc.transitioningDelegate = sendPopoverAnimator
        // 2. 设置视图的展现大小
        let screen = UIScreen.mainScreen().bounds
        let h: CGFloat = screen.height * 0.46 + 74
        let w: CGFloat = screen.width * 0.63
        let x: CGFloat = (screen.width - w) * 0.5
        let y: CGFloat = screen.height * 0.27
        sendPopoverAnimator.presentFrame = CGRectMake(x, y, w, h)
        vc.view.clipsToBounds = true
        // 3. 设置专场的模式 - 自定义转场动画
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc, animated: true, completion: nil)
        
    }
}
