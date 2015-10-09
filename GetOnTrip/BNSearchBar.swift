//
//  BNSearchBar.swift
//  GetOnTrip
//
//  Created by 王振坤 on 10/7/15.
//  Copyright © 2015 Joshua. All rights reserved.
//

import UIKit

class BNSearchBar: UITextField {
    
    /// 左边图标的名称
    var leftIconName: String?
    
    /// 搜索内容
    var searchCurrent: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
//        borderStyle = UITextBorderStyle.RoundedRect
//        
//        placeholder = searchCurrent
//        
//        let icon = UIImageView(image: UIImage(named: ""))
//        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_searchlist_search_icon"]];
//        self.leftView = icon;
//        self.leftViewMode = UITextFieldViewModeAlways;
//        
//        // 设置清除按钮
//        self.clearButtonMode = UITextFieldViewModeAlways;

    }

}
