//
//  LoadingView.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/11.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    //MASK: Properties
    
    /// 设置加载中颜色
    var fontColor: UIColor? {
        didSet {
            if let fontColor = fontColor {
                messageLabel.textColor = fontColor
            }
        }
    }
    /// 设置背景颜色
    var bgColor: UIColor? {
        didSet {
            if let bgColor = bgColor {
                backgroundColor = bgColor
            }
        }
    }
    
    var activityType: UIActivityIndicatorViewStyle? {
        didSet {
            if let type = activityType {
                activityView.activityIndicatorViewStyle = type
            }
        }
    }
    
    //默认字体不显示
    var messageLabel: UILabel = UILabel(color: UIColor.clearColor(), title: "正在加载...", fontSize: 14)
    
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
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
    
    // MARKS:  自定义方法
    
    func updateUI() {
        backgroundColor = UIColor.clearColor()
        
        self.addSubview(activityView)
        self.addSubview(messageLabel)
        self.layer.cornerRadius = 3
        activityView.ff_AlignInner(.TopCenter, referView: self, size: CGSizeMake(34.0, 34.0), offset: CGPointMake(0, 17))
        messageLabel.ff_AlignInner(.BottomCenter, referView: self, size: CGSizeMake(70, 20), offset:CGPointMake(0, -6))
        self.hidden = true
    }
    
    func getSize() -> CGSize {
        return CGSizeMake(86, 86)
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
