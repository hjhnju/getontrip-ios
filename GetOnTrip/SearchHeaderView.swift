//
//  SearchHeaderView.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/12/14.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SearchHeaderView: UITableViewHeaderFooterView {
    
    /// 搜索历史标签
    lazy var recordLabel: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "", fontSize: 12, mutiLines: true, fontName: Font.PingFangSCLight)
    
    /// 清除按钮
    lazy var recordDelButton: DeleteButton = DeleteButton(title: "", fontSize: 10, radius: 0, titleColor: UIColor(hex: 0xFFFFFF, alpha: 0.6), fontName: Font.PingFangSCLight)
    
    /// 基线
    lazy var baseLine: UIView = UIView(color: UIColor(hex: 0xBDBDBD, alpha: 0.15))

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let imageView = UIImageView(image: UIImage(named: "search_group"))
        backgroundView = imageView
        backgroundView?.alpha = 1.0
        baseLine.hidden = true
        
        contentView.backgroundColor = UIColor.clearColor()
        contentView.addSubview(recordLabel)
        contentView.addSubview(recordDelButton)
        contentView.addSubview(baseLine)
        recordLabel.ff_AlignInner(.BottomLeft, referView: contentView, size: nil, offset: CGPointMake(9, -9))
        recordDelButton.ff_AlignInner(.BottomRight, referView: contentView, size: CGSizeMake(60, 38), offset: CGPointMake(0, -5))
        baseLine.ff_AlignInner(.BottomCenter, referView: contentView, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 18, 0.5))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DeleteButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.textAlignment = .Right
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.center = CGPointMake((titleLabel?.bounds.width ?? 0) * 0.5 + 10 , 25)
    }
    
}