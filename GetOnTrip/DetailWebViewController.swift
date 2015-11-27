//
//  SightDetailController.swift
//  GetOnTrip
//
//  Created by 和俊华 on 15/11/14.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import WebKit
import FFAutoLayout

class DetailWebViewController: BaseViewController, WKNavigationDelegate, UIScrollViewDelegate {
    
    /// 书籍内容
    var webView: WKWebView = WKWebView(color: UIColor.grayColor())
    
    /// 自定义导航
    var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: UIColor.whiteColor(), titleSize: 14)
    
    /// 刷新view
    var loadingView: LoadingView = LoadingView()
    
    /// 所加载的url
    var url: String?
    
    /// 视频
    var video: Video?
    
    /// 分享view
    lazy var shareView: ShareView = ShareView()
        
    // MARK: - 初始化控件
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initNavBar()
        initWebView()
        loadingWeb()
        autolayout()
    }
    
    private func initView() {
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(webView)
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
    }
    
    private func initNavBar() {
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: "途知", target: self, action: "popViewAction:")
        navBar.setButtonTintColor(UIColor.yellowColor())
        navBar.setBlurViewEffect(false)
        navBar.backgroundColor = SceneColor.frontBlack
        navBar.rightButton.setImage(UIImage(named: "topic_star"), forState: .Normal)
        navBar.rightButton.setImage(UIImage(named: "bar_collect_select"), forState: .Selected)
        navBar.rightButton.addTarget(self, action: "collectVideoAction:", forControlEvents: .TouchUpInside)
        navBar.rightButton2.setImage(UIImage(named: "topic_share"), forState: .Normal)
        navBar.rightButton2.setImage(UIImage(named: "share_yellow"), forState: .Selected)
        navBar.rightButton2.addTarget(self, action: "shareVideoAction:", forControlEvents: .TouchUpInside)
        navBar.rightButton.selected  = video?.collected == "1" ? true  : false
    }
    
    private func autolayout() {
        webView.frame = view.bounds
        loadingView.ff_AlignInner(.CenterCenter, referView: view, size: loadingView.getSize())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webView.scrollView.delegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        webView.scrollView.delegate = nil
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    func initWebView() {
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator   = false
        webView.navigationDelegate  = self
        webView.backgroundColor = UIColor.whiteColor()
        webView.opaque = false
    }
    
    // MARK: webView Delegate
    private func loadingWeb() {
        print("[DetailWebViewController]PreLoading: \(url)")
        //分割＃部分
        var section = ""
        if let sectionIndex = url?.rangeOfString("#")?.startIndex {
            section = url?.substringFromIndex(sectionIndex) ?? ""
            url = url?.substringToIndex(sectionIndex)
        }
        
        if var url = url?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            //合并回＃
            url = url + section
            if let nsurl = NSURL(string: url) {
                print("[DetailWebViewController]:RealLoading=\(nsurl)")
                webView.loadRequest(NSURLRequest(URL: nsurl))
            }
        }
    }
    
    // 页面加载失败时调用
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print("[DetailWebViewController]webView error \(error.localizedDescription)")
        let errorHTML = "<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">网络内容加载失败</div></body></html>"
        webView.loadHTMLString(errorHTML, baseURL: nil)
    }
    
    // 页面开始加载时调用
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingView.start()
    }
    
    // 页面加载完成之后调用
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        loadingView.stop()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        shareView.shareCancleAction()
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
    }
    
    // MARK: - 自定义方法
    /// 分享视频方法
    func shareVideoAction(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected {
            let videoImageView = UIImageView()
            videoImageView.sd_setImageWithURL(NSURL(string: video?.image ?? ""))
            shareView.showShareAction(self.view, url: video?.url, images: videoImageView.image, title: video?.title, subtitle: nil)            
        } else {
            shareView.shareCancleAction()
        }
        
    }
    
    /// 收藏视频方法
    func collectVideoAction(sender: UIButton) {
        sender.selected = !sender.selected
        let type  = FavoriteContant.TypeVideo
        let objid = video?.id ?? "0"
        Favorite.doFavorite(type, objid: objid, isFavorite: sender.selected) {
            (result, status) -> Void in
            if status == RetCode.SUCCESS {
                if result == nil {
                    sender.selected = !sender.selected
                } else {
                    ProgressHUD.showSuccessHUD(self.view, text: sender.selected ? "已收藏" : "已取消")
                }
            } else {
                ProgressHUD.showErrorHUD(self.view, text: "操作未成功，请稍候再试")
                sender.selected = !sender.selected
            }
        }
    }
}
