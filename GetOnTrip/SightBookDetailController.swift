//
//  SightBookDetailController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/14.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import SVProgressHUD

struct BookViewContant {
    static let headerViewHeight:CGFloat      = 267 + 82
    static let headerImageViewHeight:CGFloat = 267
    static let bookViewHeight:CGFloat   = 181
    static let toolBarHeight:CGFloat    = 47
}

class SightBookDetailController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {

    // MARK: - 属性
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: BookDetailRequest?

    var bookId: String = ""
    
    /// headerView的顶部约束
    var headerViewTopConstraint: NSLayoutConstraint?
    
    /// headerView图片高度约束
    var headerViewHeightConstraint: NSLayoutConstraint?
    
    /// 顶部视图
    lazy var headerView: UIView = UIView()
    
    /// 顶部底图
    lazy var headerImageView: UIImageView = UIImageView()
    
    /// 书籍图片
    lazy var bookImageView: UIImageView = UIImageView()
    
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
    
    lazy var buyBtn: UIButton = UIButton(image: "topic_buy", title: "", fontSize: 0)
    
    lazy var toolLineView: UIView = UIView(color: SceneColor.lightGray)
    
    /// 书籍内容
    lazy var webView: UIWebView = UIWebView()
    
    var data: BookDetail? {
        didSet {
            if let data = data {
                collectBtn.selected = data.collected == "" ? false : true
                headerImageView.sd_setImageWithURL(NSURL(string: data.image), placeholderImage: PlaceholderImage.defaultSmall)
                bookImageView.sd_setImageWithURL(NSURL(string: data.image), placeholderImage: PlaceholderImage.defaultSmall)
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
    }
    
    ///  添加相关属性
    private func initView() {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "途知", style: .Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: "clickSearchButton:")
        view.backgroundColor = .whiteColor()

        view.addSubview(webView)
        view.addSubview(headerView)
        view.addSubview(toolbarView)
        
        headerView.backgroundColor = UIColor.whiteColor()
        headerView.addSubview(headerImageView)
        headerView.addSubview(bookImageView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(authorLabel)
        headerView.addSubview(headerLineView)
        headerImageView.addSubview(blurView)
        headerImageView.clipsToBounds = true
        headerImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        toolbarView.addSubview(collectBtn)
        toolbarView.addSubview(shareBtn)
        toolbarView.addSubview(buyBtn)
        toolbarView.addSubview(toolLineView)
        
        collectBtn.setImage(UIImage(named: "topic_star_select"), forState: UIControlState.Selected)
        collectBtn.addTarget(self, action: "clickFavoriteButton:", forControlEvents: UIControlEvents.TouchUpInside)
        buyBtn.addTarget(self, action: "clickBuyButton:", forControlEvents: UIControlEvents.TouchUpInside)
        shareBtn.addTarget(self, action: "clickShareButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        headerView.userInteractionEnabled = true
        headerImageView.userInteractionEnabled = true
        bookImageView.userInteractionEnabled = true
        blurView.alpha = 1
        
        let w = view.bounds.width - 18
        titleLabel.preferredMaxLayoutWidth = w
        authorLabel.preferredMaxLayoutWidth = w
        
        automaticallyAdjustsScrollViewInsets = false
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .All
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator   = false
        webView.scrollView.delegate = self
        webView.delegate = self
        webView.backgroundColor = UIColor.whiteColor()
        webView.scrollView.contentInset = UIEdgeInsetsMake(BookViewContant.headerViewHeight, 10, 10, 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    ///  添加布局
    private func setupAutoLayout() {
        let w = view.bounds.width
        
        let cons = headerView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(w, BookViewContant.headerViewHeight), offset: CGPointMake(0, 0))
        let headerImageViewCons = headerImageView.ff_AlignInner(.TopLeft, referView: headerView, size: CGSizeMake(view.bounds.width, BookViewContant.headerImageViewHeight))
        blurView.ff_Fill(headerImageView)
        bookImageView.ff_AlignInner(ff_AlignType.CenterCenter, referView: headerImageView, size: CGSizeMake(142, 181), offset: CGPointMake(0, (BookViewContant.headerImageViewHeight-BookViewContant.bookViewHeight)/2 - 11))
        titleLabel.ff_AlignVertical(ff_AlignType.BottomLeft, referView: headerImageView, size: nil, offset: CGPointMake(10, 17))
        authorLabel.ff_AlignVertical(ff_AlignType.BottomLeft, referView: titleLabel, size: nil, offset: CGPointMake(0, 6))
        headerLineView.ff_AlignVertical(ff_AlignType.BottomLeft, referView: headerImageView, size: CGSizeMake(w - 18, 0.5), offset: CGPointMake(9, BookViewContant.headerViewHeight - BookViewContant.headerImageViewHeight))
        
        webView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(view.bounds.width, view.bounds.height - BookViewContant.toolBarHeight), offset: CGPointMake(0, 0))
        
        toolbarView.ff_AlignInner(ff_AlignType.BottomLeft, referView: view, size: CGSizeMake(view.bounds.width, BookViewContant.toolBarHeight), offset: CGPointMake(0, 0))
        
        buyBtn.ff_AlignInner(ff_AlignType.CenterRight, referView: toolbarView, size: CGSizeMake(28, 28), offset: CGPointMake(-10, 0))
        shareBtn.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: buyBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        collectBtn.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: shareBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        toolLineView.ff_AlignInner(ff_AlignType.TopLeft, referView: toolbarView, size: CGSizeMake(w, 0.5), offset: CGPointMake(0, 0))
        
        /// headerView的顶部约束
        headerViewTopConstraint = headerView.ff_Constraint(cons, attribute: NSLayoutAttribute.Top)
        headerViewHeightConstraint = headerImageView.ff_Constraint(headerImageViewCons, attribute: NSLayoutAttribute.Height)
    }
    
    
    // MARK: UIWebView and UIScrollView Delegate 代理方法
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        let localizedErrorMessage = NSLocalizedString("An error occured:", comment: "")
        
        let errorHTML = "<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">\(localizedErrorMessage) \(error!.localizedDescription)</div></body></html>"
        
        webView.loadHTMLString(errorHTML, baseURL: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let gap = BookViewContant.headerViewHeight + offsetY
        
        //上拉时headerView向上移动
        if gap > 0 {
            let initTop: CGFloat = 0.0
            let newTop = min(-gap, initTop)
            headerViewTopConstraint?.constant = newTop
        }
        
        //下拉时扩大headerView
        if gap < 0 {
            let newHeight = max(BookViewContant.headerImageViewHeight + -gap, BookViewContant.headerImageViewHeight)
            headerViewHeightConstraint?.constant = newHeight
        }
    }
    
    // MARK: 自定义方法
    
    /// 展示内容书籍
    func showBookDetail(body: String) {
        
        let html = NSMutableString()
        html.appendString("<html><head>")
        html.appendFormat("<link rel=\"stylesheet\" href=\"%@\">", NSBundle.mainBundle().URLForResource("TopicDetail.css", withExtension: nil)!)
        html.appendString("</head><body>\(body)</body></html>")
        webView.loadHTMLString(html as String, baseURL: nil)
    }
    
    
    /// 获取数据
    private func loadData() {
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = BookDetailRequest()
            lastSuccessAddRequest?.book = bookId
        }
        
        lastSuccessAddRequest?.fetchTopicDetailModels {[weak self] (data: BookDetail?, status: Int) -> Void in
            if status == RetCode.SUCCESS {
                self?.data = data
            } else {
                SVProgressHUD.showInfoWithStatus("您的网络不给力!")
            }
        }
    }
    
    /// 收藏
    func clickFavoriteButton(sender: UIButton) {
        
        if sharedUserAccount == nil {
            LoginView.sharedLoginView.addLoginFloating({ (result, error) -> () in
                let resultB = result as! Bool
                if resultB == true {
                    CollectAddAndCancel.sharedCollectAddCancel.fetchCollectionModels(5, objid:self.bookId, isAdd: !sender.selected) { (handler) -> Void in
                        print(handler)
                        if handler as! String == "1" {
                            sender.selected = !sender.selected
                            SVProgressHUD.showInfoWithStatus(sender.selected ? "已收藏" : "已取消")
                        } else {
                            SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                        }
                        
                    }
                }
            })
        } else {
            CollectAddAndCancel.sharedCollectAddCancel.fetchCollectionModels(5, objid:bookId, isAdd: !sender.selected) { (handler) -> Void in
                print(handler)
                if handler as! String == "1" {
                    sender.selected = !sender.selected
                    SVProgressHUD.showInfoWithStatus(sender.selected ? "已收藏" : "已取消")
                } else {
                    SVProgressHUD.showInfoWithStatus("您的网络不给力!")
                }
                
            }
        }
        
    }
    
    /// 购买书籍
    func clickBuyButton(btn: UIButton) {
        
        if "" != data?.url {
            let sc = DetailWebViewController()
            sc.url = data?.url
            navigationController?.pushViewController(sc, animated: true)
        } else {
            print("[BookDetailView]Warning:无相关购买链接")
        }
    }
    
    /// 搜索(下一个控制器)
    func clickSearchButton(button: UIBarButtonItem) {
        
        presentViewController(SearchViewController(), animated: true, completion: nil)
    }
    
    /// 分享
    func clickShareButton(button: UIButton) {
        print("分享")
    }

    /// 搜索跳入之后消失控制器
    func dismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
