//
//  BookViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/14.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import WebKit

struct BookViewContant {
    static let headerViewHeight:CGFloat      = 267 + 82
    static let headerImageViewHeight:CGFloat = 267
    static let bookViewHeight:CGFloat   = 181
    static let toolBarHeight:CGFloat    = 47
}

class BookViewController: BaseViewController, UIScrollViewDelegate, WKNavigationDelegate, WKScriptMessageHandler  {

    // MARK: - 属性
    
    /// 自定义导航
    var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: UIColor.whiteColor(), titleSize: 14)
    
    /// 网络请求加载数据(添加)
    var lastRequest: BookRequest?

    var bookId: String {
        return bookDataSource?.id ?? ""
    }
    
    /// headerView的顶部约束
    var headerViewTopConstraint: NSLayoutConstraint?
    
    /// headerView图片高度约束
    var headerViewHeightConstraint: NSLayoutConstraint?
    
    /// 顶部视图
    //var headerView: UIView = UIView(color: UIColor.brownColor())
    
    /// 顶部底图
    lazy var headerImageView: UIImageView = UIImageView(image: PlaceholderImage.defaultSmall)
    
    /// 书籍图片
    lazy var bookImageView: UIImageView = UIImageView(image: PlaceholderImage.defaultSmall)
    
    /// 图片模糊
    lazy var blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
    
    /// 书籍标题 - "解读颐和园"
    lazy var titleLabel: UILabel = UILabel(color: UIColor.blackColor(), title: "", fontSize: 24, mutiLines: true)
    
    /// "张加冕/黄山书社出版社/2015-5/ISBN:345566743566"
    lazy var authorLabel: UILabel = UILabel(color: SceneColor.frontBlack, title: "", fontSize: 12, mutiLines: true)
    
    /// 分割线
    lazy var headerLineView: UIView = UIView(color: SceneColor.shallowGrey.colorWithAlphaComponent(0.3))
    
    /// 工具栏
    lazy var toolbarView: UIView = UIView()
    
    lazy var collectBtn: UIButton = UIButton(image: "topic_star", title: "", fontSize: 0)
    
    lazy var shareBtn: UIButton = UIButton(image: "topic_share", title: "", fontSize: 0)
    
    lazy var toolLineView: UIView = UIView(color: SceneColor.lightGray)
    
    //webView初始时的yInset
    var yInset:CGFloat = 0.0
    
    /// 点赞按钮
    lazy var praisedBUtton   = UIButton(image: "dotLike_no", title: "", fontSize: 18, titleColor: UIColor(hex: 0x9C9C9C, alpha: 0.9))
    
    /// 书籍内容
    var webView: WKWebView = WKWebView()
    
    var bookDataSource: Book? {
        didSet {
            if let data = bookDataSource {
                praisedBUtton.setTitle(" " + data.praiseNum, forState: .Normal)
                praisedBUtton.selected = data.praised == "" ? false : true

                collectBtn.selected = data.collected == "" ? false : true
                //不用placeimage以免覆盖传入的小图
                headerImageView.sd_setImageWithURL(NSURL(string: data.image))
                bookImageView.sd_setImageWithURL(NSURL(string: data.image))
                titleLabel.text = data.title
                authorLabel.text = data.info
                
                showBookDetail(data.content_desc)
            }
        }
    }
    
    //  MARK: - 初始化方法
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        setupAutoLayout()
        loadData()
        webView.scrollView.delegate = self
        
    }
    
    ///  添加相关属性
    private func initView() {
        view.backgroundColor = .whiteColor()
        
        initWebView()
        view.addSubview(webView)
        view.addSubview(toolbarView)
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: "", target: self, action: "popViewAction:")
        navBar.setRightBarButton(UIImage(named: "search"), title: nil, target: self, action: "searchAction:")
        navBar.setButtonTintColor(UIColor.yellowColor())
        navBar.setBlurViewEffect(false)
        navBar.backgroundColor = SceneColor.frontBlack
        
        webView.addSubview(headerImageView)
        webView.addSubview(bookImageView)
        webView.addSubview(titleLabel)
        webView.addSubview(authorLabel)
        webView.addSubview(headerLineView)
        
        headerImageView.addSubview(blurView)
        headerImageView.clipsToBounds = true
        headerImageView.userInteractionEnabled = true
        headerImageView.contentMode = UIViewContentMode.ScaleAspectFill
        bookImageView.userInteractionEnabled = true
        bookImageView.contentMode = UIViewContentMode.ScaleAspectFill
        bookImageView.clipsToBounds = true
        blurView.alpha = 1
        
        toolbarView.addSubview(collectBtn)
        toolbarView.addSubview(shareBtn)
        toolbarView.addSubview(toolLineView)
        toolbarView.addSubview(praisedBUtton)
        
        praisedBUtton.setImage(UIImage(named: "dotLike_no"), forState: .Normal)
        praisedBUtton.setImage(UIImage(named: "dotLike_yes"), forState: .Selected)
        collectBtn.setImage(UIImage(named: "topic_star_select"), forState: .Selected)
        collectBtn.addTarget(self, action: "favoriteAction:", forControlEvents: .TouchUpInside)
        shareBtn.addTarget(self, action: "clickShareButton:", forControlEvents: .TouchUpInside)
        praisedBUtton.addTarget(self, action: "praisedAction:", forControlEvents: .TouchUpInside)
        
        let w = view.bounds.width - 18
        titleLabel.preferredMaxLayoutWidth = w
        authorLabel.preferredMaxLayoutWidth = w
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webView.scrollView.delegate = self
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if CGRectGetMaxY(headerLineView.frame) > yInset {
            yInset = CGRectGetMaxY(headerLineView.frame)
            webView.scrollView.contentInset = UIEdgeInsetsMake(yInset, 0, 0, 0)
//            webView.scrollView.contentSize = CGSizeMake(1000, 500)
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //避免webkit iOS回退bug https://bugs.webkit.org/show_bug.cgi?id=139662
        self.webView.scrollView.delegate = nil        
    }
    
    
    
    func initWebView(){
        /*
        //Javascript string
        let source = "window.webkit.messageHandlers.sizeNotification.postMessage({width: document.width, height: document.height});"
        //UserScript object
        let script:WKUserScript = WKUserScript(source: source, injectionTime: WKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: true)
        //Content Controller object
        let controller:WKUserContentController = WKUserContentController()
        //Add script to controller
        controller.addUserScript(script)
        //Add message handler reference
        controller.addScriptMessageHandler(self, name: "sizeNotification")
        
        let config = WKWebViewConfiguration()
        //Add controller to configuration
        config.userContentController = controller;
        
        webView.configuration.userContentController = controller
        */
        
        webView.addSubview(loadingView)
        webView.scrollView.tag = 1
        //automaticallyAdjustsScrollViewInsets = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator   = true
        webView.navigationDelegate  = self
        webView.scrollView.scrollEnabled = true
        // webView.backgroundColor = UIColor.randomColor()
        webView.opaque = false
        webView.sizeToFit()
        
        //允许手势，后退前进等操作
        //webView.allowsBackForwardNavigationGestures = true
    }
    
    ///  添加布局
    private func setupAutoLayout() {
        let w = view.bounds.width
        
        //webview
        webView.ff_AlignInner(.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - BookViewContant.toolBarHeight), offset: CGPointMake(0, 0))
        
        let headerImageViewCons = headerImageView.ff_AlignInner(.TopLeft, referView: webView, size: CGSizeMake(view.bounds.width, BookViewContant.headerImageViewHeight))
        blurView.ff_Fill(headerImageView)
        bookImageView.ff_AlignInner(.CenterCenter, referView: headerImageView, size: CGSizeMake(142, 181), offset: CGPointMake(0, (BookViewContant.headerImageViewHeight-BookViewContant.bookViewHeight)/2 - 11))
        titleLabel.ff_AlignVertical(.BottomLeft, referView: headerImageView, size: nil, offset: CGPointMake(10, 17))
        authorLabel.ff_AlignVertical(.BottomLeft, referView: titleLabel, size: nil, offset: CGPointMake(0, 6))
        headerLineView.ff_AlignVertical(.BottomLeft, referView: authorLabel, size: CGSizeMake(w - 18, 0.5), offset: CGPointMake(0, 17))
        
        toolbarView.ff_AlignInner(.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, BookViewContant.toolBarHeight), offset: CGPointMake(0, 0))
        
        shareBtn.ff_AlignInner(.CenterRight, referView: toolbarView, size: CGSizeMake(28, 28), offset: CGPointMake(-10, 0))
        collectBtn.ff_AlignHorizontal(.CenterLeft, referView: shareBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        toolLineView.ff_AlignInner(.TopLeft, referView: toolbarView, size: CGSizeMake(w, 0.5), offset: CGPointMake(0, 0))
        praisedBUtton.ff_AlignInner(.CenterLeft, referView: toolbarView, size: nil, offset: CGPointMake(14, 0))

        /// headerView的顶部约束
        headerViewHeightConstraint = headerImageView.ff_Constraint(headerImageViewCons, attribute: .Height)
        headerViewTopConstraint = headerImageView.ff_Constraint(headerImageViewCons, attribute: .Top)
        
        
        loadingView.ff_AlignInner(.TopCenter, referView: webView, size: loadingView.getSize(), offset: CGPointMake(0, (view.bounds.height + BookViewContant.headerViewHeight)/2 - 2*TopicViewContant.toolBarHeight))
    }
    
    // MARK: UIScrollView Delegate 代理方法
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let gap     = yInset + offsetY

        let initTop: CGFloat = 0.0
        headerViewTopConstraint?.constant    = min(-gap, initTop)
        headerViewHeightConstraint?.constant = max(BookViewContant.headerImageViewHeight + -gap, BookViewContant.headerImageViewHeight)
    }
    
    // MARK: WKNavigationDelegate
    
    var loadingView: LoadingView = LoadingView()
    
    // 页面开始加载时调用
