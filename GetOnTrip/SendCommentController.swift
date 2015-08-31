//
//  SendCommentController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/8/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class SendCommentController: UIViewController {

    @IBOutlet weak var commentTitleView: UIView!
    
    @IBOutlet weak var confirmIssue: UIButton!
    
    // 网络请求，加载数据
    var lastSuccessRequest: SendCommentRequest?
    
    var sightId: Int?
    
    var nearSendComment = [SendComment]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    // MARK: 加载更新数据
    private func refresh() {
        NSLog("notice:refreshing nearby data.")
        
        //         获取数据更新tableview
        if lastSuccessRequest == nil {
            lastSuccessRequest = SendCommentRequest(topicId: 1)
        }
        
//        lastSuccessRequest?.fetchCommentModels(handler: SendComment -> Void)
        lastSuccessRequest?.fetchCommentModels { (handler: [SendComment] ) -> Void in
            self.nearSendComment = handler
            print(handler)
        }

    }
}
