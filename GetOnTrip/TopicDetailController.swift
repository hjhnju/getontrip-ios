
//
//  TopicDetailController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/9/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class TopicDetailController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    ///  隐藏电池栏方法（有个ios6设置的方法，但有警告，如最后无解则采取那个办法）
    ///
    ///  - returns: 目前未调用，原因未查清
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: 相关属性
    var topHeightConstraint: NSLayoutConstraint?
//    var iconBack: CGFloat?
    
    lazy var iconBack: UIView = UIView()
    
    lazy var iconView: UIImageView = UIImageView()
    
    lazy var webView: UIWebView = UIWebView()
    
    /// 标题
    lazy var titleLabel: UILabel = UILabel(color: UIColor.whiteColor(), title: "长白山天池湖水只出不进，为何终年不减只出不进？", fontSize: 24, mutiLines: false)
    
    /// 标签
    lazy var labelBtn: UIButton = UIButton(title: "历史", fontSize: 9, radius: 3, titleColor: UIColor.whiteColor())
    
    lazy var collect: UIButton = UIButton(image: "collect_icon", title: " 18", fontSize: 12, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.7))
    
    lazy var visit: UIButton = UIButton(image: "visit_icon", title: " 90", fontSize: 12, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.7))
    
    lazy var bottomView: UIView = UIView()
    
    lazy var commentLab: UILabel = UILabel(color: UIColor(hex: 0x9C9C9C, alpha: 1.0), title: "11条评论", fontSize: 11, mutiLines: true)
    
    lazy var commentBtn: UIButton = UIButton(image: "favorite", title: "", fontSize: 0)

    lazy var shareBtn: UIButton = UIButton(image: "shares_icon", title: "", fontSize: 0)
    
    lazy var collectBtn: UIButton = UIButton(image: "star_icon", title: "", fontSize: 0)
    
    lazy var nameLabel: UILabel = UILabel(color: UIColor(hex: 0x9C9C9C, alpha: 1.0), title: "长白山", fontSize: 14, mutiLines: false)
    
    var content: String?
    
    lazy var bottomLine: UIView = UIView(color: UIColor(hex: 0x9C9C9C, alpha: 1.0))
    
    lazy var cover: UIButton = UIButton(color: UIColor.blackColor(), alphaF: 0.0)
    
    lazy var commentBottomView: UIView = UIView()
    
    lazy var commentTableView: UITableView = UITableView()
    
    lazy var issueCommentView: UIView = UIView(color: UIColor.whiteColor())
    
    lazy var issueTextfield: UITextField = UITextField()
    
    lazy var issueCommentBtn: UIButton = UIButton(title: "确认发布", fontSize: 12, radius: 10, titleColor: UIColor(hex: 0x696969, alpha: 1.0))
    
    var topicDetail: TopicDetail? {
        didSet {
            content = topicDetail!.content
            showTopicDetail()
            iconView.sd_setImageWithURL(NSURL(string: topicDetail!.image!))
            titleLabel.text = topicDetail?.title
            labelBtn.setTitle(topicDetail?.label, forState: UIControlState.Normal)
            collect.setTitle(" " + topicDetail!.collect!, forState: UIControlState.Normal)
            visit.setTitle(" " + topicDetail!.visit!, forState: UIControlState.Normal)
            commentLab.text = topicDetail!.commentNum! + "条评论"
            nameLabel.text = topicDetail?.sight_name
        }
    }
    
    deinit {
        print("我走了没TopicDetailController")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /// 详情ID必有
    var topicId: String? = "54"
    
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: TopicDetailRequest?
    
    // MARK: - 初始化方法
    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        prefersStatusBarHidden()
        refreshBar()
        loadSightData()
        setupAddProperty()
        setupAutoLayout()
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
        bottomView.addSubview(bottomLine)
        commentBottomView.addSubview(commentTableView)
        commentBottomView.addSubview(issueCommentView)
        issueCommentView.addSubview(issueTextfield)
        issueCommentView.addSubview(issueCommentBtn)
        
        commentBottomView.clipsToBounds = true
        
        shareBtn.addTarget(self, action: "doSharing:", forControlEvents: UIControlEvents.TouchUpInside)
        collectBtn.addTarget(self, action: "doFavorite:", forControlEvents: UIControlEvents.TouchUpInside)
        commentBtn.addTarget(self, action: "doComment:", forControlEvents: UIControlEvents.TouchUpInside)
        cover.addTarget(self, action: "coverClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        titleLabel.numberOfLines = 2
        titleLabel.preferredMaxLayoutWidth = view.bounds.width - 20
        iconView.contentMode = UIViewContentMode.ScaleAspectFill
        iconView.clipsToBounds = true
        labelBtn.layer.borderWidth = 0.5
        labelBtn.layer.borderColor = UIColor.whiteColor().CGColor

        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .All
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.delegate = self
        webView.scrollView.contentInset = UIEdgeInsetsMake(267, 0, 0, 0)
        automaticallyAdjustsScrollViewInsets = false
        webView.delegate = self
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setupAutoLayout() {
        
        let cons = iconBack.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, 267), offset: CGPointMake(0, 0))
        webView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - 47), offset: CGPointMake(0, 0))
        bottomView.ff_AlignInner(ff_AlignType.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, 47), offset: CGPointMake(0, 0))
        iconView.ff_Fill(bottomView)
        labelBtn.ff_AlignInner(ff_AlignType.TopRight, referView: iconBack, size: CGSizeMake(32, 14), offset: CGPointMake(-17, 7 + 44))
        collect.ff_AlignInner(ff_AlignType.BottomLeft, referView: iconBack, size: nil, offset: CGPointMake(10, -7))
        visit.ff_AlignHorizontal(ff_AlignType.CenterRight, referView: collect, size: nil, offset: CGPointMake(11, 0))
        titleLabel.ff_AlignVertical(ff_AlignType.TopLeft, referView: collect, size: nil, offset: CGPointMake(0, 1))
        commentLab.ff_AlignInner(ff_AlignType.CenterLeft, referView: bottomView, size: nil, offset: CGPointMake(14, 0))
        commentBtn.ff_AlignInner(ff_AlignType.CenterRight, referView: bottomView, size: CGSizeMake(28, 28), offset: CGPointMake(-10, 0))
        shareBtn.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: commentBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        collectBtn.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: shareBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        bottomLine.ff_AlignInner(ff_AlignType.TopCenter, referView: bottomView, size: CGSizeMake(view.bounds.width, 0.5), offset: CGPointMake(0, 0))
        topHeightConstraint = iconBack.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
    }
    
    func refreshBar(){
        //设置statusbar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.tintColor    = SceneColor.lightGray
        navigationController?.navigationBar.shadowImage = UIImage()
        nameLabel.sizeToFit()
        navigationItem.titleView = nameLabel
        nameLabel.alpha = 0.0
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButtonClicked:")
    }

    // MARK: UIWebView and UIScrollView Delegate 代理方法
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        let localizedErrorMessage = NSLocalizedString("An error occured:", comment: "")
        
        let errorHTML = "<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">\(localizedErrorMessage) \(error!.localizedDescription)</div></body></html>"
        
        webView.loadHTMLString(errorHTML, baseURL: nil)
    }
    
    func showTopicDetail() {
        
        let html = NSMutableString()
        html.appendString("<html>")
        html.appendString("<head>")
        html.appendFormat("<link rel=\"stylesheet\" href=\"%@\">", NSBundle.mainBundle().URLForResource("TopicDetail.css", withExtension: nil)!)
        html.appendString("</head>")
        html.appendString("<body>")
        html.appendString(setupBody())
        html.appendString("</body>")
        html.appendString("</html>")
        webView.loadHTMLString(html as String, baseURL: nil)
//        webView.loadHTMLString(html as String, baseURL: nil)
    }
    
    func setupBody() -> String {
        let onload = "img onload=\"this.onclick = function() {window.location.href = 'bn:src='};\" src=\"http://123.57.46.229:8301"
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
        let navigationBarHeight: CGFloat = 0
        var height = -(scrollView.contentOffset.y + navigationBarHeight)
        if height < 44 {
            height = 44
        }

        topHeightConstraint?.constant = height

        var alpha = abs(44/scrollView.contentOffset.y)
        if scrollView.contentOffset.y > -44 {
            alpha = 0.9
        }
        
        let image = imageWithColor(UIColor(white: 1, alpha: alpha))
        navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
        
        if scrollView.contentOffset.y < -265 {
            navigationController?.navigationBar.setBackgroundImage(imageWithColor(UIColor(white: 1, alpha: 0)), forBarMetrics: UIBarMetrics.Default)
        }
    }
    
    func imageWithColor(color: UIColor) -> UIImage {
        
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let ref = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(ref, color.CGColor)
        CGContextFillRect(ref, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
        
    }
    
    // MARK: - 评论、分享、收藏
    func doFavorite(sender: UIButton) {
        print("收藏")

        
        
    }
    
    
    func doSharing(sender: UIButton) {
        print("分享")
        
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        
        shareParames.SSDKSetupShareParamsByText("分享内容",
            images : UIImage(named: "shareImg.png"),
            url : NSURL(string:"http://mob.com"),
            title : "分享标题",
            type : SSDKContentType.Image)
        
        //2.进行分享
        ShareSDK.share(SSDKPlatformType.TypeSinaWeibo, parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
            
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
    
    func doComment(sender: UIButton) {
    
        UIApplication.sharedApplication().keyWindow?.addSubview(cover)
        UIApplication.sharedApplication().keyWindow?.addSubview(commentBottomView)
        cover.frame = UIScreen.mainScreen().bounds
        commentBottomView.frame = CGRectMake(view.bounds.width - 24, view.bounds.height - 44, 0, 0)
        commentTableView.frame = CGRectMake(0, 0, 0, 0)
        issueCommentView.backgroundColor = UIColor.orangeColor()
        issueTextfield.backgroundColor = UIColor.greenColor()
        issueCommentBtn.backgroundColor = UIColor.yellowColor()
        
        UIView.animateWithDuration(0.5) { [unowned self] () -> Void in
            self.cover.alpha = 0.7
            self.commentBottomView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - 444 - 44, UIScreen.mainScreen().bounds.width, 444)
            self.commentTableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 444)
            self.issueCommentView.frame = CGRectMake(0, 444 - 50, self.view.bounds.width, 50)
            self.issueTextfield.frame = CGRectMake(9, 8, UIScreen.mainScreen().bounds.width - 134, 34)
            self.issueCommentBtn.frame = CGRectMake(CGRectGetMaxX(self.issueTextfield.frame) + 15, 8, 91, 34)
        }
    
    }
    
    /// 当键盘弹出的时候，执行相关操作
    func keyboardChanged(not: NSNotification) {
        let duration = not.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        let r = not.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        print("键盘弹出来了")
//        bottomConstraint.constant = UIScreen.mainScreen().bounds.size.height - r!.origin.y
        UIView.animateWithDuration(duration, animations: { () -> Void in
//            self.issueCommentView.frame.origin.y = UIScreen.mainScreen().bounds.size.height - r!.origin.y - 47 - 57
            self.commentBottomView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - 444 - 44, self.view.bounds.width, 444 - r!.height)
        }) { (_) -> Void in
//            NSHTTPCookieStorage
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
    }
    
    
    // MARK: - 遮罩方法
    func coverClick(serder: UIButton) {
        
        UIView.animateWithDuration(0.5, animations: { [unowned self] () -> Void in
            
                self.cover.alpha = 0.0
                self.commentBottomView.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 24, UIScreen.mainScreen().bounds.height - 44, 0, 0)
            
            }) { [unowned self]  (_) -> Void in
                
                self.cover.removeFromSuperview()
                self.commentBottomView.removeFromSuperview()
        }


    }
    
}