//    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        print("didStartProvisionalNavigation")
//    }
    // 当内容开始返回时调用
//    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
//        print("didCommitNavigation")
//    }
    // 页面加载完成之后调用
//    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
//        print("didFinishNavigation")
//    }
    
    // 页面加载失败时调用
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        //一个页面没有被完全加载之前收到下一个请求，此时迅速会出现此error,error=-999
        //此时可能已经加载完成，则忽略此error，继续进行加载。
        if error.code == NSURLErrorCancelled {
            return
        }
        print("[BookViewController]webView error \(error.localizedDescription)")
        let errorHTML = "<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">书籍内容加载失败</div></body></html>"
        webView.loadHTMLString(errorHTML, baseURL: nil)
    }
    
    // 页面开始加载时调用
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingView.start()
    }
    
    // 页面加载完成之后调用
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        loadingView.stop()
        
        
        
//        for it in webView.scrollView.subviews {
//            if it.isKindOfClass(NSClassFromString("WKContentView")!) {
//                print(webView.scrollView.contentSize.height - it.frame.height)
//                webView.scrollView.contentInset.bottom = webView.scrollView.contentSize.height - it.frame.height
//            }
//        }
//        print(webView.scrollView.subviews)
    }
    
    // 接收到服务器跳转请求之后调用
