//
//  TopicDetailController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/26.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class TopicDetailController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    // 网络请求，加载数据
    var lastSuccessRequest: TopicDetailRequest?
    
    var sightId: Int?
    
    var nearTopics: TopicDetail? {
        didSet {
            let errorHTML = ""

            webView.loadHTMLString(errorHTML, baseURL: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    // MARK: 加载更新数据
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        // 获取数据更新tableview
        if lastSuccessRequest == nil {
            print(sightId)
            lastSuccessRequest = TopicDetailRequest(topicId: sightId!)
        }
        
        lastSuccessRequest!.fetchModels { (handler: TopicDetail) -> Void in
            print(handler)
            print("-------")
        }

    }
    
}
