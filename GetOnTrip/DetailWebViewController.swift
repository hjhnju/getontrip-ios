//
//  SightDetailController.swift
//  GetOnTrip
//
//  Created by 和俊华 on 15/11/14.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import WebKit

class DetailWebViewController: BaseViewController, WKNavigationDelegate {
    
    /// 书籍内容
    var webView: WKWebView = WKWebView(color: UIColor.grayColor())
    
    /// 自定义导航
    var navBar: CustomNavigationBar = CustomNavigationBar(title: "", titleColor: UIColor.whiteColor(), titleSize: 14)
    
    var loadingView: LoadingView = LoadingView()
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(webView)
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        
        navBar.setBackBarButton(UIImage(named: "icon_back"), title: "途知", target: self, action: "popViewAction:")
        navBar.setButtonTintColor(UIColor.yellowColor())
        navBar.setBlurViewEffect(false)
        navBar.backgroundColor = SceneColor.frontBlack
        
        initWebView()
        
        
        autolayout()
        loadingWeb()
    }
    
    private func autolayout() {
        webView.frame = view.bounds
        loadingView.ff_AlignInner(.CenterCenter, referView: view, size: loadingView.getSize())
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
}
