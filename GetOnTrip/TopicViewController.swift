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
    var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: SceneColor.frontBlack, titleSize: 17, hasStatusBar: false)
    
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
    lazy var favNumButton      = UIButton(image: "icon_star_light", title: "", fontSize: 12, titleColor: SceneColor.white.colorWithAlphaComponent(0.7))

    /// 浏览标签
    lazy var visitNumButton    = UIButton(image: "icon_visit_light", title: "", fontSize: 12, titleColor: SceneColor.white.colorWithAlphaComponent(0.7))
    
    //webView
    var webView               = WKWebView(color: UIColor.grayColor())
    
    //底部工具栏
    lazy var toolbarView      = UIView()
    
    /// 点赞按钮
    lazy var praisedButton    = UIButton(image: "dotLike_no", title: "", fontSize: 18, titleColor: UIColor(hex: 0x5C5C5C, alpha: 0.4))
    
    /// 底部评论按钮
    lazy var commentButton: CommentButton = CommentButton(image: "topic_comment", title: "123", fontSize: 12, titleColor: UIColor.whiteColor())

    /// 底部分享按钮
    lazy var shareButton      = UIButton(image: "topic_share", title: "", fontSize: 0)
    
    /// 底部收藏按钮
    lazy var collectButton    = UIButton(image: "topic_star", title: "", fontSize: 0, titleColor: SceneColor.lightYellow)
    
    /// 底部线
    lazy var bottomLineView   = UIView(color: SceneColor.lightGray)
    
    /// 遮罩按钮
    lazy var coverButton: UIButton = UIButton(color: UIColor.blackColor(), alphaF: 0.0)
      
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
    
    /// 记录点赞数量
    var praiseNum: String = ""
    
    /// 跳至景点页动画
    let sendPopoverAnimator = SendPopoverAnimator()
    
    // MARK: DataSource of Controller

    var topicId: String? {
        return self.topicDataSource?.id ?? ""
    }
    
    /// 遮罩
    lazy var coverView: UIView = UIView(color: UIColor(hex: 0x686868, alpha: 0.3), alphaF: 0.6)
        
    /// 进入的样式
    var isEntranceSight: Bool = false
    
    var topicDataSource: Topic? {
        didSet {
            if let topic = topicDataSource {
                //初始处用placeholder，以免跳转前设置的图片被覆盖
                //print("[TopicView]headerimage=\(topic.image)")
                headerImageView.sd_setImageWithURL(NSURL(string: topic.image), placeholderImage:headerImageView.image)
                
                let attr = NSMutableAttributedString(string: topic.title)
                let style = NSMutableParagraphStyle()
            
                let titleH = topic.title.sizeofStringWithFount(UIFont.systemFontOfSize(24), maxSize: CGSizeMake(UIScreen.mainScreen().bounds.width - 24, CGFloat.max), lineSpacing: 4).height
                if titleH < 35 {
                    style.maximumLineHeight = 32
                } else {
                    style.lineSpacing = 4
                }
                attr.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, attr.length))
                headerTitleLabel.attributedText = attr
                
                
                navBar.setTitle(topic.sight)
                labelButton.setTitle("  " + topic.tagname + "  ", forState: .Normal)
                favNumButton.setTitle(" " + topic.collect, forState: .Normal)
                visitNumButton.setTitle(" " + topic.visit, forState: .Normal)
                if topic.commentNum != "0" {
                    commentButton.setTitle(topic.commentNum, forState: .Normal)
                }
                praisedButton.setTitle(" " + topic.praiseNum, forState: .Normal)
                
                collectButton.selected = topic.collected == "" ? false : true
                praisedButton.selected = topic.praised == "" ? false : true
                commentVC.topicId      = topic.id
                labelButton.hidden     = false
                favNumButton.hidden     = false
                visitNumButton.hidden   = false
                
                if topicDataSource?.arrsight.count == 0 {
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
        headerView.addSubview(coverView)
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(labelButton)
        headerView.addSubview(favNumButton)
        headerView.addSubview(visitNumButton)
        toolbarView.addSubview(praisedButton)
        toolbarView.addSubview(commentButton)
        toolbarView.addSubview(shareButton)
        toolbarView.addSubview(collectButton)
        toolbarView.addSubview(bottomLineView)
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        view.addSubview(coverButton)
        view.addSubview(commentVC.view)
        commentVC.view.hidden = true
        addChildViewController(commentVC)
        praisedButton.setImage(UIImage(named: "dotLike_no"), forState: .Normal)
        praisedButton.setImage(UIImage(named: "dotLike_yes"), forState: .Selected)
        
        labelButton.alpha = 0.8
        visitNumButton.alpha = 0.8
        favNumButton.alpha = 0.8
        
        headerView.userInteractionEnabled = true
        headerImageView.userInteractionEnabled = true
        labelButton.hidden          = true
        favNumButton.hidden          = true
        visitNumButton.hidden        = true
        coverButton.backgroundColor = UIColor.blackColor()
        
        collectButton.setImage(UIImage(named: "topic_star_select"), forState: .Selected)
        shareButton  .addTarget(self, action: "doSharing:", forControlEvents: .TouchUpInside)
        collectButton.addTarget(self, action: "doFavorite:", forControlEvents: .TouchUpInside)
        commentButton.addTarget(self, action: "doComment:", forControlEvents: .TouchUpInside)
        coverButton  .addTarget(self, action: "coverClick:", forControlEvents: .TouchUpInside)
        praisedButton.addTarget(self, action: "praisedAction:", forControlEvents: .TouchUpInside)
        
        headerTitleLabel.numberOfLines = 2
        headerTitleLabel.preferredMaxLayoutWidth = view.bounds.width - 20
        headerImageView.contentMode   = UIViewContentMode.ScaleAspectFill
        headerImageView.clipsToBounds = true
        labelButton.layer.borderWidth = 0.5
        labelButton.layer.borderColor = UIColor(hex: 0xFFFFFF, alpha: 0.8).CGColor
        labelButton.backgroundColor   = UIColor(hex: 0x696969, alpha: 0.65)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    private func initNavBar() {
        if #available(iOS 9.0, *) {
            navBar.titleLabel.font = UIFont(name: Font.defaultFont, size: 17)
        } else {
            navBar.titleLabel.font = UIFont.systemFontOfSize(17)
        }
        navBar.titleLabel.textColor = UIColor(hex: 0x424242, alpha: 1.0)
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")
        navBar.setRightBarButton(UIImage(named: "bar_sight"), title: nil, target: self, action: "sightAction:")
        navBar.setButtonTintColor(SceneColor.frontBlack)
        navBar.setStatusBarHidden(true)
        navBar.rightButton.alpha = 0.75
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
        favNumButton.alpha   = headerAlpha
        visitNumButton.alpha = headerAlpha
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
        coverView.ff_Fill(headerView)
        labelButton   .contentEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        favNumButton   .ff_AlignInner(.BottomLeft, referView: headerView, size: nil, offset: CGPointMake(15, -10))
        visitNumButton .ff_AlignHorizontal(.CenterRight, referView: favNumButton, size: nil, offset: CGPointMake(10, 0))
        headerTitleLabel.ff_AlignVertical(.TopLeft, referView: favNumButton, size: nil, offset: CGPointMake(-2, -6))
        headerHeightConstraint = headerView.ff_Constraint(cons, attribute: .Height)
        labelButton   .ff_AlignVertical(.TopLeft, referView: headerTitleLabel, size: nil, offset: CGPointMake(0, -8))
        
        //toolbar views
        praisedButton.ff_AlignInner(.CenterLeft, referView: toolbarView, size: nil, offset: CGPointMake(14, 0))
        commentButton .ff_AlignInner(.CenterRight, referView: toolbarView, size: CGSizeMake(28, 28), offset: CGPointMake(-10, 0))
        shareButton   .ff_AlignHorizontal(.CenterLeft, referView: commentButton, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        collectButton .ff_AlignHorizontal(.CenterLeft, referView: shareButton, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
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
    
    // MARK: - 加载网络数据方法
    func loadSightData() {
        
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
}
