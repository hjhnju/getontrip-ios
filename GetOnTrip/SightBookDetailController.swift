//
//  SightBookDetailController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/14.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout

class SightBookDetailController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {

    // MARK: - 属性
    /// 网络请求加载数据(添加)
    var lastSuccessAddRequest: SightBookDetailRequest?
    // TODO: bookId 必须有值
    var bookId: String?
    /// 顶部图片下View
    lazy var iconBottomView: UIView = UIView()
    
    /// 底部图片
    lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "2.jpg"))
    
    /// 书籍图片
    lazy var bookIcon: UIImageView = UIImageView(image: UIImage(named: "2.jpg"))
    
    /// 书籍标题
    lazy var titleLab: UILabel = UILabel(color: UIColor.blackColor(), title: "解读颐和园", fontSize: 24, mutiLines: true)
    
    lazy var author: UILabel = UILabel(color: UIColor(hex: 0x1C1C1C, alpha: 1.0), title: "张加冕／黄山书社出版社／2015-5／ISBN:345566743566", fontSize: 12, mutiLines: true)
    
    lazy var baseLine: UIView = UIView(color: UIColor(hex: 0x979797, alpha: 0.3))
    
    lazy var bottomView: UIView = UIView()
    
    lazy var collectBtn: UIButton = UIButton(image: "favorite", title: "", fontSize: 0)
    
    lazy var shareBtn: UIButton = UIButton(image: "shares_icon", title: "", fontSize: 0)
    
    lazy var buyBtn: UIButton = UIButton(image: "star_icon", title: "", fontSize: 0)
    
    lazy var bottomLine: UIView = UIView(color: UIColor(hex: 0x9C9C9C, alpha: 1.0))
    
    lazy var webView: UIWebView = UIWebView()
    
    var topConstraint: NSLayoutConstraint?

    var iconOffsetH: CGFloat = 0
    /// 图片模糊
    lazy var effect = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
    
    var data: BookDetail? {
        didSet {
            
            iconView.sd_setImageWithURL(NSURL(string: data!.image!))
            bookIcon.sd_setImageWithURL(NSURL(string: data!.image!))
            titleLab.text = data?.title
            author.text = data?.info
            showBookDetail(data!.content_desc!)
        }
    }
    
    /// 发送反馈消息
    private func loadSightData() {
        
        if lastSuccessAddRequest == nil {
            lastSuccessAddRequest = SightBookDetailRequest()
            lastSuccessAddRequest?.book = bookId!
        }
        
        lastSuccessAddRequest?.fetchTopicDetailModels {[unowned self] (handler: BookDetail) -> Void in
            self.data = handler
        }
    }
    
    //  MARK: - 初始化方法
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAddProperty()
        setupAutoLayout()
        loadSightData()
    }
    
    ///  添加相关属性
    private func setupAddProperty() {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButtonClicked:")
        view.backgroundColor = .whiteColor()
        
        view.addSubview(webView)
        view.addSubview(iconBottomView)
        view.addSubview(bottomView)
        
        iconBottomView.addSubview(iconView)
        iconView.addSubview(effect)
        iconBottomView.addSubview(bookIcon)
        iconBottomView.addSubview(titleLab)
        iconBottomView.addSubview(author)
        iconBottomView.addSubview(baseLine)
        
        bottomView.addSubview(collectBtn)
        bottomView.addSubview(shareBtn)
        bottomView.addSubview(buyBtn)
        bottomView.addSubview(bottomLine)
        
        buyBtn.addTarget(self, action: "buyButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        iconBottomView.userInteractionEnabled = true
        iconView.userInteractionEnabled = true
        bookIcon.userInteractionEnabled = true
        effect.alpha = 0.9
        
        let w = view.bounds.width - 18
        titleLab.preferredMaxLayoutWidth = w
        author.preferredMaxLayoutWidth = w
        
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .All
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        webView.delegate = self
        webView.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        iconOffsetH = CGRectGetMaxY(baseLine.frame) + 15
        webView.scrollView.contentInset = UIEdgeInsetsMake(iconOffsetH, 0, 0, 0)

    }
    
    ///  添加布局
    private func setupAutoLayout() {
        let w = view.bounds.width
        let cons = iconBottomView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(w, 267), offset: CGPointMake(0, 0))
        bottomView.ff_AlignInner(ff_AlignType.BottomLeft, referView: view, size: CGSizeMake(w, 47), offset: CGPointMake(0, 0))
        webView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: CGSizeMake(w, view.bounds.height - 47), offset: CGPointMake(0, 0))
        iconView.ff_AlignInner(ff_AlignType.TopLeft, referView: iconBottomView, size: CGSizeMake(w, 267), offset: CGPointMake(0, 0))
        bookIcon.ff_AlignInner(ff_AlignType.CenterCenter, referView: iconView, size: CGSizeMake(142, 181), offset: CGPointMake(0, 0))
        titleLab.ff_AlignVertical(ff_AlignType.BottomLeft, referView: iconView, size: nil, offset: CGPointMake(10, 17))
        author.ff_AlignVertical(ff_AlignType.BottomLeft, referView: titleLab, size: nil, offset: CGPointMake(0, 0))
        baseLine.ff_AlignVertical(ff_AlignType.BottomCenter, referView: author, size: CGSizeMake(w - 18, 0.5), offset: CGPointMake(0, 15))
        buyBtn.ff_AlignInner(ff_AlignType.CenterRight, referView: bottomView, size: CGSizeMake(28, 28), offset: CGPointMake(-10, 0))
        shareBtn.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: buyBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        collectBtn.ff_AlignHorizontal(ff_AlignType.CenterLeft, referView: shareBtn, size: CGSizeMake(28, 28), offset: CGPointMake(-28, 0))
        bottomLine.ff_AlignInner(ff_AlignType.TopLeft, referView: bottomView, size: CGSizeMake(w, 0.5), offset: CGPointMake(0, 0))
        topConstraint = iconBottomView.ff_Constraint(cons, attribute: NSLayoutAttribute.Top)
        effect.ff_AlignInner(ff_AlignType.TopLeft, referView: iconView, size: CGSizeMake(w, 267), offset: CGPointMake(0, 0))
    }
    
    
    // MARK: UIWebView and UIScrollView Delegate 代理方法
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        let localizedErrorMessage = NSLocalizedString("An error occured:", comment: "")
        
        let errorHTML = "<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">\(localizedErrorMessage) \(error!.localizedDescription)</div></body></html>"
        
        webView.loadHTMLString(errorHTML, baseURL: nil)
    }
    
    func showBookDetail(body: String) {
        
        let html = NSMutableString()
        html.appendString("<html><head>")
        html.appendFormat("<link rel=\"stylesheet\" href=\"%@\">", NSBundle.mainBundle().URLForResource("TopicDetail.css", withExtension: nil)!)
        html.appendString("</head><body>\(body)</body></html>")
        webView.loadHTMLString(html as String, baseURL: nil)
        
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y: CGFloat = -scrollView.contentOffset.y - iconOffsetH
        topConstraint?.constant = y
    }
    
    // MARK: - 购买书籍
    func buyButtonClick(btn: UIButton) {
        let sc = DetailWebViewController()
        sc.url = data?.url
        navigationController?.pushViewController(sc, animated: true)
    }
    
    // MARK: - 搜索(下一个控制器)
    var searchController: UISearchController?
    func searchButtonClicked(button: UIBarButtonItem) {
        // 获得父控制器
        let searchResultsController = SearchResultsViewController()
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController!.searchResultsUpdater = searchResultsController
        searchController!.hidesNavigationBarDuringPresentation = false
        let imgView   = UIImageView(image: UIImage(named: "search-bg0")!)
        imgView.frame = searchController!.view.bounds
        searchController!.view.addSubview(imgView)
        searchController!.view.sendSubviewToBack(imgView)
        searchController!.searchBar.barStyle = UIBarStyle.Black
        searchController!.searchBar.tintColor = UIColor.grayColor()
        searchController!.searchBar.becomeFirstResponder()
        searchController!.searchBar.keyboardAppearance = UIKeyboardAppearance.Default
        
        presentViewController(searchController!, animated: true, completion: nil)
    }


}