//    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//        print("didReceiveServerRedirectForProvisionalNavigation")
//    }
    // 在收到响应后，决定是否跳转
//    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
//        print("decidePolicyForNavigationResponse")
//    }
    // 在发送请求之前，决定是否跳转
//    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
//        print("decidePolicyForNavigationAction")
//    }
    
    // MARK:  WKScriptMessageHandler 协议
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {

        if let webView = message.webView {
            var frame:CGRect = webView.frame
            if let height = message.body.valueForKey("height")?.floatValue {
                frame.size.height = CGFloat(height)
                message.webView?.frame = frame
            }
        }
    }
    
    // MARK: 自定义方法
    
    /// 展示内容书籍
    func showBookDetail(body: String) {
        if let book =  bookDataSource {
            print("[BookViewController]Loading: \(book.url)")
            if let requestURL = NSURL(string: book.url) {
                let request = NSURLRequest(URL: requestURL)
                webView.loadRequest(request)
            }
        }
    }
    
    /// 获取数据
    private func loadData() {
        if lastRequest == nil {
            lastRequest = BookRequest()
            lastRequest?.book = bookId
        }
        
        lastRequest?.fetchTopicDetailModels { [weak self] (data: Book?, status: Int) -> Void in
            if status == RetCode.SUCCESS {
                self?.bookDataSource = data
            } else {
                ProgressHUD.showErrorHUD(self?.view, text: MessageInfo.NetworkError)
            }
        }
    }
    
    /// 收藏操作
    func favoriteAction(sender: UIButton) {
        sender.selected = !sender.selected
        let type  = FavoriteContant.TypeBook
        let objid = bookId
        Favorite.doFavorite(type, objid: objid, isFavorite: sender.selected) { [weak self]
            (result, status) -> Void in
            if status == RetCode.SUCCESS {
                if result == nil {
                    sender.selected = !sender.selected
                } else {
                    ProgressHUD.showSuccessHUD(self?.view, text: sender.selected ? "已收藏" : "已取消")
                }
            } else {
                ProgressHUD.showErrorHUD(self?.view, text: "操作未成功，请稍候再试!")
                sender.selected = !sender.selected
            }
        }
    }
    
    /// 点赞方法
    var praiseNum: String = ""
    func praisedAction(sender: UIButton) {
        
        sender.selected = !sender.selected
        praiseNum = bookDataSource?.praiseNum ?? "0"
        refreshPraisedButton(String(Int(bookDataSource?.praiseNum ?? "0")! + (sender.selected ? 1 : -1)))
        if let topic = bookDataSource {
            let type  = PraisedContant.TypeBook
            let objid = topic.id
            Praised.praised(type, objid: objid, isFavorite: sender.selected, handler: { [weak self] (result, status) -> Void in
                if status == RetCode.SUCCESS {
                    if result == "-1" {
                        sender.selected = !sender.selected
                        self?.refreshPraisedButton(self?.praiseNum ?? "")
                    } else {
                        ProgressHUD.showSuccessHUD(self?.view, text: sender.selected ? "已点赞" : "已取消")
                    }
                } else {
                    if status == RetCode.praised {
                        ProgressHUD.showErrorHUD(nil, text: "您已点过赞")
                        sender.selected = true
                        self?.refreshPraisedButton(self?.praiseNum ?? "")
                    } else {
                        sender.selected = !sender.selected
                        ProgressHUD.showErrorHUD(self?.view, text: "操作未成功，请稍候再试!")
                        self?.refreshPraisedButton(self?.praiseNum ?? "")
                    }
                }
            })
        }
        
    }
    
    private func refreshPraisedButton(praiseNum: String) {
        bookDataSource?.praiseNum = praiseNum
        praisedBUtton.setTitle(" " + "\(bookDataSource?.praiseNum ?? "0")", forState: .Normal)
        praisedBUtton.setTitle(" " + "\(bookDataSource?.praiseNum ?? "0")", forState: .Selected)
    }
    
    /// 分享
    func clickShareButton(button: UIButton) {
        if let book = bookDataSource {
            let bookTitle = "《" + book.title + "》"
            ShareView.sharedShareView.showShareAction(nil, url: book.shareurl, images: bookImageView.image, title: bookTitle, subtitle: book.content_desc)
        }

    }
}
