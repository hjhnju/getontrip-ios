
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
    static let commentViewHeight:CGFloat = UIScreen.mainScreen().bounds.height - UIScreen.mainScreen().bounds.height / 1.6 - 44
}

class TopicViewController: BaseViewController, UIScrollViewDelegate, UIWebViewDelegate {
    
    // MARK: 相关属性
    
    /// 自定义导航
    var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: SceneColor.frontBlack, titleSize: 14, hasStatusBar: false)
    
    /// 头部视图
    lazy var headerView: UIView = UIView()
    
    /// 头部视图高度约束
    var headerHeightConstraint: NSLayoutConstraint?
    
    lazy var headerImageView: UIImageView = UIImageView(image: PlaceholderImage.defaultLarge)
    
    /// 文章标题
    lazy var headerTitleLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "", fontSize: 24, mutiLines: false)
    
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
    
    lazy var bottomLine: UIView = UIView(color: SceneColor.lightGray)
    
    lazy var cover: UIButton = UIButton(color: UIColor.blackColor(), alphaF: 0.0)
  
    lazy var shareView: ShareView = ShareView()
    
    lazy var commentVC: CommentTopicController = {
        return CommentTopicController()
    }()
    
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
                labelBtn.setTitle("  " + topic.tagname + "  ", forState: UIControlState.Normal)
                favNumLabel.setTitle(" " + topic.collect, forState: UIControlState.Normal)
                visitNumLabel.setTitle(" " + topic.visit, forState: UIControlState.Normal)
                
                collectBtn.selected = topic.collected == "" ? false : true
                commentVC.topicId   = topic.id
                commentLab.text     = topic.comment
                labelBtn.hidden      = false
                favNumLabel.hidden   = false
                visitNumLabel.hidden = false

                showTopicDetail()
            }
        }
    }
    
    /// 网络请求加载数据(添加)
    var lastRequest: TopicRequest?
    
    
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
        
        initView()
        refreshHeader()
        loadSightData()
        setupDefaultProperty()
        setupAutoLayout()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        //还原
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        super.viewDidDisappear(animated)
    }
    
    func initView() {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
        
        view.addSubview(webView)
        webView.addSubview(loadingView)
        view.addSubview(headerView)
        view.addSubview(toolbarView)
        view.backgroundColor = UIColor.whiteColor()
        headerView.addSubview(headerImageView)
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(labelBtn)
        headerView.addSubview(favNumLabel)
        headerView.addSubview(visitNumLabel)
        toolbarView.addSubview(commentLab)
        toolbarView.addSubview(commentBtn)
        toolbarView.addSubview(shareBtn)
        toolbarView.addSubview(collectBtn)
        toolbarView.addSubview(bottomLine)
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        
        headerView.userInteractionEnabled = true
        headerImageView.userInteractionEnabled = true
        labelBtn.hidden      = true
        favNumLabel.hidden   = true
        visitNumLabel.hidden = true
        cover.backgroundColor = UIColor.blackColor()
        
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: nil, target: self, action: "popViewAction:")
        navBar.setRightBarButton(UIImage(named: "search"), title: nil, target: self, action: "searchAction:")
        navBar.setButtonTintColor(SceneColor.frontBlack)
        navBar.setStatusBarHidden(true)
        
        webView.backgroundColor = UIColor.whiteColor()
        webView.opaque = false
        collectBtn.setImage(UIImage(named: "topic_star_select"), forState: UIControlState.Selected)
    }
    
    func refreshHeader(){
        headerTitleLabel.alpha = headerAlpha
        favNumLabel.alpha = headerAlpha
        visitNumLabel.alpha = headerAlpha
        labelBtn.alpha = headerAlpha
    }
    
    /// 发送反馈消息
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
                SVProgressHUD.showErrorWithStatus("网络连接失败，请检查网络")
            }
        })
    }
    
    private func setupDefaultProperty() {
        shareBtn.addTarget(self, action: "doSharing:", forControlEvents: UIControlEvents.TouchUpInside)
        collectBtn.addTarget(self, action: "doFavorite:", forControlEvents: UIControlEvents.TouchUpInside)
        commentBtn.addTarget(self, action: "doComment:", forControlEvents: UIControlEvents.TouchUpInside)
        cover.addTarget(self, action: "coverClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        headerTitleLabel.numberOfLines = 2
        headerTitleLabel.preferredMaxLayoutWidth = view.bounds.width - 20
        headerImageView.contentMode = UIViewContentMode.ScaleAspectFill
        headerImageView.clipsToBounds = true
        labelBtn.layer.borderWidth = 0.5
        labelBtn.layer.borderColor = UIColor(hex: 0xFFFFFF, alpha: 0.8).CGColor
        labelBtn.backgroundColor = SceneColor.fontGray
        
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
        labelBtn.contentEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        labelBtn.ff_AlignVertical(ff_AlignType.TopLeft, referView: headerTitleLabel, size: nil, offset: CGPointMake(0, -5))
        favNumLabel.ff_AlignInner(ff_AlignType.BottomLeft, referView: headerView, size: nil, offset: CGPointMake(20, -7))
        visitNumLabel.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: favNumLabel, size: nil, offset: CGPointMake(11, 0))
        headerTitleLabel.ff_AlignVertical(ff_AlignType.TopLeft, referView: favNumLabel, size: nil, offset: CGPointMake(0, 1))
        headerHeightConstraint = headerView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
        //toolbar views
        commentLab.ff_AlignInner(ff_AlignType.CenterLeft, referView: toolbarView, size: nil, offset: CGPointMake(14, 0))
        commentBtn.ff_AlignInner(ff_AlignType.CenterRight, referView: toolbarView, size: CGSizeMake(28, 28), offset: CGPointMake(-10, 0))
        shareBtn.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: commentBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        collectBtn.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: shareBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        bottomLine.ff_AlignInner(ff_AlignType.TopCenter, referView: toolbarView, size: CGSizeMake(view.bounds.width, 0.5), offset: CGPointMake(0, 0))
        
        loadingView.ff_AlignInner(.TopCenter, referView: webView, size: loadingView.getSize(), offset: CGPointMake(0, (view.bounds.height - TopicViewContant.toolBarHeight + TopicViewContant.headerViewHeight)/2))
        
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var loadingView: LoadingView = LoadingView(color: SceneColor.lightGray)
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadingView.start()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadingView.stop()
    }
    
    // MARK: UIWebView and UIScrollView Delegate 代理方法
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        let localizedErrorMessage = NSLocalizedString("An error occured:", comment: "")
        
        let errorHTML = "<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">\(localizedErrorMessage) \(error!.localizedDescription)</div></body></html>"
        
        webView.loadHTMLString(errorHTML, baseURL: nil)
    }
    
    /// 显示详情
    func showTopicDetail() {
        if let topic =  topicDataSource {
            print("[WebView]Loading: \(topic.contenturl)")
            if let requestURL = NSURL(string: topic.contenturl) {
                let request = NSURLRequest(URL: requestURL)
                webView.loadRequest(request)
            }
        }
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
    
    // MARK: - 评论、分享、收藏
    func doFavorite(sender: UIButton) {
        
        if let topic = topicDataSource {
            let type  = FavoriteContant.TypeTopic
            let objid = topic.id
            Favorite.doFavorite(type, objid: objid, isFavorite: !sender.selected) {
                (result, status) -> Void in
                if status == RetCode.SUCCESS {
                    sender.selected = !sender.selected
                    SVProgressHUD.showInfoWithStatus(sender.selected ? "已收藏" : "已取消")
                } else {
                    SVProgressHUD.showInfoWithStatus("收藏未成功，请稍后再试")
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
        
        UIApplication.sharedApplication().keyWindow?.addSubview(cover)
        UIApplication.sharedApplication().keyWindow?.addSubview(commentVC.view)
        commentVC.topicId = topicDataSource?.id ?? ""
        commentVC.view.clipsToBounds = true
        commentVC.view.frame = CGRectMake(w - 28, h - 44, 0, 0)
        cover.frame = UIScreen.mainScreen().bounds
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.commentVC.view.frame = CGRectMake(0, TopicViewContant.commentViewHeight, w, UIScreen.mainScreen().bounds.height / 1.6)
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
        let transFromValue = keyBoardY! - view.bounds.height

        let bound = UIScreen.mainScreen().bounds
        if transFromValue == 0{
            self.commentVC.view.frame = CGRectMake(0, bound.height - (bound.height / 1.6) - 44, view.bounds.width, bound.height / 1.6)
            self.commentVC.tableViewConH?.constant = bound.height / 1.6 - 91
            self.commentVC.tableView.layoutIfNeeded()
        } else {
            self.commentVC.view.frame = CGRectMake(0, 44, view.bounds.width, bound.height - keyBoardFrame!.height - 44)
            self.commentVC.tableViewConH?.constant = bound.height - keyBoardFrame!.height - 44
            if self.commentVC.reloadIndexPath.row != 0 {
                self.commentVC.tableView.scrollToRowAtIndexPath(self.commentVC.reloadIndexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
            }
            self.commentVC.tableView.layoutIfNeeded()
        }
        
    }
}