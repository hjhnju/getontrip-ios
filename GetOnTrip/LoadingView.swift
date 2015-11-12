//
//  LoadingView.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/11.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var messageLabel: UILabel = UILabel(color: SceneColor.bgBlack, title: "正在加载...", fontSize: 12)
    
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // 自定义方法
    
    func updateUI() {
        self.addSubview(activityView)
        self.addSubview(messageLabel)
        self.layer.cornerRadius = 3
        activityView.ff_AlignInner(.TopCenter, referView: self, size: CGSizeMake(37.0, 37.0))
        messageLabel.ff_AlignInner(.BottomCenter, referView: self, size: CGSizeMake(60, 60))
        self.hidden = true
    }
    
    func getSize() -> CGSize {
        return CGSizeMake(60, 60)
    }
    
    func start() {
        self.hidden = false
        activityView.startAnimating()
    }
    
    func stop() {
        self.hidden = true
        activityView.stopAnimating()
    }

}
